import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/board_repository.dart';
import '../../data/list_repository.dart';
import '../../data/card_repository.dart';
import '../store/board_store.dart';

class BoardViewPageController extends ChangeNotifier {
  final BoardRepository _boardRepo;
  final ListRepository _listRepo;
  final CardRepository _cardRepo;
  final BoardStore _boardStore;
  
  bool _isLoading = false;
  String? _error;
  
  BoardViewPageController({
    required BoardRepository boardRepo,
    required ListRepository listRepo,
    required CardRepository cardRepo,
    required BoardStore boardStore,
  }) : _boardRepo = boardRepo,
       _listRepo = listRepo,
       _cardRepo = cardRepo,
       _boardStore = boardStore {
    _boardStore.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _boardStore.removeListener(notifyListeners);
    super.dispose();
  }
  
  // Getters delegating to Store
  Board? get board => _boardStore.board;
  List<CardList> get lists => _boardStore.lists;
  List<Card> get allCards => _boardStore.allCards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Card> getCardsForList(int listId) {
    return _boardStore.getCardsForList(listId);
  }
  
  // Load board using slugs only (no workspaceId needed)
  Future<void> load(String workspaceSlug, String boardSlug) async {
    // Prevent reload if already loaded same board
    if (_boardStore.board?.slug == boardSlug) {
      return;
    }

    _isLoading = true;
    _error = null;
    _boardStore.clear(); // Reset store for new board
    notifyListeners();
    
    try {
      // Usa o novo endpoint baseado em slug
      final board = await _boardRepo.getBoardBySlug(workspaceSlug, boardSlug);
      if (board == null) {
        _error = 'Board nao encontrado';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Carregar lists e cards em paralelo
      final results = await Future.wait([
        _listRepo.getLists(board.id!),
        _cardRepo.getCardsByBoard(board.id!),
      ]);
      
      List<CardList> lists = [];
      List<Card> cards = [];

      results[0].fold(
        (f) => _error = f.message,
        (l) => lists = l as List<CardList>,
      );
      
      results[1].fold(
        (f) => _error = f.message,
        (c) => cards = c as List<Card>,
      );

      if (_error == null) {
        _boardStore.initData(board: board, lists: lists, cards: cards);
      }

    } catch (e) {
      _error = 'Erro ao carregar board';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recarrega apenas os cards do board (mais leve que reload completo)
  Future<void> reloadCards() async {
    if (board == null) return;
    
    final result = await _cardRepo.getCardsByBoard(board!.id!);
    result.fold(
      (f) => _error = f.message,
      (cards) {
        // We could implement a bulk setCards in store, but for now we rely on initData or manual sync
        // Ideally we should have setCards in store. Let's assume we just want to refresh cards.
        // For now, let's reuse initData preserving board and lists, or add setCards to store.
        // Since we didn't add setCards, let's just re-init.
        _boardStore.initData(
          board: board!,
          lists: lists,
          cards: cards,
        );
      },
    );
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
      (f) { _error = f.message; notifyListeners(); return null; },
      (list) { 
        _boardStore.addList(list);
        return list; 
      },
    );
  }
  
  Future<bool> deleteList(int listId) async {
    final result = await _listRepo.deleteList(listId);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return false; },
      (_) { 
        _boardStore.removeList(listId);
        return true;
      },
    );
  }
  
  Future<bool> moveList(int fromIndex, int toIndex) async {
    // 1. Local Reorder
    if (fromIndex < 0 || fromIndex >= lists.length || toIndex < 0 || toIndex >= lists.length) {
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
      (f) { _error = f.message; notifyListeners(); return false; },
      (lists) { 
        _boardStore.setLists(lists);
        return true; 
      },
    );
  }
  
  // Card operations
  Future<Card?> createCard(int listId, String title) async {
    final result = await _cardRepo.createCard(listId, title);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return null; },
      (card) { 
        _boardStore.addCard(card);
        return card; 
      },
    );
  }
  
  Future<Card?> moveCard(int cardId, int toListId, {String? afterRank, String? beforeRank}) async {
    // 1. Optimistic Update
    final index = allCards.indexWhere((c) => c.id == cardId);
    if (index == -1) return null;

    final originalCard = allCards[index];
    final updatedCard = originalCard.copyWith(listId: toListId);
    
    // Update local state immediately
    _boardStore.updateCard(updatedCard);

    // 2. Call API
    final result = await _cardRepo.moveCard(cardId, toListId, afterRank: afterRank, beforeRank: beforeRank);
    
    return result.fold(
      (f) { 
        // 3. Revert on error
        _boardStore.updateCard(originalCard);
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
      (f) { _error = f.message; notifyListeners(); return false; },
      (_) {
        _boardStore.removeCard(cardId);
        return true;
      },
    );
  }

  void selectCard(Card card) {
    // Just a placeholder if needed for navigation or local state
  }
}
