import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/di/injection.dart';
import '../store/board_filter_store.dart';
import 'filter_popover.dart';

/// Board Header - displays board title and actions
///
/// Shows the board title (editable inline), back button, and action menu.
class BoardHeader extends StatefulWidget {
  final Board board;
  final String workspaceSlug;
  final VoidCallback onBack;
  final Future<void> Function(String newTitle)? onTitleChanged;

  const BoardHeader({
    super.key,
    required this.board,
    required this.workspaceSlug,
    required this.onBack,
    this.onTitleChanged,
  });

  @override
  State<BoardHeader> createState() => _BoardHeaderState();
}

class _BoardHeaderState extends State<BoardHeader> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.board.title);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(BoardHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.board.title != widget.board.title && !_isEditing) {
      _titleController.text = widget.board.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _saveTitle();
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _titleController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _titleController.text.length,
      );
    });
  }

  Future<void> _saveTitle() async {
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.board.title) {
      await widget.onTitleChanged?.call(newTitle);
    } else {
      _titleController.text = widget.board.title;
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
            tooltip: 'Voltar aos boards',
          ),

          const SizedBox(width: 8),

          // Board title (editable)
          Expanded(
            child: _isEditing
                ? _buildEditableTitle()
                : _buildTitle(colorScheme),
          ),

          // Filter button
          FilterPopover(
            filterStore: getIt<BoardFilterStore>(),
          ),

          const SizedBox(width: 8),

          // Actions menu
          _buildActionsMenu(colorScheme),
        ],
      ),
    );
  }

  Widget _buildTitle(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _startEditing,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.board.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              FIcons.pen,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTitle() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: _titleController,
        focusNode: _focusNode,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onSubmitted: (_) => _saveTitle(),
        onEditingComplete: _saveTitle,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildActionsMenu(ColorScheme colorScheme) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: colorScheme.onSurface,
      ),
      tooltip: 'Ações do board',
      onSelected: (value) {
        switch (value) {
          case 'rename':
            _startEditing();
            break;
          case 'delete':
            _showDeleteConfirmation();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 12),
              Text('Renomear'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: colorScheme.error),
              const SizedBox(width: 12),
              Text('Excluir', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir board'),
        content: Text(
          'Tem certeza que deseja excluir "${widget.board.title}"?\n\n'
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Call delete and navigate back
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
