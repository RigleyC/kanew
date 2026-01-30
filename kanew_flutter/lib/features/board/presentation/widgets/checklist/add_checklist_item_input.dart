import 'package:flutter/material.dart';

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
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      widget.onSubmit(title);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Adicionar um item',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _submit,
            child: const Text('Adicionar'),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onCancel,
          ),
        ],
      ),
    );
  }
}
