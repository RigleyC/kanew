import 'package:kanew_client/kanew_client.dart';

import '../../../core/di/injection.dart';

/// Repository for workspace operations
class WorkspaceRepository {
  final Client _client;

  WorkspaceRepository({Client? client}) : _client = client ?? getIt<Client>();

  /// Gets all workspaces for authenticated user
  Future<List<Workspace>> getWorkspaces() async {
    return await _client.workspace.getWorkspaces();
  }

  /// Gets a workspace by slug
  Future<Workspace?> getBySlug(String slug) async {
    return await _client.workspace.getWorkspace(slug);
  }

  /// Creates a new workspace
  Future<Workspace> createWorkspace(String title, {String? slug}) async {
    return await _client.workspace.createWorkspace(title, slug);
  }

  /// Updates a workspace
  Future<Workspace> updateWorkspace(
    int workspaceId,
    String title, {
    String? slug,
  }) async {
    return await _client.workspace.updateWorkspace(workspaceId, title, slug);
  }

  /// Deletes a workspace (soft delete)
  Future<void> deleteWorkspace(int workspaceId) async {
    await _client.workspace.deleteWorkspace(workspaceId);
  }
}
