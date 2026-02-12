import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'checklist_card.dart';

class ChecklistSection extends StatelessWidget {
  final List<Checklist> checklists;
  final Map<UuidValue, List<ChecklistItem>> checklistItems;
  final void Function(UuidValue checklistId, String title) onAddItem;
  final Future<void> Function(UuidValue checklistId, String title)
  onRenameChecklist;
  final void Function(UuidValue checklistId) onDeleteChecklist;
  final void Function(UuidValue checklistId, UuidValue itemId, bool isChecked)
  onToggleItem;
  final void Function(UuidValue checklistId, UuidValue itemId) onDeleteItem;
  final Future<void> Function(
    UuidValue checklistId,
    UuidValue itemId,
    String title,
  )
  onRenameItem;
  final void Function(UuidValue checklistId, List<UuidValue> orderedItemIds)
  onReorderItems;

  const ChecklistSection({
    super.key,
    required this.checklists,
    required this.checklistItems,
    required this.onAddItem,
    required this.onRenameChecklist,
    required this.onDeleteChecklist,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.onRenameItem,
    required this.onReorderItems,
  });

  @override
  Widget build(BuildContext context) {
    if (checklists.isEmpty) {
      return const SizedBox.shrink();
    }

    return SliverList.builder(
      itemCount: checklists.length,
      itemBuilder: (context, index) {
        final checklist = checklists[index];
        final items = checklistItems[checklist.id] ?? [];
        return ChecklistCard(
          checklist: checklist,
          items: items,
          onAddItem: (title) => onAddItem(checklist.id!, title),
          onRenameChecklist: (title) => onRenameChecklist(checklist.id!, title),
          onDelete: () => onDeleteChecklist(checklist.id!),
          onToggleItem: (itemId, isChecked) =>
              onToggleItem(checklist.id!, itemId, isChecked),
          onDeleteItem: (itemId) => onDeleteItem(checklist.id!, itemId),
          onRenameItem: (itemId, title) =>
              onRenameItem(checklist.id!, itemId, title),
          onReorderItems: (orderedItemIds) =>
              onReorderItems(checklist.id!, orderedItemIds),
        );
      },
    );
  }
}
