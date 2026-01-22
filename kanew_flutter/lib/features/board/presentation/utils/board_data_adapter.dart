import 'package:appflowy_board/appflowy_board.dart';
import 'package:kanew_client/kanew_client.dart';

import '../controllers/board_view_controller.dart';

/// Adapter for Card to work with AppFlowyBoard
class CardBoardItem extends AppFlowyGroupItem {
  final Card card;

  CardBoardItem(this.card);

  @override
  String get id => card.id.toString();
}

/// Adapter to synchronize Domain Data (Kanew) with UI Data (AppFlowyBoard)
class BoardDataAdapter {
  final AppFlowyBoardController boardController;

  BoardDataAdapter(this.boardController);

  /// Synchronizes the board state with the provided lists and cards.
  void sync(List<CardList> lists, List<Card> allCards) {
    final currentGroupIds = List<String>.from(boardController.groupIds);
    final newGroupIds = lists.map((l) => l.id.toString()).toSet();

    // 1. Remove groups that no longer exist
    for (final id in currentGroupIds) {
      if (!newGroupIds.contains(id)) {
        boardController.removeGroup(id);
      }
    }

    // 2. Add new groups or update existing ones
    for (final cardList in lists) {
      final groupId = cardList.id.toString();
      final cardsForList = allCards.where((c) => c.listId == cardList.id).toList();

      if (!currentGroupIds.contains(groupId)) {
        // Add new group
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
        // Update existing group
        _syncGroupItems(groupId, cardsForList);
      }
    }
  }

  void _syncGroupItems(String groupId, List<Card> cards) {
    final group = boardController.getGroupController(groupId);
    if (group == null) return;

    final currentItems = List<AppFlowyGroupItem>.from(group.items);
    final currentIds = currentItems.map((i) => i.id).toSet();
    final newCardIds = cards.map((c) => c.id.toString()).toSet();

    // 1. Remove items not in new list
    for (final item in currentItems) {
      if (!newCardIds.contains(item.id)) {
        boardController.removeGroupItem(groupId, item.id);
      }
    }

    // 2. Add new items
    for (final card in cards) {
      final cardId = card.id.toString();
      if (!currentIds.contains(cardId)) {
        boardController.addGroupItem(groupId, CardBoardItem(card));
      }
    }
  }

  /// Handles drag and drop movement within the same group or between groups
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

    // Check previous item for afterRank
    if (toIndex > 0 && toIndex < items.length) {
      final prevItem = items[toIndex - 1];
      if (prevItem is CardBoardItem) afterRank = prevItem.card.rank;
    }

    // Check next item for beforeRank
    if (toIndex < items.length - 1 && toIndex >= 0) {
      final nextItem = items[toIndex + 1];
      if (nextItem is CardBoardItem) beforeRank = nextItem.card.rank;
    }

    // Get the moved item at the destination index
    // Note: AppFlowyBoard has already updated the UI model at this point
    if (toIndex < items.length && toIndex >= 0) {
       final movedItem = items[toIndex];
       if (movedItem is CardBoardItem) {
         controller.moveCard(
           movedItem.card.id!,
           toListId,
           afterRank: afterRank,
           beforeRank: beforeRank,
         );
       }
    }
  }
}
