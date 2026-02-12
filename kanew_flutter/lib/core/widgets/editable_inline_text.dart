import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableInlineText extends StatefulWidget {
  final String text;
  final FutureOr<void> Function(String value) onSave;
  final TextStyle? textStyle;
  final TextStyle? editingTextStyle;
  final InputDecoration? decoration;
  final bool autofocus;
  final bool allowEmpty;
  final int maxLines;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final EdgeInsetsGeometry? padding;

  const EditableInlineText({
    super.key,
    required this.text,
    required this.onSave,
    this.textStyle,
    this.editingTextStyle,
    this.decoration,
    this.autofocus = true,
    this.allowEmpty = false,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.textInputAction = TextInputAction.done,
    this.padding,
  });

  @override
  State<EditableInlineText> createState() => _EditableInlineTextState();
}

class _EditableInlineTextState extends State<EditableInlineText> {
  bool _isEditing = false;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant EditableInlineText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.text != oldWidget.text) {
      _controller.text = widget.text;
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
      unawaited(_save());
    }
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  Future<void> _save() async {
    final trimmed = _controller.text.trim();
    final hasValue = widget.allowEmpty ? true : trimmed.isNotEmpty;
    final valueToPersist = widget.allowEmpty ? trimmed : trimmed;

    if (hasValue && valueToPersist != widget.text) {
      await widget.onSave(valueToPersist);
    } else if (!hasValue) {
      _controller.text = widget.text;
    }

    if (mounted) {
      setState(() => _isEditing = false);
    }
  }

  void _cancelEditing() {
    _controller.text = widget.text;
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              _cancelEditing();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            textAlign: widget.textAlign,
            textInputAction: widget.textInputAction,
            style: widget.editingTextStyle ?? widget.textStyle,
            decoration:
                widget.decoration ??
                const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
            onSubmitted: (_) => unawaited(_save()),
            onEditingComplete: () => unawaited(_save()),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _startEditing,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Text(
          widget.text,
          style: widget.textStyle,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign,
          overflow: widget.maxLines == 1 ? TextOverflow.ellipsis : null,
        ),
      ),
    );
  }
}
