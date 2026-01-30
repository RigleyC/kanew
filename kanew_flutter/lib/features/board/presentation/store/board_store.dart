import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

/// Store responsible for maintaining the state of the active Board.
/// Acts as a Single Source of Truth for BoardView and CardDetail.
class BoardStore extends ChangeNotifier {
  // Contexto compartilhado (carregado 1x)
  BoardContext? _context;

  // Cards leves para o board
  List<CardSummary> _cardSummaries = [];

  // Cache de CardDetail (carregados sob demanda)
  final Map<int, CardDetail> _cardDetailCache = {};

  // Getters
  BoardContext? get context => _context;
  Board? get board => _context?.board;
  Workspace? get workspace => _context?.workspace;
  List<CardList> get lists => _context?.lists ?? [];
  List<LabelDef> get labels => _context?.labels ?? [];
  List<WorkspaceMember> get members => _context?.members ?? [];
  List<CardSummary> get cards => _cardSummaries;

  /// Initializes the store with BoardWithCards data
  void initFromBoardWithCards(BoardWithCards data) {
    _context = data.context;
    _cardSummaries = data.cards;
    _cardDetailCache.clear();
    notifyListeners();
  }

  /// Returns cards filtered by list
  List<CardSummary> getCardsForList(int listId) {
    return _cardSummaries.where((c) => c.card.listId == listId).toList();
  }

  /// Adds/updates CardDetail in cache
  void cacheCardDetail(CardDetail detail) {
    _cardDetailCache[detail.card.id!] = detail;
    // Also update the corresponding summary
    _updateCardSummaryFromDetail(detail);
    notifyListeners();
  }

  /// Updates only the Card (basic data)
  void updateCard(Card updatedCard) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == updatedCard.id);
    if (index != -1) {
      _cardSummaries[index] = _cardSummaries[index].copyWith(card: updatedCard);
      // Invalidate detail cache
      _cardDetailCache.remove(updatedCard.id);
      notifyListeners();
    }
  }

  /// Adds new card (receives CardSummary from endpoint)
  void addCard(CardSummary summary) {
    _cardSummaries.add(summary);
    notifyListeners();
  }

  void removeCard(int cardId) {
    _cardSummaries.removeWhere((c) => c.card.id == cardId);
    _cardDetailCache.remove(cardId);
    notifyListeners();
  }

  /// Clears the state (useful when leaving the board)
  void clear() {
    _context = null;
    _cardSummaries = [];
    _cardDetailCache.clear();
    notifyListeners();
  }

  // --- Board Operations ---

  void updateBoard(Board updatedBoard) {
    if (_context?.board.id == updatedBoard.id) {
      _context = _context!.copyWith(board: updatedBoard);
      notifyListeners();
    }
  }

  // --- List Operations ---

  void addList(CardList list) {
    if (_context != null) {
      _context = _context!.copyWith(lists: [...lists, list]);
      notifyListeners();
    }
  }

  void updateList(CardList updatedList) {
    if (_context != null) {
      final updatedLists = lists
          .map((l) => l.id == updatedList.id ? updatedList : l)
          .toList();
      _context = _context!.copyWith(lists: updatedLists);
      notifyListeners();
    }
  }

  void removeList(int listId) {
    if (_context != null) {
      _context = _context!.copyWith(
        lists: lists.where((l) => l.id != listId).toList(),
      );
      _cardSummaries.removeWhere((c) => c.card.listId == listId);
      notifyListeners();
    }
  }

  void setLists(List<CardList> newLists) {
    if (_context != null) {
      _context = _context!.copyWith(lists: newLists);
      notifyListeners();
    }
  }

  void _updateCardSummaryFromDetail(CardDetail detail) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == detail.card.id);
    if (index != -1) {
      _cardSummaries[index] = CardSummary(
        card: detail.card,
        cardLabels: detail.cardLabels,
        checklistTotal: detail.checklists.fold(
          0,
          (sum, c) => sum + c.items.length,
        ),
        checklistCompleted: detail.checklists.fold(
          0,
          (sum, c) => sum + c.items.where((i) => i.isChecked).length,
        ),
        attachmentCount: detail.attachments.length,
        commentCount: detail.totalComments,
      );
    }
  }
}
