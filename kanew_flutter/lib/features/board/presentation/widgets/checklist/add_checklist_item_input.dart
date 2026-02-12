import 'package:flutter/material.dart';
import 'package:kanew_flutter/core/widgets/editable_inline_text.dart';

class AddChecklistItemInput extends StatefulWidget {
  final void Function(String title) onSubmit;
  final VoidCallback onCancel;

  const AddChecklistItemInput({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<AddChecklistItemInput> createState() => _AddChecklistItemInputState();
}

class _AddChecklistItemInputState extends State<AddChecklistItemInput> {
  void _submit(String value) {
    final title = value.trim();
    if (title.isNotEmpty) {
      widget.onSubmit(title);
      return;
    }
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) => widget.onCancel(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          spacing: 8,
          children: [
            Icon(
              Icons.check_box_outline_blank_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Expanded(
              child: EditableInlineText(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                editingTextStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: 'Adicionar um item',
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onSave: _submit,
                text: '',
                initiallyEditing: true,
                saveOnFocusLoss: false,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              iconSize: 16,
              icon: const Icon(Icons.close),
              onPressed: widget.onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
