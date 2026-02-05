import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'index.dart';

class ListSidebarMenu extends StatelessWidget {
  final List<CardList> lists;
  final int currentListId;
  final Function(int listId) onSelect;

  const ListSidebarMenu({
    super.key,
    required this.lists,
    required this.currentListId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SidebarMenuAnchor(
      trigger: Icon(
        Icons.keyboard_arrow_down,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      items: lists.map((list) {
        final isSelected = list.id == currentListId;
        return SidebarMenuItem(
          leading: isSelected
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: colorScheme.primary,
                )
              : null,
          title: Text(
            list.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          onTap: () => onSelect(list.id!),
        );
      }).toList(),
    );
  }
}
