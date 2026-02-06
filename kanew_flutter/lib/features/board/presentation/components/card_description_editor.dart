import 'package:flutter/material.dart';
import '../../../../core/widgets/rich_text_editor/rich_text_editor.dart';
import '../../../../core/widgets/rich_text_editor/rich_text_editor_config.dart';

/// Wrapper que conecta RichTextEditor ao contexto do Card
/// Este é o único arquivo que "sabe" sobre Cards
class CardDescriptionEditor extends StatelessWidget {
  final String? initialDescription;
  final ValueChanged<String> onSave;
  final bool canEdit;

  const CardDescriptionEditor({
    super.key,
    this.initialDescription,
    required this.onSave,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return RichTextEditor(
      initialContent: initialDescription,
      config: RichTextEditorConfig.cardDescription(
        readOnly: !canEdit,
      ),
      onSave: onSave,
    );
  }
}
