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
  final MenuController _menuController = MenuController();

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
                IconButton(
                  onPressed: () => setState(() => _isAddingItem = true),
                  icon: const Icon(Icons.add_rounded),
                ),
                MenuAnchor(
                  controller: _menuController,
                  menuChildren: [
                    MenuItemButton(
                      onPressed: _handleDelete,
                      leadingIcon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(
                        'Excluir',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert_rounded),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Items
        ...items.map(
          (item) => ChecklistItemTile(
            item: item,
            onToggle: (isChecked) => widget.onToggleItem(item.id!, isChecked),
            onDelete: () => widget.onDeleteItem(item.id!),
          ),
        ),
        if (_isAddingItem)
          AddChecklistItemInput(
            onSubmit: (title) {
              widget.onAddItem(title);
              setState(() => _isAddingItem = false);
            },
            onCancel: () => setState(() => _isAddingItem = false),
          ),
      ],
    );
  }
}
