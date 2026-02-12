import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/ui/kanew_ui.dart';
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
    return KanewPopover(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      offset: const Offset(0, 8),
      width: 170,
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      anchor: Icon(
        Icons.more_vert,
        color: colorScheme.onSurface,
      ),
      contentBuilder: (close) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionItem(
            label: 'Renomear',
            icon: Icons.edit_outlined,
            onTap: () {
              close();
              _startEditing();
            },
          ),
          _actionItem(
            label: 'Excluir',
            icon: Icons.delete_outline,
            color: colorScheme.error,
            onTap: () {
              close();
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showKanewConfirmDialog(
      context: context,
      title: 'Excluir board',
      body:
          'Tem certeza que deseja excluir "${widget.board.title}"?\n\n'
          'Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      destructive: true,
      onConfirm: () {
        // TODO: Call delete and navigate back
      },
    );
  }

  Widget _actionItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
