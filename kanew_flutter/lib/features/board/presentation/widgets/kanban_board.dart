import 'dart:developer' as developer;

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/di/injection.dart';
import '../components/board_group_header.dart';
import '../controllers/board_view_controller.dart';
import '../store/board_filter_store.dart';
import '../utils/board_data_adapter.dart';
import 'kanban_card.dart';

class KanbanBoard extends StatefulWidget {
  final BoardViewPageController controller;
  final String workspaceSlug;
  final String boardSlug;
  final Board board;
  final Future<void> Function(int listId, String title) onAddCard;

  const KanbanBoard({
    super.key,
    required this.controller,
    required this.workspaceSlug,
    required this.boardSlug,
    required this.board,
    required this.onAddCard,
  });

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final AppFlowyBoardController _boardController;
  late final AppFlowyBoardScrollController _scrollController;
  late final BoardDataAdapter _adapter;
  late final BoardFilterStore _filterStore;
  late Listenable _boardDataListenable;

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
    _filterStore = getIt<BoardFilterStore>();

    // Initial Sync
    _sync();

    // Listen for changes
    _boardDataListenable = widget.controller.boardDataListenable;
    _boardDataListenable.addListener(_onBoardDataChanged);
    _filterStore.addListener(_onFilterChanged);
  }

  @override
  void didUpdateWidget(covariant KanbanBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _boardDataListenable.removeListener(_onBoardDataChanged);
      _boardDataListenable = widget.controller.boardDataListenable;
      _boardDataListenable.addListener(_onBoardDataChanged);
      _sync();
    }
  }

  @override
  void dispose() {
    _boardDataListenable.removeListener(_onBoardDataChanged);
    _filterStore.removeListener(_onFilterChanged);
    _boardController.dispose();
    super.dispose();
  }

  void _onBoardDataChanged() {
    if (mounted) {
      _sync();
    }
  }

  void _onFilterChanged() {
    if (mounted) {
      _sync();
    }
  }

  void _sync() {
    try {
      _adapter.sync(
        widget.controller.lists,
        widget.controller.allCards,
        filterStore: _filterStore,
      );
    } catch (e, s) {
      developer.log(
        'Error syncing board data',
        error: e,
        stackTrace: s,
        name: 'kanban_board',
      );
    }
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
    if (kDebugMode) {
      developer.log(
        'Move group from $fromIndex to $toIndex',
        name: 'kanban_board',
      );
    }

    widget.controller.moveList(fromIndex, toIndex);
  }

  void _onMoveGroupItem(
    String groupId,
    int fromIndex,
    int toIndex,
  ) {
    if (kDebugMode) {
      developer.log(
        'Move item within $groupId from $fromIndex to $toIndex',
        name: 'kanban_board',
      );
    }

    _adapter.handleMoveCard(groupId, toIndex, widget.controller);
  }

  void _onMoveGroupItemToGroup(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) {
    if (kDebugMode) {
      developer.log(
        'Move item from $fromGroupId:$fromIndex to $toGroupId:$toIndex',
        name: 'kanban_board',
      );
    }

    _adapter.handleMoveCard(toGroupId, toIndex, widget.controller);
  }

  @override
  Widget build(BuildContext context) {
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
              groupConstraints: const BoxConstraints.tightFor(width: 300),
              config: AppFlowyBoardConfig(
                groupBackgroundColor: Theme.of(context).canvasColor,
                stretchGroupHeight: false,
                groupCornerRadius: 8,
                groupBodyPadding: const EdgeInsets.all(8),
              ),
              headerBuilder: (context, groupData) => BoardGroupHeader(
                groupData: groupData,
                lists: widget.controller.lists,
                onDelete: (listId) => widget.controller.deleteList(listId),
                onAddCard: (listId, title) => widget.onAddCard(listId, title),
              ),

              cardBuilder: (context, group, groupItem) {
                if (groupItem is! CardBoardItem) {
                  return const SizedBox();
                }
                final cardItem = groupItem;
                return AppFlowyGroupCard(
                  decoration: BoxDecoration(color: Colors.transparent),
                  key: ObjectKey(cardItem),
                  child: KanbanCard(
                    cardSummary: cardItem.cardSummary,
                    onTap: () async {
                      if (kDebugMode) {
                        developer.log(
                          'Card tapped: ${cardItem.cardSummary.card.title}',
                          name: 'kanban_board',
                        );
                      }
                      context.go(
                        RoutePaths.cardDetail(
                          widget.workspaceSlug,
                          widget.boardSlug,
                          cardItem.cardSummary.card.uuid.toString(),
                        ),
                      );
                    },
                    onDelete: () async {
                      await widget.controller.deleteCard(
                        cardItem.cardSummary.card.id!,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
