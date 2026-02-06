import 'package:flutter/material.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'converters/appflowy_document_converter.dart';
import 'converters/document_converter.dart';
import 'platform/editor_platform_adapter.dart';
import 'rich_text_editor_config.dart';
import 'rich_text_editor_controller.dart';
import 'blocks/block_registry.dart';

/// Widget genérico de rich text editor
/// Não tem conhecimento do domínio (Card, Board, etc)
class RichTextEditor extends StatefulWidget {
  final String? initialContent;
  final RichTextEditorConfig config;
  final ValueChanged<String>? onSave;

  const RichTextEditor({
    super.key,
    this.initialContent,
    this.config = const RichTextEditorConfig(),
    this.onSave,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late final RichTextEditorController _controller;
  late final EditorPlatformAdapter _platformAdapter;
  late final DocumentConverter _converter;

  @override
  void initState() {
    super.initState();

    _converter = AppFlowyDocumentConverter();
    _platformAdapter = EditorPlatformAdapter.current();

    _controller = RichTextEditorController(
      converter: _converter,
      debounce: widget.config.autoSaveDebounce,
      onSave: widget.onSave,
    );

    _controller.initialize(widget.initialContent);
  }

  @override
  void dispose() {
    // Salvar antes de sair
    _controller.saveNow();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final editorState = _controller.editorState;
        if (editorState == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!widget.config.readOnly) {
              // Move cursor to end of document on tap
              final lastNode = editorState.document.root.children.lastOrNull;
              if (lastNode != null) {
                final selection = Selection.collapsed(
                  Position(
                    path: lastNode.path,
                    offset: lastNode.delta?.length ?? 0,
                  ),
                );
                editorState.selection = selection;
              }
            }
          },
          child: Container(
            constraints: BoxConstraints(
              minHeight: 100, // Altura mínima garantida para clicar
              maxHeight: 400,
            ),
            padding: _platformAdapter.keyboardPadding,
            

            child: AppFlowyEditor(
              editorState: editorState,
              editable: !widget.config.readOnly,
              shrinkWrap:
                  false, // Remover shrinkWrap para ocupar o espaço mínimo
              autoFocus: false, // Desabilitar autoFocus para evitar conflitos
              editorStyle: _buildEditorStyle(colorScheme),
              blockComponentBuilders: _buildBlockBuilders(),
              characterShortcutEvents: _buildCharacterShortcuts(),
              commandShortcutEvents: _buildCommandShortcuts(),
            
              
            ),
          ),
        );
      },
    );
  }

  EditorStyle _buildEditorStyle(ColorScheme colorScheme) {
    return EditorStyle(
      padding: EdgeInsets.zero,
      cursorColor: colorScheme.primary,
      selectionColor: colorScheme.primary.withValues(alpha: 0.3),
      dragHandleColor: colorScheme.primary,
      textStyleConfiguration: TextStyleConfiguration(
        text: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          height: 1.6,
        ),
      ),
      textSpanDecorator: null,
    );
  }

  Map<String, BlockComponentBuilder> _buildBlockBuilders() {
    // Registra apenas blocos habilitados na config
    return BlockRegistry.buildFromConfig(widget.config);
  }

  List<CharacterShortcutEvent> _buildCharacterShortcuts() {
    if (!widget.config.enableSlashCommands) return [];

    return [
      // Slash commands para formatos de bloco
      ...standardCharacterShortcutEvents,
    ];
  }

  List<CommandShortcutEvent> _buildCommandShortcuts() {
    return [
      // Atalhos de teclado padrão (Ctrl+B, Ctrl+I, etc)
      ...standardCommandShortcutEvents,
    ];
  }
}
