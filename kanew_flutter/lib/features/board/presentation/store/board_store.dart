import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

/// Store responsible for maintaining the state of the active Board.
/// Acts as a Single Source of Truth for BoardView and CardDetail.
class BoardStore extends ChangeNotifier {
  Board? _board;
  List<CardList> _lists = [];
  List<Card> _allCards = [];

  Board? get board => _board;
  List<CardList> get lists => _lists;
  List<Card> get allCards => _allCards;

  /// Returns cards for a specific list
  List<Card> getCardsForList(int listId) {
    return _allCards.where((c) => c.listId == listId).toList();
  }

  /// Initializes the store with fresh data
  void initData({
    required Board board,
    required List<CardList> lists,
    required List<Card> cards,
  }) {
    _board = board;
    _lists = lists;
    _allCards = cards;
    notifyListeners();
  }

  /// Clears the state (useful when leaving the board)
  void clear() {
    _board = null;
    _lists = [];
    _allCards = [];
    notifyListeners();
  }

  // --- Board Operations ---

  void updateBoard(Board updatedBoard) {
    if (_board?.id == updatedBoard.id) {
      _board = updatedBoard;
      notifyListeners();
    }
  }

  // --- List Operations ---

  void addList(CardList list) {
    _lists.add(list);
    notifyListeners();
  }

  void updateList(CardList updatedList) {
    final index = _lists.indexWhere((l) => l.id == updatedList.id);
    if (index != -1) {
      _lists[index] = updatedList;
      notifyListeners();
    }
  }

  void removeList(int listId) {
    _lists.removeWhere((l) => l.id == listId);
    _allCards.removeWhere((c) => c.listId == listId);
    notifyListeners();
  }

  void setLists(List<CardList> newLists) {
    _lists = newLists;
    notifyListeners();
  }

  // --- Card Operations ---

  void addCard(Card card) {
    _allCards.add(card);
    notifyListeners();
  }

  void updateCard(Card updatedCard) {
    final index = _allCards.indexWhere((c) => c.id == updatedCard.id);
    if (index != -1) {
      _allCards[index] = updatedCard;
      notifyListeners();
    }
  }

  void removeCard(int cardId) {
    _allCards.removeWhere((c) => c.id == cardId);
    notifyListeners();
  }
}
