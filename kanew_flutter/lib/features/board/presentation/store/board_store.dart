import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

/// Store responsible for maintaining the state of the active Board.
/// Acts as a Single Source of Truth for BoardView and CardDetail.
class BoardStore extends ChangeNotifier {
  // Contexto compartilhado (carregado 1x)
  BoardContext? _context;

  // Cards leves para o board
  List<CardSummary> _cardSummaries = [];
  Map<int, List<CardSummary>> _cardsByListId = {};

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
    _rebuildCardsByListId();
    _cardDetailCache.clear();
    notifyListeners();
  }

  /// Returns cards filtered by list
  List<CardSummary> getCardsForList(int listId) {
    return _cardsByListId[listId] ?? const [];
  }

  /// Adds/updates CardDetail in cache
  void cacheCardDetail(CardDetail detail) {
    _cardDetailCache[detail.card.id!] = detail;
    // Also update the corresponding summary
    _updateCardSummaryFromDetail(detail);
    _rebuildCardsByListId();
    notifyListeners();
  }

  /// Updates only the Card (basic data)
  void updateCard(Card updatedCard) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == updatedCard.id);
    if (index != -1) {
      _cardSummaries[index] = _cardSummaries[index].copyWith(card: updatedCard);
      // Invalidate detail cache
      _cardDetailCache.remove(updatedCard.id);
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  /// Updates card and sorts if priority changed
  /// Used by realtime events to update and potentially reorder
  void updateCardAndSort(Card updatedCard) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == updatedCard.id);
    if (index != -1) {
      final oldPriority = _cardSummaries[index].card.priority;
      _cardSummaries[index] = _cardSummaries[index].copyWith(card: updatedCard);

      // Sort if priority changed
      if (oldPriority != updatedCard.priority) {
        _sortCards();
      }

      // Invalidate detail cache
      _cardDetailCache.remove(updatedCard.id);
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  /// Adds new card (receives CardSummary from endpoint)
  void addCard(CardSummary summary) {
    _cardSummaries.add(summary);
    _sortCards();
    _rebuildCardsByListId();
    notifyListeners();
  }

  /// Adds card from realtime event (avoiding duplicates)
  void addCardFromEvent(CardSummary summary) {
    final exists = _cardSummaries.any((c) => c.card.id == summary.card.id);
    if (!exists) {
      _cardSummaries.add(summary);
      _sortCards();
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  /// Moves card from realtime event
  void moveCardFromEvent({
    required int cardId,
    required int newListId,
    required String newRank,
    required CardPriority priority,
  }) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == cardId);
    if (index != -1) {
      final updatedCard = _cardSummaries[index].card.copyWith(
        listId: newListId,
        rank: newRank,
        priority: priority,
      );
      _cardSummaries[index] = _cardSummaries[index].copyWith(card: updatedCard);
      _sortCards();
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  void removeCard(int cardId) {
    _cardSummaries.removeWhere((c) => c.card.id == cardId);
    _cardDetailCache.remove(cardId);
    _rebuildCardsByListId();
    notifyListeners();
  }

  /// Sorts cards by priority DESC, then rank ASC
  /// This mirrors the server sorting logic
  void _sortCards() {
    _cardSummaries.sort((a, b) {
      final priorityCompare = b.card.priority.index.compareTo(a.card.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return a.card.rank.compareTo(b.card.rank);
    });
  }

  /// Clears the state (useful when leaving the board)
  void clear() {
    _context = null;
    _cardSummaries = [];
    _cardsByListId = {};
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
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  void setLists(List<CardList> newLists) {
    if (_context != null) {
      _context = _context!.copyWith(lists: newLists);
      notifyListeners();
    }
  }

  /// Reorders lists from realtime event (receives ordered IDs)
  void reorderListsFromEvent(List<int> orderedIds) {
    if (_context == null) return;

    final reordered = <CardList>[];
    for (final id in orderedIds) {
      final list = lists.firstWhere((l) => l.id == id, orElse: () => throw Exception('List $id not found'));
      reordered.add(list);
    }

    _context = _context!.copyWith(lists: reordered);
    notifyListeners();
  }

  // --- Label Operations ---

  void addLabel(LabelDef label) {
    if (_context != null) {
      _context = _context!.copyWith(labels: [...labels, label]);
      notifyListeners();
    }
  }

  void updateLabel(LabelDef updatedLabel) {
    if (_context == null) return;

    final updatedLabels = labels.map((l) => l.id == updatedLabel.id ? updatedLabel : l).toList();
    _context = _context!.copyWith(labels: updatedLabels);
    notifyListeners();
  }

  void removeLabel(int labelId) {
    if (_context == null) return;

    _context = _context!.copyWith(labels: labels.where((l) => l.id != labelId).toList());
    notifyListeners();
  }

  void updateCardLabels(int cardId, List<LabelDef> cardLabels) {
    final index = _cardSummaries.indexWhere((c) => c.card.id == cardId);
    if (index != -1) {
      _cardSummaries[index] = _cardSummaries[index].copyWith(cardLabels: cardLabels);
      _cardDetailCache.remove(cardId);
      _rebuildCardsByListId();
      notifyListeners();
    }
  }

  void _rebuildCardsByListId() {
    final map = <int, List<CardSummary>>{};
    for (final summary in _cardSummaries) {
      (map[summary.card.listId] ??= <CardSummary>[]).add(summary);
    }

    _cardsByListId = {
      for (final entry in map.entries)
        entry.key: List<CardSummary>.unmodifiable(entry.value),
    };
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
