import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';
// Try to import common ops if accessible
// If not accessible, I'll rely on dynamic cast or SuperEditorContext

// Represents an item in the slash menu
class SlashMenuItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> keywords;
  final void Function(Editor editor, DocumentNode node) onSelected;

  const SlashMenuItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.keywords = const [],
    required this.onSelected,
  });
}

// Manages the state and logic of the slash menu
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
  List<SlashMenuItem> get filteredItems {
    final q = _query.toLowerCase();
    if (q == _lastFilterQuery && _hasFilterCache) {
      return _filteredItemsCache;
    }

    _lastFilterQuery = q;
    _filteredItemsCache = items.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.keywords.any((k) => k.contains(q));
    }).toList(growable: false);
    _hasFilterCache = true;

    return _filteredItemsCache;
  }

  // The node ID where the menu was triggered
  String? _triggerNodeId;
  // The offset position of the "/" in the text
  int? _triggerOffset;

  SlashMenuPlugin({required this.editor});

  late final List<SlashMenuItem> items = [
    SlashMenuItem(
      id: 'h1',
      title: 'Heading 1',
      subtitle: 'Big section heading',
      icon: Icons.title,
      keywords: ['h1', 'header', 'big'],
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
      keywords: ['ul', 'list', 'bullet'],
      onSelected: (editor, node) =>
          _convertToList(editor, node, ListItemType.unordered),
    ),
    SlashMenuItem(
      id: 'number',
      title: 'Numbered List',
      subtitle: 'Create a list with numbering',
      icon: Icons.format_list_numbered,
      keywords: ['ol', 'list', 'number', 'ordered'],
      onSelected: (editor, node) =>
          _convertToList(editor, node, ListItemType.ordered),
    ),
    SlashMenuItem(
      id: 'quote',
      title: 'Quote',
      subtitle: 'Capture a quote',
      icon: Icons.format_quote,
      keywords: ['quote', 'blockquote'],
      onSelected: (editor, node) => _convertToBlockquote(editor, node),
    ),
    SlashMenuItem(
      id: 'paragraph',
      title: 'Text',
      subtitle: 'Just plain text',
      icon: Icons.text_fields,
      keywords: ['p', 'text', 'paragraph'],
      onSelected: (editor, node) => _convertToParagraph(editor, node),
    ),
  ];

  // Check if we should open/update/close the menu based on the current selection and content
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

    // Procurar "/" mais próximo ANTES do cursor
    final textBeforeCursor = text.substring(0, cursorPosition);
    final lastSlashIndex = textBeforeCursor.lastIndexOf('/');

    if (lastSlashIndex == -1) {
      if (_isOpen) _close();
      return;
    }

    // Extrair query (texto entre "/" e cursor)
    final queryText = textBeforeCursor.substring(lastSlashIndex + 1);

    // Se query contém espaço, fechar (comportamento Notion)
    if (queryText.contains(' ')) {
      if (_isOpen) _close();
      return;
    }

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
      didChange = true;
    }
    if (!_isOpen) {
      _isOpen = true;
      _selectedIndex = 0;
      didChange = true;
    }

    if (didChange) {
      notifyListeners();
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

    int newIndex = _selectedIndex + delta;
    if (newIndex < 0) newIndex = 0;
    if (newIndex >= items.length) newIndex = items.length - 1;

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
      // Check for trigger via selection change mostly, but maybe key event too?
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
        executeSelected(items[_selectedIndex]);
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

    // Calcular range para deletar o comando "/" + query
    final commandLength = 1 + _query.length;
    final textLength = node.text.length;

    // Verificar se o range é válido
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

    // Posição do cursor após deleção (na posição do trigger)
    final newCursorPosition = DocumentPosition(
      nodeId: node.id,
      nodePosition: TextNodePosition(offset: _triggerOffset!),
    );

    // Guardar referências antes de fechar
    final nodeId = node.id;
    final selectedItem = item;
    _close();

    // Executar deleção E atualizar seleção na mesma transação
    editor.execute([
      DeleteContentRequest(documentRange: deleteRange),
      ChangeSelectionRequest(
        DocumentSelection.collapsed(position: newCursorPosition),
        SelectionChangeType.deleteContent,
        SelectionReason.userInteraction,
      ),
    ]);

    // Aplicar estilo após próximo frame para deixar o documento estabilizar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final updatedNode = editor.document.getNodeById(nodeId);
      if (updatedNode != null) {
        selectedItem.onSelected(editor, updatedNode);
      }
    });
  }

  // --- Helper functions for node conversion ---

  void _convertToHeader(Editor editor, DocumentNode node, Attribution blockType) {
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
    // Para converter para parágrafo, removemos qualquer attribution de bloco
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
