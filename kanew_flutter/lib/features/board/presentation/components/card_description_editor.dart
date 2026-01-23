import 'package:flutter/material.dart';

class CardDescriptionEditor extends StatefulWidget {
  final String? initialDescription;
  final ValueChanged<String> onSave;

  const CardDescriptionEditor({
    super.key,
    this.initialDescription,
    required this.onSave,
  });

  @override
  State<CardDescriptionEditor> createState() => _CardDescriptionEditorState();
}

class _CardDescriptionEditorState extends State<CardDescriptionEditor> {
  bool _isEditing = false;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDescription ?? '');
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CardDescriptionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDescription != oldWidget.initialDescription &&
        !_isEditing) {
      _controller.text = widget.initialDescription ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Note: In the original code, description also saved on blur.
    // However, it also had explicit Save/Cancel buttons.
    // Usually if there are buttons, we might not want auto-save on blur
    // to avoid accidental saves or weird UI jumps, but the original code had it:
    // "if (!_descriptionFocusNode.hasFocus && _isEditingDescription) { _saveDescription(); }"
    // I will keep it consistent with original behavior.
    if (!_focusNode.hasFocus && _isEditing) {
      _save();
    }
  }

  void _save() {
    final newDescription = _controller.text.trim();
    if (newDescription != (widget.initialDescription ?? '')) {
      widget.onSave(newDescription);
    }
    setState(() => _isEditing = false);
  }

  void _cancel() {
    _controller.text = widget.initialDescription ?? '';
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDescription = widget.initialDescription?.isNotEmpty == true;

    if (_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            maxLines: 8,
            minLines: 4,
            decoration: InputDecoration(
              hintText: 'Adicione uma descrição mais detalhada...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton(
                onPressed: _save,
                child: const Text('Salvar'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _cancel,
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _isEditing = true);
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) _focusNode.requestFocus();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          hasDescription
              ? widget.initialDescription!
              : 'Adicione uma descrição mais detalhada...',
          style: TextStyle(
            color: hasDescription
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
