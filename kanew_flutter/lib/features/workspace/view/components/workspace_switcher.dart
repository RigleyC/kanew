import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../viewmodel/workspace_controller.dart';

/// Workspace switcher with dropdown popover menu
class WorkspaceSwitcher extends StatelessWidget {
  /// Whether the sidebar is collapsed (shows only avatar)
  final bool isCollapsed;

  const WorkspaceSwitcher({
    super.key,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<WorkspaceController>(),
      builder: (context, _) {
        final viewModel = getIt<WorkspaceController>();
        final current = viewModel.currentWorkspace;
        final allWorkspaces = viewModel.workspaces;

        // When collapsed, just show the avatar with tooltip
        if (isCollapsed) {
          return Tooltip(
            message: current?.title ?? 'Workspace',
            child: _WorkspaceAvatar(
              title: current?.title ?? 'W',
              size: 36,
            ),
          );
        }

        return FPopoverMenu.tiles(
          menuAnchor: Alignment.topLeft,
          childAnchor: Alignment.bottomLeft,
          offset: const Offset(0, 8),
          menu: [
            // Workspaces list
            FTileGroup(
              children: [
                for (final ws in allWorkspaces)
                  FTile(
                    prefix: _WorkspaceAvatar(title: ws.title, size: 28),
                    title: Text(ws.title),
                    suffix: ws.id == current?.id
                        ? Icon(
                            FIcons.check,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onPress: () {
                      viewModel.selectWorkspace(ws);
                      context.go(RoutePaths.workspaceBoards(ws.slug));
                    },
                  ),
              ],
            ),

            // Create new workspace
            FTileGroup(
              children: [
                FTile(
                  prefix: const Icon(FIcons.plus),
                  title: const Text('Criar workspace'),
                  onPress: () => _showCreateDialog(context, viewModel),
                ),
              ],
            ),
          ],
          builder: (context, controller, child) => _WorkspaceSwitcherButton(
            currentTitle: current?.title ?? 'Selecionar',
            onTap: controller.toggle,
          ),
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context, WorkspaceController viewModel) {
    final nameController = TextEditingController();

    showConfirmDialog(
      title: 'Criar Workspace',
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome do workspace',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
      ),
      confirmText: 'Criar',
      onConfirm: () async {
        final name = nameController.text.trim();
        if (name.isNotEmpty) {
          final workspace = await viewModel.createWorkspace(name);
          if (workspace != null && context.mounted) {
            context.go(RoutePaths.workspaceBoards(workspace.slug));
          }
        }
      },
    );
  }
}

/// Custom button for workspace switcher that handles overflow properly
class _WorkspaceSwitcherButton extends StatelessWidget {
  final String currentTitle;
  final VoidCallback onTap;

  const _WorkspaceSwitcherButton({
    required this.currentTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              // Workspace Avatar
              _WorkspaceAvatar(
                title: currentTitle,
                size: 28,
              ),
              const SizedBox(width: 10),

              // Workspace Name - uses Expanded to prevent overflow
              Expanded(
                child: Text(
                  currentTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              const SizedBox(width: 4),

              // Dropdown Icon
              Icon(
                FIcons.chevronsUpDown,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Workspace avatar with initials
class _WorkspaceAvatar extends StatelessWidget {
  final String title;
  final double size;

  const _WorkspaceAvatar({
    required this.title,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          _getInitials(title),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }

  String _getInitials(String text) {
    final words = text.trim().split(' ');
    if (words.isEmpty) return 'W';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : 'W';
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
