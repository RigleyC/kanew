import 'package:flutter/material.dart';
import '../../../../core/widgets/editable_inline_text.dart';

class CardTitleEditor extends StatefulWidget {
  final String initialTitle;
  final ValueChanged<String> onSave;

  const CardTitleEditor({
    super.key,
    required this.initialTitle,
    required this.onSave,
  });

  @override
  State<CardTitleEditor> createState() => _CardTitleEditorState();
}

class _CardTitleEditorState extends State<CardTitleEditor> {
  @override
  Widget build(BuildContext context) {
    return EditableInlineText(
      text: widget.initialTitle,
      onSave: (newTitle) => widget.onSave(newTitle),
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      editingTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(vertical: 2),
    );
  }
}
