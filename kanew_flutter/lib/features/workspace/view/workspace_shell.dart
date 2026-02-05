import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/widgets/sidebar/sidebar.dart';
import '../viewmodel/workspace_controller.dart';
import 'components/adaptive_navigation.dart';

/// Main shell layout with sidebar/bottom nav using GoRouter StatefulShellRoute
class WorkspaceShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String workspaceSlug;

  const WorkspaceShell({
    super.key,
    required this.navigationShell,
    required this.workspaceSlug,
  });

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  void didUpdateWidget(covariant WorkspaceShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workspaceSlug != oldWidget.workspaceSlug) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final viewModel = getIt<WorkspaceController>();

    await viewModel.init();

    if (widget.workspaceSlug.isNotEmpty) {
      await viewModel.setCurrentWorkspaceBySlug(widget.workspaceSlug);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SidebarStateWidget(
      defaultOpen: true,
      child: Builder(
        builder: (context) {
          final provider = SidebarProvider.maybeOf(context);
          final isMobile = provider?.isMobile ?? false;

          if (isMobile) {
            return Scaffold(
              body: widget.navigationShell,
              bottomNavigationBar: AdaptiveNavigation(
                navigationShell: widget.navigationShell,
                workspaceSlug: widget.workspaceSlug,
              ),
            );
          }

          return Scaffold(
            body: Row(
              children: [
                AdaptiveNavigation(
                  navigationShell: widget.navigationShell,
                  workspaceSlug: widget.workspaceSlug,
                ),
                Expanded(
                  child: widget.navigationShell,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
