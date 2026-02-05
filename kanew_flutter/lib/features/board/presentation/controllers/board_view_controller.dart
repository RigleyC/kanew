import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/board_repository.dart';
import '../../data/list_repository.dart';
import '../../data/card_repository.dart';
import '../../data/board_stream_service.dart';
import '../store/board_store.dart';

class BoardViewPageController extends ChangeNotifier {
  final BoardRepository _boardRepo;
  final ListRepository _listRepo;
  final CardRepository _cardRepo;
  final BoardStore _boardStore;
  final BoardStreamService _streamService;

  bool _isLoading = false;
  String? _error;
  bool _boardDeleted = false;
  StreamSubscription<BoardEvent>? _eventSubscription;

  BoardViewPageController({
    required BoardRepository boardRepo,
    required ListRepository listRepo,
    required CardRepository cardRepo,
    required BoardStore boardStore,
    required BoardStreamService streamService,
  })  : _boardRepo = boardRepo,
        _listRepo = listRepo,
        _cardRepo = cardRepo,
        _boardStore = boardStore,
        _streamService = streamService {
    _boardStore.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _streamService.dispose();
    _boardStore.removeListener(notifyListeners);
    super.dispose();
  }

  // Getters delegating to Store
  Board? get board => _boardStore.board;
  Workspace? get workspace => _boardStore.workspace;
  List<CardList> get lists => _boardStore.lists;
  List<CardSummary> get allCards => _boardStore.cards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get boardDeleted => _boardDeleted;

  /// Exposes stream status for UI (reconnecting toast)
  ValueListenable<StreamStatus> get streamStatus => _streamService.statusNotifier;

  List<CardSummary> getCardsForList(int listId) {
    return _boardStore.getCardsForList(listId);
  }

  // Load board using slugs only (no workspaceId needed)
  Future<void> load(String workspaceSlug, String boardSlug) async {
    debugPrint('DEBUG: BoardViewPageController.load($workspaceSlug, $boardSlug)');

    _isLoading = true;
    _error = null;
    _boardStore.clear();
    notifyListeners();

    try {
      debugPrint('DEBUG: Calling getBoardWithCards($workspaceSlug, $boardSlug)');
      final boardWithCards = await _boardRepo.getBoardWithCards(
        workspaceSlug,
        boardSlug,
      );
      debugPrint(
        'DEBUG: BoardWithCards loaded: ${boardWithCards.cards.length} cards',
      );

      _boardStore.initFromBoardWithCards(boardWithCards);

      // Start streaming after successful load
      await _startStreaming();
    } catch (e) {
      debugPrint('DEBUG: Error loading board: $e');
      _error = 'Erro ao carregar board';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _startStreaming() async {
    if (board == null) return;

    try {
      await _streamService.connect(board!.id!);

      // Subscribe to events
      _eventSubscription = _streamService.events.listen(_handleEvent);

      debugPrint('[BoardViewPageController] Streaming started for board ${board!.id}');
    } catch (e) {
      debugPrint('[BoardViewPageController] Failed to start streaming: $e');
    }
  }

  void _handleEvent(BoardEvent event) {
    debugPrint('[BoardViewPageController] Handling event: ${event.eventType}');

    switch (event.eventType) {
      case BoardEventType.cardCreated:
        _handleCardCreated(event);
        break;
      case BoardEventType.cardUpdated:
        _handleCardUpdated(event);
        break;
      case BoardEventType.cardMoved:
        _handleCardMoved(event);
        break;
      case BoardEventType.cardDeleted:
        _handleCardDeleted(event);
        break;
      case BoardEventType.listCreated:
        _handleListCreated(event);
        break;
      case BoardEventType.listUpdated:
        _handleListUpdated(event);
        break;
      case BoardEventType.listReordered:
        _handleListReordered(event);
        break;
      case BoardEventType.listDeleted:
        _handleListDeleted(event);
        break;
      case BoardEventType.labelCreated:
        _handleLabelCreated(event);
        break;
      case BoardEventType.labelUpdated:
        _handleLabelUpdated(event);
        break;
      case BoardEventType.labelDeleted:
        _handleLabelDeleted(event);
        break;
      case BoardEventType.cardLabelsUpdated:
        _handleCardLabelsUpdated(event);
        break;
      case BoardEventType.boardUpdated:
        _handleBoardUpdated(event);
        break;
      case BoardEventType.boardDeleted:
        _handleBoardDeleted(event);
        break;
      default:
        debugPrint('[BoardViewPageController] Unknown event type: ${event.eventType}');
    }
  }

  void _handleCardCreated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final cardData = payload['card'] as Map<String, dynamic>?;
      if (cardData == null) return;
      final summary = CardSummary.fromJson(cardData);
      _boardStore.addCardFromEvent(summary);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling cardCreated: $e');
    }
  }

  void _handleCardUpdated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final cardData = payload['card'] as Map<String, dynamic>?;
      if (cardData == null) return;
      final card = Card.fromJson(cardData);
      _boardStore.updateCardAndSort(card);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling cardUpdated: $e');
    }
  }

  void _handleCardMoved(BoardEvent event) {
    if (event.payload == null || event.cardId == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      _boardStore.moveCardFromEvent(
        cardId: event.cardId!,
        newListId: payload['newListId'] as int,
        newRank: payload['newRank'] as String,
        priority: CardPriority.values.byName(payload['priority'] as String),
      );
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling cardMoved: $e');
    }
  }

  void _handleCardDeleted(BoardEvent event) {
    if (event.cardId != null) {
      _boardStore.removeCard(event.cardId!);
    }
  }

  void _handleListCreated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final listData = payload['list'] as Map<String, dynamic>?;
      if (listData == null) return;
      final list = CardList.fromJson(listData);
      final exists = lists.any((l) => l.id == list.id);
      if (!exists) {
        _boardStore.addList(list);
      }
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling listCreated: $e');
    }
  }

  void _handleListUpdated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final listData = payload['list'] as Map<String, dynamic>?;
      if (listData == null) return;
      final list = CardList.fromJson(listData);
      _boardStore.updateList(list);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling listUpdated: $e');
    }
  }

  void _handleListReordered(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final orderedIds = (payload['orderedListIds'] as List).cast<int>();
      _boardStore.reorderListsFromEvent(orderedIds);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling listReordered: $e');
    }
  }

  void _handleListDeleted(BoardEvent event) {
    if (event.listId != null) {
      _boardStore.removeList(event.listId!);
    }
  }

  void _handleLabelCreated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final labelData = payload['label'] as Map<String, dynamic>?;
      if (labelData == null) return;
      final label = LabelDef.fromJson(labelData);
      final exists = _boardStore.labels.any((l) => l.id == label.id);
      if (!exists) {
        _boardStore.addLabel(label);
      }
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling labelCreated: $e');
    }
  }

  void _handleLabelUpdated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final labelData = payload['label'] as Map<String, dynamic>?;
      if (labelData == null) return;
      final label = LabelDef.fromJson(labelData);
      _boardStore.updateLabel(label);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling labelUpdated: $e');
    }
  }

  void _handleLabelDeleted(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final labelId = payload['labelId'] as int?;
      if (labelId != null) {
        _boardStore.removeLabel(labelId);
      }
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling labelDeleted: $e');
    }
  }

  void _handleCardLabelsUpdated(BoardEvent event) {
    if (event.payload == null || event.cardId == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final labelsData = payload['labels'] as List?;
      if (labelsData == null) return;
      final labels = labelsData.map((l) => LabelDef.fromJson(l as Map<String, dynamic>)).toList();
      _boardStore.updateCardLabels(event.cardId!, labels);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling cardLabelsUpdated: $e');
    }
  }

  void _handleBoardUpdated(BoardEvent event) {
    if (event.payload == null) return;

    try {
      final payload = jsonDecode(event.payload!) as Map<String, dynamic>;
      final boardData = payload['board'] as Map<String, dynamic>?;
      if (boardData == null) return;
      final updatedBoard = Board.fromJson(boardData);
      _boardStore.updateBoard(updatedBoard);
    } catch (e) {
      debugPrint('[BoardViewPageController] Error handling boardUpdated: $e');
    }
  }

  void _handleBoardDeleted(BoardEvent event) {
    _boardDeleted = true;
    notifyListeners();
  }

  /// Recarrega apenas os cards do board (mais leve que reload completo)
  Future<void> reloadCards() async {
    if (board == null) return;

    try {
      final boardWithCards = await _boardRepo.getBoardWithCards(
        workspace!.slug,
        board!.slug,
      );
      _boardStore.initFromBoardWithCards(boardWithCards);
    } catch (e) {
      _error = 'Erro ao recarregar cards';
    }
    notifyListeners();
  }

  Future<Board?> updateBoard(int boardId, String title) async {
    try {
      final updatedBoard = await _boardRepo.updateBoard(boardId, title);
      _boardStore.updateBoard(updatedBoard);
      return updatedBoard;
    } catch (e) {
      _error = 'Erro ao atualizar board';
      notifyListeners();
      return null;
    }
  }

  // List operations
  Future<CardList?> createList(String title) async {
    if (board == null) return null;

    final result = await _listRepo.createList(board!.id!, title);
    return result.fold(
      (f) {
        _error = f.message;
        notifyListeners();
        return null;
      },
      (list) {
        _boardStore.addList(list);
        return list;
      },
    );
  }

  Future<bool> deleteList(int listId) async {
    final result = await _listRepo.deleteList(listId);
    return result.fold(
      (f) {
        _error = f.message;
        notifyListeners();
        return false;
      },
      (_) {
        _boardStore.removeList(listId);
        return true;
      },
    );
  }

  Future<bool> moveList(int fromIndex, int toIndex) async {
    // 1. Local Reorder
    if (fromIndex < 0 ||
        fromIndex >= lists.length ||
        toIndex < 0 ||
        toIndex >= lists.length) {
      return false;
    }

    final currentLists = List<CardList>.from(lists);
    final movedList = currentLists.removeAt(fromIndex);
    currentLists.insert(toIndex, movedList);

    _boardStore.setLists(currentLists); // Optimistic update UI

    // 2. API Call
    final orderedIds = currentLists.map((l) => l.id!).toList();
    return reorderLists(orderedIds);
  }

  Future<bool> reorderLists(List<int> orderedIds) async {
    if (board == null) return false;

    final result = await _listRepo.reorderLists(board!.id!, orderedIds);
    return result.fold(
      (f) {
        _error = f.message;
        notifyListeners();
        return false;
      },
      (lists) {
        _boardStore.setLists(lists);
        return true;
      },
    );
  }

  // Card operations - now work with CardSummary
  Future<CardSummary?> createCard(int listId, String title) async {
    final result = await _cardRepo.createCardDetail(listId, title);

    CardSummary? summary;
    result.fold(
      (f) {
        _error = f.message;
        notifyListeners();
      },
      (cardDetail) {
        // Convert CardDetail to CardSummary for the board
        summary = CardSummary(
          card: cardDetail.card,
          cardLabels: cardDetail.cardLabels,
          checklistTotal: cardDetail.checklists.fold(
            0,
            (sum, c) => sum + c.items.length,
          ),
          checklistCompleted: cardDetail.checklists.fold(
            0,
            (sum, c) => sum + c.items.where((i) => i.isChecked).length,
          ),
          attachmentCount: cardDetail.attachments.length,
          commentCount: cardDetail.totalComments,
        );
        _boardStore.addCard(summary!);
        notifyListeners();
      },
    );

    return summary;
  }

  Future<Card?> moveCard(
    int cardId,
    int toListId, {
    String? afterRank,
    String? beforeRank,
  }) async {
    // 1. Optimistic Update
    final index = allCards.indexWhere((c) => c.card.id == cardId);
    if (index == -1) return null;

    final originalSummary = allCards[index];
    final updatedCard = originalSummary.card.copyWith(listId: toListId);

    // Update local state immediately
    _boardStore.updateCard(updatedCard);

    // 2. Call API
    final result = await _cardRepo.moveCard(
      cardId,
      toListId,
      afterRank: afterRank,
      beforeRank: beforeRank,
    );

    return result.fold(
      (f) {
        // 3. Revert on error
        _boardStore.updateCard(originalSummary.card);
        _error = f.message;
        notifyListeners();
        return null;
      },
      (card) {
        // 4. Confirm update
        _boardStore.updateCard(card);
        return card;
      },
    );
  }

  Future<bool> deleteCard(int cardId) async {
    final result = await _cardRepo.deleteCard(cardId);
    return result.fold(
      (f) {
        _error = f.message;
        notifyListeners();
        return false;
      },
      (_) {
        _boardStore.removeCard(cardId);
        return true;
      },
    );
  }

  void selectCard(CardSummary card) {
    // Just a placeholder if needed for navigation or local state
  }
}
