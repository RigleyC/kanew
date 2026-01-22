import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Add Card Button - inline input for creating a new card
///
/// This widget provides an expandable input field for creating new cards.
/// When collapsed, shows a simple "Add card" button.
/// When expanded, shows a text field with submit/cancel actions.
class AddCardButton extends StatefulWidget {
  final Future<void> Function(String title) onSubmit;

  const AddCardButton({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddCardButton> createState() => _AddCardButtonState();
}

class _AddCardButtonState extends State<AddCardButton> {
  bool _isExpanded = false;
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isExpanded && _controller.text.isEmpty) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  void _expand() {
    setState(() {
      _isExpanded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _collapse() {
    setState(() {
      _isExpanded = false;
      _controller.clear();
    });
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSubmit(title);
      _controller.clear();
      // Keep expanded for creating more cards
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _focusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isExpanded) {
      return InkWell(
        onTap: _expand,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Icon(
                FIcons.plus,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Adicionar card',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Título do card...',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            enabled: !_isLoading,
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Criar'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isLoading ? null : _collapse,
                icon: const Icon(Icons.close, size: 18),
                tooltip: 'Cancelar',
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
