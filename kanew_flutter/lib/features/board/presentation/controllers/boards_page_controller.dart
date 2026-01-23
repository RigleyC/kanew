import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../data/board_repository.dart';

class BoardsPageController extends ChangeNotifier {
  final BoardRepository _repository;

  List<Board> _boards = [];
  bool _isLoading = false;
  String? _error;
  String? _workspaceSlug;

  BoardsPageController({required BoardRepository repository})
    : _repository = repository;

  List<Board> get boards => _boards;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get workspaceSlug => _workspaceSlug;

  /// Loads boards using workspace slug (from URL)
  Future<void> loadBoards(String workspaceSlug) async {
    _workspaceSlug = workspaceSlug;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _boards = await _repository.getBoardsByWorkspaceSlug(workspaceSlug);
    } catch (e) {
      _error = 'Erro ao carregar boards';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a board using stored workspace slug
  Future<Board?> createBoard(String title) async {
    if (_workspaceSlug == null) return null;

    try {
      final board = await _repository.createBoardByWorkspaceSlug(
        _workspaceSlug!,
        title,
      );
      _boards.insert(0, board);
      notifyListeners();
      return board;
    } catch (e) {
      _error = 'Erro ao criar board';
      notifyListeners();
      return null;
    }
  }

  void selectBoard(Board board) {
    // Optional: if we need to track selection in this controller
  }
}
