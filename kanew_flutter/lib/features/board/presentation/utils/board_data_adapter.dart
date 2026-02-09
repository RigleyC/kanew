import 'package:appflowy_board/appflowy_board.dart';
import 'package:kanew_client/kanew_client.dart';

import '../controllers/board_view_controller.dart';
import '../store/board_filter_store.dart';

/// Adapter for CardSummary to work with AppFlowyBoard
class CardBoardItem extends AppFlowyGroupItem {
  CardSummary cardSummary;

  CardBoardItem(this.cardSummary);

  @override
  String get id => cardSummary.card.id.toString();
}

/// Adapter to synchronize Domain Data (Kanew) with UI Data (AppFlowyBoard)
class BoardDataAdapter {
  final AppFlowyBoardController boardController;

  BoardDataAdapter(this.boardController);

  /// Synchronizes the board state with the provided lists and cards.
  /// If [filterStore] is provided, only cards that pass the filter are shown.
  void sync(
    List<CardList> lists,
    List<CardSummary> allCards, {
    BoardFilterStore? filterStore,
  }) {
    final filteredCards = filterStore != null
        ? filterStore.filterCards(allCards)
        : allCards;

    final cardsByListId = <int, List<CardSummary>>{};
    for (final summary in filteredCards) {
      (cardsByListId[summary.card.listId] ??= <CardSummary>[]).add(summary);
    }

    final currentGroupIds = List<String>.from(boardController.groupIds);
    final newGroupIds = lists.map((l) => l.id.toString()).toSet();

    for (final id in currentGroupIds) {
      if (!newGroupIds.contains(id)) {
        boardController.removeGroup(id);
      }
    }

    for (final cardList in lists) {
      final groupId = cardList.id.toString();
      final cardsForList = cardsByListId[cardList.id] ?? const <CardSummary>[];

      if (!currentGroupIds.contains(groupId)) {
        final items = List<AppFlowyGroupItem>.from(
          cardsForList.map((c) => CardBoardItem(c)),
        );
        final groupData = AppFlowyGroupData<AppFlowyGroupItem>(
          id: groupId,
          name: cardList.title,
          items: items,
        );
        boardController.addGroup(groupData);
      } else {
        _syncGroupItems(groupId, cardsForList);
      }
    }
  }

  void _syncGroupItems(String groupId, List<CardSummary> cards) {
    final group = boardController.getGroupController(groupId);
    if (group == null) return;

    final currentItems = List<AppFlowyGroupItem>.from(group.items);
    final currentById = <String, AppFlowyGroupItem>{
      for (final item in currentItems) item.id: item,
    };
    final newCardIds = <String>{for (final c in cards) c.card.id.toString()};

    for (final item in currentItems) {
      if (!newCardIds.contains(item.id)) {
        boardController.removeGroupItem(groupId, item.id);
      }
    }

    for (final card in cards) {
      final cardId = card.card.id.toString();
      final existingItem = currentById[cardId];
      if (existingItem == null) {
        boardController.addGroupItem(groupId, CardBoardItem(card));
      } else {
        if (existingItem is CardBoardItem &&
            existingItem.cardSummary.card != card.card) {
          existingItem.cardSummary = card;
        }
      }
    }
  }

  void handleMoveCard(
    String toGroupId,
    int toIndex,
    BoardViewPageController controller,
  ) {
    final toListId = int.parse(toGroupId);
    final toGroup = boardController.getGroupController(toGroupId);
    if (toGroup == null) return;

    final items = toGroup.items;
    String? afterRank;
    String? beforeRank;

    if (toIndex > 0 && toIndex < items.length) {
      final prevItem = items[toIndex - 1];
      if (prevItem is CardBoardItem) afterRank = prevItem.cardSummary.card.rank;
    }

    if (toIndex < items.length - 1 && toIndex >= 0) {
      final nextItem = items[toIndex + 1];
      if (nextItem is CardBoardItem) {
        beforeRank = nextItem.cardSummary.card.rank;
      }
    }

    if (toIndex < items.length && toIndex >= 0) {
      final movedItem = items[toIndex];
      if (movedItem is CardBoardItem) {
        controller.moveCard(
          movedItem.cardSummary.card.id!,
          toListId,
          afterRank: afterRank,
          beforeRank: beforeRank,
        );
      }
    }
  }
}
