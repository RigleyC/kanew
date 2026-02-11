import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/features/board/presentation/dialogs/add_card_dialog.dart';

class BoardGroupHeader extends StatelessWidget {
  final AppFlowyGroupData groupData;
  final List<CardList> lists;
  final Future<void> Function(UuidValue listId) onDelete;
  final Future<void> Function(UuidValue listId, String title) onAddCard;

  const BoardGroupHeader({
    super.key,
    required this.groupData,
    required this.lists,
    required this.onDelete,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final listId = groupData.id;
    final cardList = lists.where((l) => l.id == listId).firstOrNull;
    final title = cardList?.title ?? groupData.headerData.groupName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 12,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${groupData.items.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await showAddCardDialog(
                    context,
                    UuidValue.fromString(groupData.id),
                    onAddCard,
                  );
                },
                icon: const Icon(Icons.add_rounded),
              ),
              _buildActionsMenu(context, colorScheme, UuidValue.fromString(listId)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(
    BuildContext context,
    ColorScheme colorScheme,
    UuidValue listId,
  ) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () async {
            await onDelete(listId);
          },
          leadingIcon: Icon(
            Icons.delete_outline,
            size: 16,
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
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz_rounded),
        );
      },
    );
  }
}
