/* import 'package:flutter/material.dart';
import 'package:kanew_flutter/core/widgets/rich_text_editor/rich_text_editor_super.dart';
import 'package:kanew_flutter/core/widgets/rich_text_editor/rich_text_editor_config.dart';

/// Wrapper que conecta RichTextEditorSuper ao contexto do Card
class CardDescriptionEditorSuper extends StatelessWidget {
  final String? initialDescription;
  final ValueChanged<String> onSave;
  final bool canEdit;

  const CardDescriptionEditorSuper({
    super.key,
    this.initialDescription,
    required this.onSave,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return RichTextEditorSuper(
      initialContent: initialDescription,
      config: RichTextEditorConfig.cardDescription(
        readOnly: !canEdit,
      ),
      onSave: onSave,
    );
  }
}
 */