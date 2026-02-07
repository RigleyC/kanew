import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'converters/super_editor_document_converter.dart';
import 'converters/document_converter_base.dart';
import 'rich_text_editor_config.dart';
import 'rich_text_editor_controller_generic.dart';

/// Widget de rich text editor usando Super Editor
/// Não tem conhecimento do domínio (Card, Board, etc)
class RichTextEditorSuper extends StatefulWidget {
  final String? initialContent;
  final RichTextEditorConfig config;
  final ValueChanged<String>? onSave;

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

  @override
  void initState() {
    super.initState();

    _converter = SuperEditorDocumentConverter();

    _controller = RichTextEditorController<EditorState>(
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
              final doc = editorState.document;
              if (doc.isNotEmpty) {
                final lastNode = doc.lastOrNull;
                if (lastNode != null) {
                  final selection = DocumentSelection.collapsed(
                    position: DocumentPosition(
                      nodeId: lastNode.id,
                      nodePosition: lastNode.endPosition,
                    ),
                  );
                  // Usa o editor para mudar a seleção
                  editorState.editor.execute([
                    ChangeSelectionRequest(
                      selection,
                      SelectionChangeType.placeCaret,
                      SelectionReason.userInteraction,
                    ),
                  ]);
                }
              }
            }
          },
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 400,
            ),
            padding: const EdgeInsets.all(8),
            child: SuperEditor(
              editor: editorState.editor,
              stylesheet: _buildStylesheet(colorScheme),
              componentBuilders: _buildComponentBuilders(),
              selectionStyle: SelectionStyles(
                selectionColor: colorScheme.primary.withValues(alpha: 0.3),
              ),
              debugPaint: const DebugPaintConfig(),
            ),
          ),
        );
      },
    );
  }

  Stylesheet _buildStylesheet(ColorScheme colorScheme) {
    return defaultStylesheet.copyWith(
      inlineTextStyler: (attributions, existingStyle) {
        return defaultInlineTextStyler(attributions, existingStyle).copyWith(
          color: colorScheme.onSurface,
          fontSize: 14,
          height: 1.6,
        );
      },
      rules: [
        ...defaultStylesheet.rules,
        // Customiza padding dos blocos
        StyleRule(
          BlockSelector.all,
          (doc, node) => {
            Styles.padding: const CascadingPadding.symmetric(vertical: 4),
          },
        ),
      ],
    );
  }

  List<ComponentBuilder> _buildComponentBuilders() {
    final builders = <ComponentBuilder>[];

    // Adiciona builders baseados nos blocos habilitados
    if (widget.config.enabledBlocks.contains(EditorBlockType.paragraph)) {
      builders.add(const ParagraphComponentBuilder());
    }

    if (widget.config.enabledBlocks.contains(EditorBlockType.bulletedList) ||
        widget.config.enabledBlocks.contains(EditorBlockType.numberedList)) {
      builders.add(const ListItemComponentBuilder());
    }

    if (widget.config.enabledBlocks.contains(EditorBlockType.todoList)) {
      // TaskComponentBuilder precisa de um Editor
      // Vamos usar um fallback genérico
      builders.add(const ListItemComponentBuilder());
    }

    // Adiciona builders padrão para blocos restantes
    builders.addAll([
      ...defaultComponentBuilders,
    ]);

    return builders;
  }
}
