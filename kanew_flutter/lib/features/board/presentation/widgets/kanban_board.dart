import 'dart:developer' as developer;

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/router/route_paths.dart';
import '../components/add_list_card.dart';
import '../components/board_group_footer.dart';
import '../components/board_group_header.dart';
import '../controllers/board_view_controller.dart';
import '../dialogs/add_card_dialog.dart';
import '../dialogs/add_list_dialog.dart';
import '../utils/board_data_adapter.dart';
import 'kanban_card.dart';

class KanbanBoard extends StatefulWidget {
  final BoardViewPageController controller;
  final String workspaceSlug;
  final String boardSlug;
  final Board board;

  const KanbanBoard({
    super.key,
    required this.controller,
    required this.workspaceSlug,
    required this.boardSlug,
    required this.board,
  });

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final AppFlowyBoardController _boardController;
  late final AppFlowyBoardScrollController _scrollController;
  late final BoardDataAdapter _adapter;

  @override
  void initState() {
    super.initState();
    _scrollController = AppFlowyBoardScrollController();

    _boardController = AppFlowyBoardController(
      onMoveGroup: _onMoveGroup,
      onMoveGroupItem: _onMoveGroupItem,
      onMoveGroupItemToGroup: _onMoveGroupItemToGroup,
    );

    _adapter = BoardDataAdapter(_boardController);

    // Initial Sync
    _sync();

    // Listen for changes
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant KanbanBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _sync();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _boardController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      _sync();
    }
  }

  void _sync() {
    try {
      _adapter.sync(widget.controller.lists, widget.controller.allCards);
    } catch (e, s) {
      developer.log('Error syncing board data',
          error: e, stackTrace: s, name: 'kanban_board');
    }
  }

  Future<void> _reloadCards() async {
    await widget.controller.reloadCards();
  }

  // ============================================================
  // DRAG & DROP CALLBACKS
  // ============================================================

  void _onMoveGroup(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) {
    developer.log(
      'Move group from $fromIndex to $toIndex',
      name: 'kanban_board',
    );

    widget.controller.moveList(fromIndex, toIndex);
  }

  void _onMoveGroupItem(
    String groupId,
    int fromIndex,
    int toIndex,
  ) {
    developer.log(
      'Move item within $groupId from $fromIndex to $toIndex',
      name: 'kanban_board',
    );

    _adapter.handleMoveCard(groupId, toIndex, widget.controller);
  }

  void _onMoveGroupItemToGroup(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) {
    developer.log(
      'Move item from $fromGroupId:$fromIndex to $toGroupId:$toIndex',
      name: 'kanban_board',
    );

    _adapter.handleMoveCard(toGroupId, toIndex, widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.controller.isLoading && widget.controller.lists.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppFlowyBoard(
              controller: _boardController,
              boardScrollController: _scrollController,
              groupConstraints: const BoxConstraints.tightFor(width: 280),
              config: AppFlowyBoardConfig(
                groupBackgroundColor:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                stretchGroupHeight: false,
                groupCornerRadius: 12,
                groupBodyPadding: const EdgeInsets.all(8),
              ),
              headerBuilder: (context, groupData) => BoardGroupHeader(
                groupData: groupData,
                lists: widget.controller.lists,
                onDelete: (listId) => widget.controller.deleteList(listId),
              ),
              footerBuilder: (context, groupData) => BoardGroupFooter(
                groupData: groupData,
                onAddCard: () => showAddCardDialog(
                  context,
                  int.parse(groupData.id),
                  widget.controller,
                ),
              ),
              cardBuilder: (context, group, groupItem) {
                if (groupItem is! CardBoardItem) {
                  return const SizedBox(); // Ignore phantom items
                }
                final cardItem = groupItem;
                return AppFlowyGroupCard(
                  key: ObjectKey(cardItem),
                  child: KanbanCard(
                    card: cardItem.card,
                    onTap: () async {
                      widget.controller.selectCard(cardItem.card);
                      developer.log(
                        'Card tapped: ${cardItem.card.title}',
                        name: 'kanban_board',
                      );
                      context.go(
                        RoutePaths.cardDetail(
                          widget.workspaceSlug,
                          widget.boardSlug,
                          cardItem.card.id!,
                        ),
                      );
                    },
                    onDelete: () async {
                      await widget.controller.deleteCard(cardItem.card.id!);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          AddListCard(
            onTap: () => showAddListDialog(context, widget.controller),
          ),
        ],
      ),
    );
  }
}
