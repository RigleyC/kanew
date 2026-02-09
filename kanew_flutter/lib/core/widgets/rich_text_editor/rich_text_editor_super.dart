import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_editor_clipboard/super_editor_clipboard.dart';
import 'converters/html_clipboard_paste.dart';
import 'converters/super_editor_document_converter.dart';
import 'converters/document_converter_base.dart';
import 'rich_text_editor_config.dart';
import 'rich_text_editor_controller_generic.dart';
import 'slash_menu/slash_menu_plugin.dart';
import 'slash_menu/slash_menu_overlay.dart';

/// Widget de rich text editor usando Super Editor
/// Não tem conhecimento do domínio (Card, Board, etc)
class RichTextEditorSuper extends StatefulWidget {
  final String? initialContent;
  final RichTextEditorConfig config;
  final Future<void> Function(String content)? onSave;

  const RichTextEditorSuper({
    super.key,
    this.initialContent,
    this.config = const RichTextEditorConfig(),
    this.onSave,
  });

  @override
  State<RichTextEditorSuper> createState() => _RichTextEditorSuperState();
}

class _RichTextEditorSuperState extends State<RichTextEditorSuper> {
  late final RichTextEditorController<EditorState> _controller;
  late final DocumentConverter<EditorState> _converter;
  late final ScrollController _scrollController;
  final SelectionLayerLinks _selectionLinks = SelectionLayerLinks();
  OverlayEntry? _slashMenuOverlayEntry;
  SlashMenuPlugin? _slashMenuPlugin;

  @override
  void initState() {
    super.initState();

    _converter = SuperEditorDocumentConverter();

    _controller = RichTextEditorController<EditorState>(
      converter: _converter,
      debounce: widget.config.autoSaveDebounce,
      onSave: widget.onSave,
      maxSizeBytes: widget.config.maxDocumentSizeBytes,
    );

    _controller.initialize(widget.initialContent);
    _scrollController = ScrollController();

    // Initialize Slash Menu Plugin only if enabled
    if (widget.config.enableSlashCommands && !widget.config.readOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.editorState != null && mounted) {
          setState(() {
            _slashMenuPlugin = SlashMenuPlugin(
              editor: _controller.editorState!.editor,
            );
          });

          _slashMenuPlugin?.addListener(_onSlashMenuStateChange);
          _controller.editorState!.composer.selectionNotifier.addListener(
            _onSelectionChange,
          );
        }
      });
    }
  }

  void _onSelectionChange() {
    _slashMenuPlugin?.checkForTrigger(
      _controller.editorState?.composer.selection,
    );
  }

  void _onSlashMenuStateChange() {
    final plugin = _slashMenuPlugin;
    if (plugin == null) return;

    if (plugin.isOpen) {
      _showSlashMenuOverlay();
    } else {
      _hideSlashMenuOverlay();
    }
  }

  @override
  void dispose() {
    _hideSlashMenuOverlay();
    if (_controller.editorState != null) {
      _controller.editorState!.composer.selectionNotifier.removeListener(
        _onSelectionChange,
      );
    }
    _slashMenuPlugin?.removeListener(_onSlashMenuStateChange);
    _slashMenuPlugin?.dispose();

    // Salvar antes de sair
    unawaited(_controller.saveNowBestEffort());
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final editorState = _controller.editorState;
    if (editorState == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Return SuperEditor directly. It produces a RenderSliver.
    // Needs to be placed inside a CustomScrollView.
    final isEmptyDoc = _isDocumentEmpty(editorState.document);

    return SuperEditor(
      scrollController: _scrollController,
      editor: editorState.editor,
      selectionLayerLinks: _selectionLinks,
      stylesheet: _buildStylesheet(colorScheme, isEmptyDoc: isEmptyDoc),
      componentBuilders: _buildComponentBuilders(),
      selectionStyle: SelectionStyles(
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
      ),
      documentOverlayBuilders: [
        // Filtrar para evitar duplicação do caret
        ...defaultSuperEditorDocumentOverlayBuilders.where(
          (builder) => builder is! DefaultCaretOverlayBuilder,
        ),
        // Caret customizado
        DefaultCaretOverlayBuilder(
          caretStyle: CaretStyle(
            color: colorScheme.primary,
            width: 2.0,
          ),
        ),
      ],
      // Enable keyboard shortcuts (Cmd+B, etc) and markdown input handlers
      keyboardActions: [
        if (_slashMenuPlugin != null)
          ({
            required SuperEditorContext editContext,
            required KeyEvent keyEvent,
          }) =>
              _slashMenuPlugin!.onKeyEvent(editContext, keyEvent),
        _copyRichTextWhenAvailable,
        _pasteRichTextWhenAvailable,
        ...defaultKeyboardActions,
      ],
    );
  }

  ExecutionInstruction _copyRichTextWhenAvailable({
    required SuperEditorContext editContext,
    required KeyEvent keyEvent,
  }) {
    if (keyEvent is! KeyDownEvent && keyEvent is! KeyRepeatEvent) {
      return ExecutionInstruction.continueExecution;
    }

    if (!HardwareKeyboard.instance.isMetaPressed &&
        !HardwareKeyboard.instance.isControlPressed) {
      return ExecutionInstruction.continueExecution;
    }

    if (keyEvent.logicalKey != LogicalKeyboardKey.keyC) {
      return ExecutionInstruction.continueExecution;
    }

    // `super_editor_clipboard` uses `super_clipboard`'s `SystemClipboard`.
    // If it's not available on this platform, fall back to the default copy behavior.
    if (SystemClipboard.instance == null) {
      return ExecutionInstruction.continueExecution;
    }

    final selection = editContext.composer.selection;
    if (selection == null) {
      return ExecutionInstruction.continueExecution;
    }
    if (selection.isCollapsed) {
      // Nothing to copy, but we handled the shortcut.
      return ExecutionInstruction.haltExecution;
    }

    unawaited(
      editContext.document.copyAsRichTextWithPlainTextFallback(
        selection: selection,
      ),
    );

    return ExecutionInstruction.haltExecution;
  }

  ExecutionInstruction _pasteRichTextWhenAvailable({
    required SuperEditorContext editContext,
    required KeyEvent keyEvent,
  }) {
    if (keyEvent is! KeyDownEvent) {
      return ExecutionInstruction.continueExecution;
    }

    if (!HardwareKeyboard.instance.isMetaPressed &&
        !HardwareKeyboard.instance.isControlPressed) {
      return ExecutionInstruction.continueExecution;
    }

    if (keyEvent.logicalKey != LogicalKeyboardKey.keyV) {
      return ExecutionInstruction.continueExecution;
    }

    // `super_editor_clipboard` uses `super_clipboard`'s `SystemClipboard`.
    // If it's not available on this platform, fall back to the default paste behavior.
    if (SystemClipboard.instance == null) {
      return ExecutionInstruction.continueExecution;
    }

    // Use the upstream clipboard pipeline, but intercept HTML so we can normalize headings.
    unawaited(
      pasteIntoEditorFromNativeClipboard(
        editContext.editor,
        customInserter: _pasteHtmlWithHeadingFixFromClipboard,
      ),
    );

    return ExecutionInstruction.haltExecution;
  }

  Future<bool> _pasteHtmlWithHeadingFixFromClipboard(
    Editor editor,
    ClipboardReader clipboardReader,
  ) async {
    // Prefer the default pipeline for bitmap images.
    for (final bitmapFormat in const [
      Formats.png,
      Formats.jpeg,
      Formats.gif,
      Formats.bmp,
      Formats.webp,
    ]) {
      if (clipboardReader.canProvide(bitmapFormat)) {
        return false;
      }
    }

    if (!clipboardReader.canProvide(Formats.htmlText)) {
      return false;
    }

    final completer = Completer<bool>();
    clipboardReader.getValue(
      Formats.htmlText,
      (html) {
        if (html == null) {
          completer.complete(false);
          return;
        }

        pasteHtmlIntoEditorWithHeadingFix(editor, html);
        completer.complete(true);
      },
      onError: (_) {
        completer.complete(false);
      },
    );

    return completer.future;
  }

  void _showSlashMenuOverlay() {
    if (_slashMenuOverlayEntry != null) {
      _slashMenuOverlayEntry!.markNeedsBuild();
      return;
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    _slashMenuOverlayEntry = OverlayEntry(
      builder: (overlayContext) {
        final plugin = _slashMenuPlugin;
        if (plugin == null || !plugin.isOpen) {
          return const SizedBox.shrink();
        }

        return IgnorePointer(
          ignoring: false,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Follower.withOffset(
                  link: _selectionLinks.caretLink,
                  leaderAnchor: Alignment.bottomLeft,
                  followerAnchor: Alignment.topLeft,
                  offset: const Offset(0, 8),
                  showWhenUnlinked: false,
                  child: SlashMenuOverlay(plugin: plugin),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(_slashMenuOverlayEntry!);
  }

  void _hideSlashMenuOverlay() {
    _slashMenuOverlayEntry?.remove();
    _slashMenuOverlayEntry = null;
  }

  Stylesheet _buildStylesheet(
    ColorScheme colorScheme, {
    required bool isEmptyDoc,
  }) {
    final minHeight = widget.config.minHeight ?? 0;
    final extraBottomPadding =
        isEmptyDoc ? math.max(0, minHeight - 24) : 0;
    return Stylesheet(
      rules: [
        // Base style for all blocks
        StyleRule(
          BlockSelector.all,
          (doc, docNode) {
            return {
              Styles.padding: CascadingPadding.only(
                top: 4,
                bottom: 4 + extraBottomPadding.toDouble(),
              ),
              Styles.textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                height: 1.6,
              ),
            };
          },
        ),
        // Header 1
        StyleRule(
          const BlockSelector("header1"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 16, bottom: 8),
              Styles.textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            };
          },
        ),
        // Header 2
        StyleRule(
          const BlockSelector("header2"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 12, bottom: 6),
              Styles.textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            };
          },
        ),
        // Header 3
        StyleRule(
          const BlockSelector("header3"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 10, bottom: 4),
              Styles.textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            };
          },
        ),
        // Blockquote
        StyleRule(
          const BlockSelector("blockquote"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(
                left: 16,
                top: 8,
                bottom: 8,
              ),
              Styles.textStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            };
          },
        ),
        // List items
        StyleRule(
          const BlockSelector("listItem"),
          (doc, docNode) {
            return {
              Styles.padding: const CascadingPadding.only(top: 4),
            };
          },
        ),
      ],
      inlineTextStyler: (attributions, existingStyle) {
        return defaultInlineTextStyler(attributions, existingStyle).copyWith(
          color: colorScheme.onSurface,
        );
      },
    );
  }

  List<ComponentBuilder> _buildComponentBuilders() {
    final builders = <ComponentBuilder>[];

    void addIfMissing(ComponentBuilder builder) {
      if (builders.any((b) => b.runtimeType == builder.runtimeType)) {
        return;
      }
      builders.add(builder);
    }
/* 
    if (widget.config.placeholder.isNotEmpty) {
      addIfMissing(
        HintComponentBuilder(
          hint: widget.config.placeholder,
          hintStyleBuilder: (context) => TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      );
    } */

    if (widget.config.enabledBlocks.contains(EditorBlockType.paragraph)) {
      addIfMissing(const ParagraphComponentBuilder());
    }

    if (widget.config.enabledBlocks.contains(EditorBlockType.bulletedList) ||
        widget.config.enabledBlocks.contains(EditorBlockType.numberedList)) {
      addIfMissing(const ListItemComponentBuilder());
    }

    if (widget.config.enabledBlocks.contains(EditorBlockType.todoList)) {
      addIfMissing(const ListItemComponentBuilder());
    }

    // Adiciona builders padrão (Set garante unicidade)
    for (final builder in defaultComponentBuilders) {
      addIfMissing(builder);
    }

    return builders;
  }
}

bool _isDocumentEmpty(MutableDocument doc) {
  if (doc.isEmpty) return true;
  if (doc.nodeCount != 1) return false;
  final node = doc.firstOrNull;
  if (node == null) return true;
  if (node is ParagraphNode) {
    return node.text.toPlainText().trim().isEmpty;
  }
  if (node is TextNode) {
    return node.text.toPlainText().trim().isEmpty;
  }
  return false;
}
