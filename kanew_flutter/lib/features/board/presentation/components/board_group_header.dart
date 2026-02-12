import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/core/ui/kanew_ui.dart';
import 'package:kanew_flutter/core/widgets/editable_inline_text.dart';
import 'package:kanew_flutter/features/board/presentation/dialogs/add_card_dialog.dart';

class BoardGroupHeader extends StatelessWidget {
  final AppFlowyGroupData groupData;
  final List<CardList> lists;
  final Future<void> Function(UuidValue listId) onDelete;
  final Future<void> Function(UuidValue listId, String title) onRename;
  final Future<void> Function(UuidValue listId, String title) onAddCard;

  const BoardGroupHeader({
    super.key,
    required this.groupData,
    required this.lists,
    required this.onDelete,
    required this.onRename,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final listId = UuidValue.fromString(groupData.id);
    final cardList = lists.where((l) => l.id == listId).firstOrNull;
    final title = cardList?.title ?? groupData.headerData.groupName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              SizedBox(
                width: 170,
                child: EditableInlineText(
                  text: title,
                  onSave: (value) => onRename(listId, value),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  editingTextStyle: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
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
                    listId,
                    onAddCard,
                  );
                },
                icon: const Icon(Icons.add_rounded),
              ),
              _buildActionsMenu(context, colorScheme, listId),
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
    return KanewPopover(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      offset: const Offset(0, 8),
      anchorBuilder: (context, controller) => IconButton(
        onPressed: controller.toggle,
        icon: const Icon(Icons.more_horiz_rounded),
      ),
      contentBuilder: (context, close) => Container(
        width: 150,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            close();
            await onDelete(listId);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 16,
                  color: colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Excluir',
                  style: TextStyle(color: colorScheme.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
