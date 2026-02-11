import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'checklist_card.dart';

class ChecklistSection extends StatelessWidget {
  final List<Checklist> checklists;
  final Map<UuidValue, List<ChecklistItem>> checklistItems;
  final void Function(UuidValue checklistId, String title) onAddItem;
  final void Function(UuidValue checklistId) onDeleteChecklist;
  final void Function(UuidValue checklistId, UuidValue itemId, bool isChecked) onToggleItem;
  final void Function(UuidValue checklistId, UuidValue itemId) onDeleteItem;

  const ChecklistSection({
    super.key,
    required this.checklists,
    required this.checklistItems,
    required this.onAddItem,
    required this.onDeleteChecklist,
    required this.onToggleItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    if (checklists.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        ...checklists.map(
          (checklist) {
            final items = checklistItems[checklist.id] ?? [];

            return ChecklistCard(
              checklist: checklist,
              items: items,
              onAddItem: (title) => onAddItem(checklist.id!, title),
              onDelete: () => onDeleteChecklist(checklist.id!),
              onToggleItem: (itemId, isChecked) =>
                  onToggleItem(checklist.id!, itemId, isChecked),
              onDeleteItem: (itemId) => onDeleteItem(checklist.id!, itemId),
            );
          },
        ),
      ],
    );
  }
}
