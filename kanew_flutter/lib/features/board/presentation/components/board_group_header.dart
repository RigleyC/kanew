import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

/// Group header widget for AppFlowyBoard
///
/// Shows the list title, card count, and actions menu.
class BoardGroupHeader extends StatelessWidget {
  final AppFlowyGroupData groupData;
  final List<CardList> lists;
  final Future<void> Function(int listId) onDelete;

  const BoardGroupHeader({
    super.key,
    required this.groupData,
    required this.lists,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final listId = int.tryParse(groupData.id) ?? 0;
    final cardList = lists.where((l) => l.id == listId).firstOrNull;
    final title = cardList?.title ?? groupData.headerData.groupName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            '${groupData.items.length}',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          _buildActionsMenu(context, colorScheme, listId),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(
    BuildContext context,
    ColorScheme colorScheme,
    int listId,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        size: 18,
        color: colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.zero,
      splashRadius: 16,
      onSelected: (value) async {
        if (value == 'delete') {
          await onDelete(listId);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text('Excluir', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
