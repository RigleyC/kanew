import 'package:flutter/material.dart';

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
  bool _isEditing = false;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CardTitleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTitle != oldWidget.initialTitle && !_isEditing) {
      _controller.text = widget.initialTitle;
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
    if (!_focusNode.hasFocus && _isEditing) {
      _save();
    }
  }

  void _save() {
    final newTitle = _controller.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.initialTitle) {
      widget.onSave(newTitle);
    } else {
      _controller.text = widget.initialTitle;
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: (_) => _save(),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _isEditing = true);
        // Delay slightly to allow rebuild with TextField
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) _focusNode.requestFocus();
        });
      },
      child: Text(
        widget.initialTitle,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
