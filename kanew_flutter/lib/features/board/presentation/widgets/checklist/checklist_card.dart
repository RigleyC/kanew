import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../../core/utils/ui_helpers.dart';
import '../../../../../core/widgets/checklist_progress_badge.dart';
import 'add_checklist_item_input.dart';
import 'checklist_item_tile.dart';

class ChecklistCard extends StatefulWidget {
  final Checklist checklist;
  final List<ChecklistItem> items;
  final void Function(String title) onAddItem;
  final VoidCallback onDelete;
  final void Function(int itemId, bool isChecked) onToggleItem;
  final void Function(int itemId) onDeleteItem;

  const ChecklistCard({
    super.key,
    required this.checklist,
    required this.items,
    required this.onAddItem,
    required this.onDelete,
    required this.onToggleItem,
    required this.onDeleteItem,
  });

  @override
  State<ChecklistCard> createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> {
  bool _isAddingItem = false;

  void _handleDelete() {
    showConfirmDialog(
      title: 'Excluir checklist?',
      body: 'Todos os itens desta checklist serão excluídos permanentemente.',
      confirmText: 'Excluir',
      onConfirm: widget.onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final completedCount = items.where((i) => i.isChecked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.checklist.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                if (items.isNotEmpty)
                  ChecklistProgressBadge(
                    completedCount: completedCount,
                    totalCount: items.length,
                  ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: _handleDelete,
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Items
        ...items.map(
          (item) => ChecklistItemTile(
            item: item,
            onToggle: (isChecked) => widget.onToggleItem(item.id!, isChecked),
            onDelete: () => widget.onDeleteItem(item.id!),
          ),
        ),

        // Add Item Button/Input
        if (_isAddingItem)
          AddChecklistItemInput(
            onSubmit: (title) {
              widget.onAddItem(title);
              setState(() => _isAddingItem = false);
            },
            onCancel: () => setState(() => _isAddingItem = false),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _isAddingItem = true),
              child: const Text('Adicionar um item'),
            ),
          ),
      ],
    );
  }
}
