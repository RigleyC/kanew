import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Add List Button - inline input for creating a new list
///
/// Shows a button that expands into an input field when tapped.
class AddListButton extends StatefulWidget {
  final Future<void> Function(String title) onSubmit;

  const AddListButton({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddListButton> createState() => _AddListButtonState();
}

class _AddListButtonState extends State<AddListButton> {
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
      // Keep expanded for creating more lists
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
      return _buildCollapsedButton(colorScheme);
    }

    return _buildExpandedInput(colorScheme);
  }

  Widget _buildCollapsedButton(ColorScheme colorScheme) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: _expand,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FIcons.plus,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Adicionar lista',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedInput(ColorScheme colorScheme) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Nome da lista...',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            enabled: !_isLoading,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
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
                icon: const Icon(Icons.close),
                tooltip: 'Cancelar',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
