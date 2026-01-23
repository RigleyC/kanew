import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/sidebar/sidebar.dart';
import '../../../../core/di/injection.dart';
import '../../../workspace/viewmodel/workspace_controller.dart';

class CardDetailHeader extends StatelessWidget {
  final String workspaceSlug;
  final String boardSlug;
  final String listName;
  final bool isMobile;
  final VoidCallback onClose;

  const CardDetailHeader({
    super.key,
    required this.workspaceSlug,
    required this.boardSlug,
    required this.listName,
    required this.isMobile,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final workspaceVM = getIt<WorkspaceController>();
    final workspaceName = workspaceVM.currentWorkspace?.title ?? workspaceSlug;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SidebarTrigger(),
            ),

          // Breadcrumb
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _BreadcrumbLink(
                    text: workspaceName,
                    onTap: () =>
                        context.go(RoutePaths.workspaceBoards(workspaceSlug)),
                  ),
                  _BreadcrumbSeparator(),
                  _BreadcrumbLink(
                    text: boardSlug,
                    onTap: onClose,
                  ),
                  _BreadcrumbSeparator(),
                  Text(
                    listName,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Fechar',
          ),
        ],
      ),
    );
  }
}

class _BreadcrumbLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _BreadcrumbLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '/',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),
    );
  }
}
