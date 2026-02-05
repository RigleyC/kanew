import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:forui/forui.dart';

import '../../../../core/di/injection.dart';
import '../store/board_filter_store.dart';
import 'filter_popover.dart';

class BoardHeader extends StatefulWidget implements PreferredSizeWidget {
  final Board board;
  final String workspaceSlug;
  final VoidCallback onBack;
  final Future<void> Function(String newTitle)? onTitleChanged;
  final Future<void> Function()? onAddList;

  const BoardHeader({
    super.key,
    required this.board,
    required this.workspaceSlug,
    required this.onBack,
    this.onTitleChanged,
    this.onAddList,
  });

  @override
  State<BoardHeader> createState() => _BoardHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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

    return AppBar(
      //TODO Mudar a sidebar pra quando clicar no nome "board" ele descartar as outras paginas e navegar de volta pra listagem e entao remover isso aqui
      automaticallyImplyLeading: true,
      title: _isEditing ? _buildEditableTitle() : _buildTitle(colorScheme),
      actions: [
        IconButton(
          icon: const Icon(FIcons.plus),
          tooltip: 'Adicionar lista',
          onPressed: widget.onAddList,
        ),
        FilterPopover(
          filterStore: getIt<BoardFilterStore>(),
        ),
        _buildActionsMenu(colorScheme),
      ],
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
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: _startEditing,
          leadingIcon: const Icon(Icons.edit_outlined, size: 20),
          child: const Text('Renomear'),
        ),
        MenuItemButton(
          onPressed: _showDeleteConfirmation,
          leadingIcon: Icon(
            Icons.delete_outline,
            size: 20,
            color: colorScheme.error,
          ),
          child: Text(
            'Excluir',
            style: TextStyle(color: colorScheme.error),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurface,
          ),
          tooltip: 'Ações do board',
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
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
