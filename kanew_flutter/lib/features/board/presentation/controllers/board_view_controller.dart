import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/board_repository.dart';
import '../../data/list_repository.dart';
import '../../data/card_repository.dart';

class BoardViewPageController extends ChangeNotifier {
  final BoardRepository _boardRepo;
  final ListRepository _listRepo;
  final CardRepository _cardRepo;
  
  Board? _board;
  List<CardList> _lists = [];
  List<Card> _allCards = [];
  bool _isLoading = false;
  String? _error;
  
  BoardViewPageController({
    required BoardRepository boardRepo,
    required ListRepository listRepo,
    required CardRepository cardRepo,
  }) : _boardRepo = boardRepo,
       _listRepo = listRepo,
       _cardRepo = cardRepo;
  
  // Getters
  Board? get board => _board;
  List<CardList> get lists => _lists;
  List<Card> get allCards => _allCards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Card> getCardsForList(int listId) {
    return _allCards.where((c) => c.listId == listId).toList();
  }
  
  // Load board using slugs only (no workspaceId needed)
  Future<void> load(String workspaceSlug, String boardSlug) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Usa o novo endpoint baseado em slug
      _board = await _boardRepo.getBoardBySlug(workspaceSlug, boardSlug);
      if (_board == null) {
        _error = 'Board nao encontrado';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Carregar lists e cards em paralelo
      final results = await Future.wait([
        _listRepo.getLists(_board!.id!),
        _cardRepo.getCardsByBoard(_board!.id!),
      ]);
      
      results[0].fold(
        (f) => _error = f.message,
        (lists) => _lists = lists as List<CardList>,
      );
      
      results[1].fold(
        (f) => _error = f.message,
        (cards) => _allCards = cards as List<Card>,
      );
    } catch (e) {
      _error = 'Erro ao carregar board';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recarrega apenas os cards do board (mais leve que reload completo)
  Future<void> reloadCards() async {
    if (_board == null) return;
    
    final result = await _cardRepo.getCardsByBoard(_board!.id!);
    result.fold(
      (f) => _error = f.message,
      (cards) => _allCards = cards,
    );
    notifyListeners();
  }

  Future<Board?> updateBoard(int boardId, String title) async {
     try {
      final updatedBoard = await _boardRepo.updateBoard(boardId, title);
      _board = updatedBoard;
      notifyListeners();
      return updatedBoard;
    } catch (e) {
      _error = 'Erro ao atualizar board';
      notifyListeners();
      return null;
    }
  }
  
  // List operations
  Future<CardList?> createList(String title) async {
    if (_board == null) return null;
    
    final result = await _listRepo.createList(_board!.id!, title);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return null; },
      (list) { _lists.add(list); notifyListeners(); return list; },
    );
  }
  
  Future<bool> deleteList(int listId) async {
    final result = await _listRepo.deleteList(listId);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return false; },
      (_) { 
        _lists.removeWhere((l) => l.id == listId);
        _allCards.removeWhere((c) => c.listId == listId);
        notifyListeners();
        return true;
      },
    );
  }
  
  Future<bool> moveList(int fromIndex, int toIndex) async {
    // 1. Local Reorder
    if (fromIndex < 0 || fromIndex >= _lists.length || toIndex < 0 || toIndex >= _lists.length) {
      return false;
    }

    final movedList = _lists.removeAt(fromIndex);
    _lists.insert(toIndex, movedList);
    notifyListeners(); // Optimistic update UI

    // 2. API Call
    final orderedIds = _lists.map((l) => l.id!).toList();
    return reorderLists(orderedIds);
  }
  
  Future<bool> reorderLists(List<int> orderedIds) async {
    if (_board == null) return false;
    
    final result = await _listRepo.reorderLists(_board!.id!, orderedIds);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return false; },
      (lists) { _lists = lists; notifyListeners(); return true; },
    );
  }
  
  // Card operations
  Future<Card?> createCard(int listId, String title) async {
    final result = await _cardRepo.createCard(listId, title);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return null; },
      (card) { _allCards.add(card); notifyListeners(); return card; },
    );
  }
  
  Future<Card?> moveCard(int cardId, int toListId, {String? afterRank, String? beforeRank}) async {
    // 1. Optimistic Update
    final index = _allCards.indexWhere((c) => c.id == cardId);
    if (index == -1) return null;

    final originalCard = _allCards[index];
    // Update local state immediately
    _allCards[index] = originalCard.copyWith(listId: toListId);
    notifyListeners();

    // 2. Call API
    final result = await _cardRepo.moveCard(cardId, toListId, afterRank: afterRank, beforeRank: beforeRank);
    
    return result.fold(
      (f) { 
        // 3. Revert on error
        final revertIndex = _allCards.indexWhere((c) => c.id == cardId);
        if (revertIndex != -1) {
          _allCards[revertIndex] = originalCard;
        }
        _error = f.message; 
        notifyListeners(); 
        return null; 
      },
      (card) {
        // 4. Confirm update
        final confirmIndex = _allCards.indexWhere((c) => c.id == cardId);
        if (confirmIndex != -1) _allCards[confirmIndex] = card;
        notifyListeners();
        return card;
      },
    );
  }
  
  Future<bool> deleteCard(int cardId) async {
    final result = await _cardRepo.deleteCard(cardId);
    return result.fold(
      (f) { _error = f.message; notifyListeners(); return false; },
      (_) {
        _allCards.removeWhere((c) => c.id == cardId);
        notifyListeners();
        return true;
      },
    );
  }

  void selectCard(Card card) {
    // Just a placeholder if needed for navigation or local state
  }

  /// Atualiza um card localmente sem chamar a API
  /// Usado para sincronizar mudanças vindas de outras páginas
  void updateCardLocally(Card updatedCard) {
    final index = _allCards.indexWhere((c) => c.id == updatedCard.id);
    if (index != -1) {
      _allCards[index] = updatedCard;
      notifyListeners();
    }
  }
}
