import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:kanew_client/kanew_client.dart';

import '../data/workspace_repository.dart';

class WorkspaceController extends ChangeNotifier {
  final WorkspaceRepository _repository;

  List<Workspace> _workspaces = [];
  Workspace? _currentWorkspace;
  bool _isLoading = false;
  String? _error;

  /// Creates a new [WorkspaceController].
  ///
  /// Requires a [WorkspaceRepository] for data access.
  WorkspaceController({required WorkspaceRepository repository})
    : _repository = repository;

  /// ============================================================
  // GETTERS
  // ============================================================

  /// All workspaces loaded for current user.
  List<Workspace> get workspaces => _workspaces;

  /// Currently selected workspace.
  Workspace? get currentWorkspace => _currentWorkspace;

  /// Whether workspaces are currently being loaded.
  bool get isLoading => _isLoading;

  /// Error message from last failed operation.
  String? get error => _error;

  /// Whether any workspaces are available.
  bool get hasWorkspaces => _workspaces.isNotEmpty;

  /// All workspaces except the current one.
  List<Workspace> get otherWorkspaces =>
      _workspaces.where((ws) => ws.id != _currentWorkspace?.id).toList();

  /// ============================================================
  // STATE MANAGEMENT
  // ============================================================

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// ============================================================
  // WORKSPACE OPERATIONS
  // ============================================================

  /// Initialize workspaces - auto-loads if not already loaded.
  /// Call this once after authentication is confirmed.
  Future<void> init() async {
    if (_workspaces.isEmpty && !_isLoading) {
      await loadWorkspaces();
    }
  }

  /// Loads all workspaces for authenticated user from server.
  ///
  /// Safe to call multiple times - will only load if not already loading.
  Future<void> loadWorkspaces() async {
    // Prevent multiple simultaneous loads
    if (_isLoading) {
      developer.log(
        'Workspaces already loading, skipping duplicate call',
        name: 'workspace_controller',
      );
      return;
    }

    developer.log('Loading workspaces', name: 'workspace_controller');
    _setLoading(true);
    _setError(null);

    try {
      _workspaces = await _repository.getWorkspaces();

      developer.log(
        'Workspaces loaded successfully - count: ${_workspaces.length}',
        name: 'workspace_controller',
      );

      if (_currentWorkspace == null && _workspaces.isNotEmpty) {
        _currentWorkspace = _workspaces.first;
        developer.log(
          'Auto-selected workspace: ${_currentWorkspace!.title} (${_currentWorkspace!.slug})',
          name: 'workspace_controller',
        );
      }

      notifyListeners();
    } catch (e, s) {
      developer.log(
        'Failed to load workspaces',
        name: 'workspace_controller',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      _setError('Não foi possível carregar workspaces');
    } finally {
      _setLoading(false);
    }
  }

  /// Sets the current workspace by its slug.
  Future<bool> setCurrentWorkspaceBySlug(String slug) async {
    developer.log(
      'Setting current workspace by slug: $slug',
      name: 'workspace_controller',
    );

    final existing = _workspaces.where((w) => w.slug == slug).firstOrNull;
    if (existing != null) {
      _currentWorkspace = existing;
      notifyListeners();
      developer.log(
        'Workspace found in memory: ${existing.title}',
        name: 'workspace_controller',
      );
      return true;
    }

    try {
      final workspace = await _repository.getBySlug(slug);
      if (workspace != null) {
        _currentWorkspace = workspace;
        notifyListeners();
        developer.log(
          'Workspace loaded from repository: ${workspace.title}',
          name: 'workspace_controller',
        );
        return true;
      } else {
        developer.log(
          'Workspace not found: $slug',
          name: 'workspace_controller',
          level: 900,
        );
        return false;
      }
    } catch (e, s) {
      developer.log(
        'Failed to load workspace by slug: $slug',
        name: 'workspace_controller',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }

  /// Selects a workspace from the loaded list.
  void selectWorkspace(Workspace workspace) {
    _currentWorkspace = workspace;
    notifyListeners();
    developer.log(
      'Workspace selected: ${workspace.title} (${workspace.slug})',
      name: 'workspace_controller',
    );
  }

  /// Creates a new workspace.
  Future<Workspace?> createWorkspace(String title, {String? slug}) async {
    developer.log(
      'Creating workspace: $title (slug: $slug)',
      name: 'workspace_controller',
    );
    _setLoading(true);
    Workspace? createdWorkspace;

    try {
      final workspace = await _repository.createWorkspace(title, slug: slug);

      developer.log(
        'Workspace created: ${workspace.title} (${workspace.slug})',
        name: 'workspace_controller',
      );

      _workspaces.insert(0, workspace);
      _currentWorkspace = workspace;
      createdWorkspace = workspace;
      notifyListeners();
    } catch (e, s) {
      developer.log(
        'Failed to create workspace: $title',
        name: 'workspace_controller',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      _setError('Não foi possível criar workspace');
    } finally {
      _setLoading(false);
    }

    return createdWorkspace;
  }

  /// Clears all workspace state.
  void clear() {
    developer.log('Clearing workspace state', name: 'workspace_controller');
    _workspaces = [];
    _currentWorkspace = null;
    _error = null;
    notifyListeners();
  }
}
