import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

class SlashMenuItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> keywords;
  final void Function(Editor editor, DocumentNode node) onSelected;

  // ✅ Pre-computar lowercase para performance
  late final String _titleLower = title.toLowerCase();
  late final String _subtitleLower = subtitle.toLowerCase();
  late final List<String> _keywordsLower = keywords
      .map((k) => k.toLowerCase())
      .toList(growable: false);

  SlashMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.keywords = const [],
    required this.onSelected,
  });
}

class SlashMenuPlugin extends ChangeNotifier {
  final Editor editor;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  String _query = '';
  String get query => _query;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  String _lastFilterQuery = '';
  List<SlashMenuItem> _filteredItemsCache = const [];
  bool _hasFilterCache = false;

  // ✅ Filtro otimizado
  List<SlashMenuItem> get filteredItems {
    final q = _query.toLowerCase();
    if (q == _lastFilterQuery && _hasFilterCache) {
      return _filteredItemsCache;
    }

    _lastFilterQuery = q;

    if (q.isEmpty) {
      _filteredItemsCache = items;
    } else {
      _filteredItemsCache = items
          .where((item) {
            // ✅ Usa campos pre-computados
            return item._titleLower.contains(q) ||
                item._subtitleLower.contains(q) ||
                item._keywordsLower.any((k) => k.contains(q));
          })
          .toList(growable: false);

      // ✅ Ordenar por relevância
      _filteredItemsCache.sort((a, b) {
        final aStarts = a._titleLower.startsWith(q);
        final bStarts = b._titleLower.startsWith(q);
        if (aStarts && !bStarts) return -1;
        if (!aStarts && bStarts) return 1;
        return 0;
      });
    }

    _hasFilterCache = true;
    return _filteredItemsCache;
  }

  String? _triggerNodeId;
  int? _triggerOffset;

  SlashMenuPlugin({required this.editor});

  late final List<SlashMenuItem> items = [
    SlashMenuItem(
      id: 'h1',
      title: 'Heading 1',
      subtitle: 'Big section heading',
      icon: Icons.title,
      keywords: ['h1', 'header', 'big', 'título'],
      onSelected: (editor, node) =>
          _convertToHeader(editor, node, header1Attribution),
    ),
    SlashMenuItem(
      id: 'h2',
      title: 'Heading 2',
      subtitle: 'Medium section heading',
      icon: Icons.title,
      keywords: ['h2', 'header', 'medium'],
      onSelected: (editor, node) =>
          _convertToHeader(editor, node, header2Attribution),
    ),
    SlashMenuItem(
      id: 'h3',
      title: 'Heading 3',
      subtitle: 'Small section heading',
      icon: Icons.title,
      keywords: ['h3', 'header', 'small'],
      onSelected: (editor, node) =>
          _convertToHeader(editor, node, header3Attribution),
    ),
    SlashMenuItem(
      id: 'bullet',
      title: 'Bullet List',
      subtitle: 'Create a simple bulleted list',
      icon: Icons.format_list_bulleted,
      keywords: ['ul', 'list', 'bullet', 'pontos'],
      onSelected: (editor, node) =>
          _convertToList(editor, node, ListItemType.unordered),
    ),
    SlashMenuItem(
      id: 'number',
      title: 'Numbered List',
      subtitle: 'Create a list with numbering',
      icon: Icons.format_list_numbered,
      keywords: ['ol', 'list', 'number', 'ordered', 'numerada'],
      onSelected: (editor, node) =>
          _convertToList(editor, node, ListItemType.ordered),
    ),
    SlashMenuItem(
      id: 'quote',
      title: 'Quote',
      subtitle: 'Capture a quote',
      icon: Icons.format_quote,
      keywords: ['quote', 'blockquote', 'citação'],
      onSelected: (editor, node) => _convertToBlockquote(editor, node),
    ),
    SlashMenuItem(
      id: 'paragraph',
      title: 'Text',
      subtitle: 'Just plain text',
      icon: Icons.text_fields,
      keywords: ['p', 'text', 'paragraph', 'texto'],
      onSelected: (editor, node) => _convertToParagraph(editor, node),
    ),
  ];

  void checkForTrigger(DocumentSelection? selection) {
    if (selection == null || !selection.isCollapsed) {
      if (_isOpen) _close();
      return;
    }

    final node = editor.document.getNodeById(selection.extent.nodeId);
    if (node is! ParagraphNode) {
      if (_isOpen) _close();
      return;
    }

    final text = node.text.toPlainText();
    final cursorPosition =
        (selection.extent.nodePosition as TextNodePosition).offset;

    final textBeforeCursor = text.substring(0, cursorPosition);
    final lastSlashIndex = textBeforeCursor.lastIndexOf('/');

    if (lastSlashIndex == -1) {
      if (_isOpen) _close();
      return;
    }

    final queryText = textBeforeCursor.substring(lastSlashIndex + 1);

    if (queryText.contains(' ')) {
      if (_isOpen) _close();
      return;
    }

    // ✅ Batching de mudanças para evitar múltiplos notifyListeners
    var didChange = false;

    if (_triggerNodeId != node.id) {
      _triggerNodeId = node.id;
      didChange = true;
    }
    if (_triggerOffset != lastSlashIndex) {
      _triggerOffset = lastSlashIndex;
      didChange = true;
    }
    if (_query != queryText) {
      _query = queryText;
      _filteredItemsCache = const [];
      _hasFilterCache = false;
      if (_selectedIndex != 0) {
        _selectedIndex = 0;
      }
      didChange = true;
    }
    if (!_isOpen) {
      _isOpen = true;
      _selectedIndex = 0;
      didChange = true;
    }

    if (didChange) {
      notifyListeners(); // ✅ Só notifica se mudou
    }
  }

  void _close() {
    if (!_isOpen) return;
    _isOpen = false;
    _query = '';
    _selectedIndex = 0;
    _triggerNodeId = null;
    _triggerOffset = null;
    _filteredItemsCache = const [];
    _lastFilterQuery = '';
    _hasFilterCache = false;
    notifyListeners();
  }

  void _moveSelection(int delta) {
    final items = filteredItems;
    if (items.isEmpty) return;

    final newIndex = (_selectedIndex + delta).clamp(0, items.length - 1);

    if (newIndex != _selectedIndex) {
      _selectedIndex = newIndex;
      notifyListeners();
    }
  }

  ExecutionInstruction onKeyEvent(dynamic context, KeyEvent keyEvent) {
    if (keyEvent is! KeyDownEvent) {
      return ExecutionInstruction.continueExecution;
    }

    if (!_isOpen) {
      return ExecutionInstruction.continueExecution;
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-1);
      return ExecutionInstruction.haltExecution;
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveSelection(1);
      return ExecutionInstruction.haltExecution;
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      final items = filteredItems;
      if (items.isNotEmpty) {
        final safeIndex = _selectedIndex.clamp(0, items.length - 1);
        executeSelected(items[safeIndex]);
        return ExecutionInstruction.haltExecution;
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return ExecutionInstruction.haltExecution;
    }

    return ExecutionInstruction.continueExecution;
  }

  void executeSelected(SlashMenuItem item) {
    if (_triggerNodeId == null || _triggerOffset == null) return;

    final node = editor.document.getNodeById(_triggerNodeId!);
    if (node is! ParagraphNode) return;

    final commandLength = 1 + _query.length;
    final textLength = node.text.length;
    final endOffset = _triggerOffset! + commandLength;

    if (endOffset > textLength) {
      _close();
      return;
    }

    final deleteRange = DocumentRange(
      start: DocumentPosition(
        nodeId: node.id,
        nodePosition: TextNodePosition(offset: _triggerOffset!),
      ),
      end: DocumentPosition(
        nodeId: node.id,
        nodePosition: TextNodePosition(offset: endOffset),
      ),
    );

    final newCursorPosition = DocumentPosition(
      nodeId: node.id,
      nodePosition: TextNodePosition(offset: _triggerOffset!),
    );

    final nodeId = node.id;
    final selectedItem = item;
    _close();

    editor.execute([
      DeleteContentRequest(documentRange: deleteRange),
      ChangeSelectionRequest(
        DocumentSelection.collapsed(position: newCursorPosition),
        SelectionChangeType.deleteContent,
        SelectionReason.userInteraction,
      ),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final updatedNode = editor.document.getNodeById(nodeId);
      if (updatedNode != null) {
        selectedItem.onSelected(editor, updatedNode);
      }
    });
  }

  void _convertToHeader(
    Editor editor,
    DocumentNode node,
    Attribution blockType,
  ) {
    editor.execute([
      ChangeParagraphBlockTypeRequest(
        nodeId: node.id,
        blockType: blockType,
      ),
    ]);
  }

  void _convertToList(Editor editor, DocumentNode node, ListItemType type) {
    editor.execute([
      ConvertParagraphToListItemRequest(
        nodeId: node.id,
        type: type,
      ),
    ]);
  }

  void _convertToBlockquote(Editor editor, DocumentNode node) {
    editor.execute([
      ChangeParagraphBlockTypeRequest(
        nodeId: node.id,
        blockType: blockquoteAttribution,
      ),
    ]);
  }

  void _convertToParagraph(Editor editor, DocumentNode node) {
    if (node is ParagraphNode) {
      editor.execute([
        ChangeParagraphBlockTypeRequest(
          nodeId: node.id,
          blockType: null,
        ),
      ]);
    }
  }
}
