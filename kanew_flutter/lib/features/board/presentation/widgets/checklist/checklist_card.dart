import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../../core/ui/kanew_ui.dart';
import '../../../../../core/utils/ui_helpers.dart';
import '../../../../../core/widgets/editable_inline_text.dart';
import '../../../../../core/widgets/checklist_progress_badge.dart';
import 'add_checklist_item_input.dart';
import 'checklist_item_tile.dart';

class ChecklistCard extends StatefulWidget {
  final Checklist checklist;
  final List<ChecklistItem> items;
  final void Function(String title) onAddItem;
  final Future<void> Function(String title) onRenameChecklist;
  final VoidCallback onDelete;
  final void Function(UuidValue itemId, bool isChecked) onToggleItem;
  final void Function(UuidValue itemId) onDeleteItem;
  final Future<void> Function(UuidValue itemId, String title) onRenameItem;
  final void Function(List<UuidValue> orderedItemIds) onReorderItems;

  const ChecklistCard({
    super.key,
    required this.checklist,
    required this.items,
    required this.onAddItem,
    required this.onRenameChecklist,
    required this.onDelete,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.onRenameItem,
    required this.onReorderItems,
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

  void _handleReorder(int oldIndex, int newIndex) {
    final reordered = List<ChecklistItem>.from(widget.items);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    widget.onReorderItems(reordered.map((item) => item.id!).toList());
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
            Expanded(
              child: EditableInlineText(
                text: widget.checklist.title,
                onSave: widget.onRenameChecklist,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                editingTextStyle: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
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
                KanewPopover(
                  menuAnchor: Alignment.topRight,
                  childAnchor: Alignment.bottomRight,
                  offset: const Offset(0, 8),
                  width: 150,
                  anchor: const Icon(Icons.more_vert_rounded),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  contentBuilder: (close) => InkWell(
                    onTap: () {
                      close();
                      _handleDelete();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Excluir',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Items
        if (items.isNotEmpty)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: items.length,
            onReorder: _handleReorder,
            itemBuilder: (context, index) {
              final item = items[index];
              return ChecklistItemTile(
                key: ValueKey(item.id),
                item: item,
                onToggle: (isChecked) =>
                    widget.onToggleItem(item.id!, isChecked),
                onDelete: () => widget.onDeleteItem(item.id!),
                onRename: (title) => widget.onRenameItem(item.id!, title),
                dragHandle: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_indicator_rounded, size: 18),
                ),
              );
            },
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
