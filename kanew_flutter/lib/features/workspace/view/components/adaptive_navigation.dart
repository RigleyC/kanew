import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/sidebar/sidebar.dart';
import '../../../auth/viewmodel/auth_controller.dart';
import '../../viewmodel/workspace_controller.dart';
import 'workspace_switcher.dart';
import 'user_profile_tile.dart';

/// Navegação adaptativa: Sidebar para desktop, BottomNav para mobile
class AdaptiveNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String workspaceSlug;

  const AdaptiveNavigation({
    super.key,
    required this.navigationShell,
    required this.workspaceSlug,
  });

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.maybeOf(context);
    final isMobile = provider?.isMobile ?? false;

    return isMobile
        ? _MobileNavigation(
            navigationShell: navigationShell,
            workspaceSlug: workspaceSlug,
          )
        : _DesktopNavigation(
            navigationShell: navigationShell,
            workspaceSlug: workspaceSlug,
          );
  }
}

// ============================================================================
// DESKTOP: SIDEBAR
// ============================================================================

class _DesktopNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String workspaceSlug;

  const _DesktopNavigation({
    required this.navigationShell,
    required this.workspaceSlug,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<WorkspaceController>(),
      builder: (context, _) {
        final workspaceVM = getIt<WorkspaceController>();
        return AppSidebar(
          header: _buildHeader(context, workspaceVM),
          footer: _buildFooter(context, workspaceVM),
          children: _buildSidebarItems(context),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WorkspaceController workspaceVM) {
    final provider = SidebarProvider.maybeOf(context);
    final isCollapsed = provider?.isCollapsed ?? false;

    if (isCollapsed) {
      return Center(
        child: _ToggleButton(
          onToggle: provider?.toggleSidebar,
          isCollapsed: true,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: WorkspaceSwitcher(isCollapsed: isCollapsed),
        ),
        const SizedBox(width: 8),
        _ToggleButton(
          onToggle: provider?.toggleSidebar,
          isCollapsed: false,
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WorkspaceController workspaceVM,
  ) {
    return ListenableBuilder(
      listenable: getIt<AuthController>(),
      builder: (context, _) {
        final authViewModel = getIt<AuthController>();
        return UserProfileTile(
          onLogout: () async {
            await authViewModel.logout();
            workspaceVM.clear();
          },
        );
      },
    );
  }

  List<Widget> _buildSidebarItems(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    final provider = SidebarProvider.maybeOf(context);

    void navigateAndClose(int index) {
      navigationShell.goBranch(index);
      // Close sidebar on mobile after navigation
      if (provider?.isMobile ?? false) {
        provider?.setOpen(false);
      }
    }

    return [
      SidebarGroup(
        children: [
          SidebarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: 'Boards',
            selected: currentIndex == 0,
            onPress: () => navigateAndClose(0),
          ),
          SidebarItem(
            icon: const Icon(Icons.people_rounded),
            label: 'Membros',
            selected: currentIndex == 1,
            onPress: () => navigateAndClose(1),
          ),
          SidebarItem(
            icon: const Icon(Icons.settings_rounded),
            label: 'Configurações',
            selected: currentIndex == 2,
            onPress: () => navigateAndClose(2),
          ),
        ],
      ),
    ];
  }
}

// ============================================================================
// MOBILE: BOTTOM NAVIGATION BAR
// ============================================================================

class _MobileNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String workspaceSlug;

  const _MobileNavigation({
    required this.navigationShell,
    required this.workspaceSlug,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        navigationShell.goBranch(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Boards',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_rounded),
          label: 'Membros',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: 'Configurações',
        ),
      ],
    );
  }
}

// ============================================================================
// TOGGLE BUTTON
// ============================================================================

class _ToggleButton extends StatelessWidget {
  final VoidCallback? onToggle;
  final bool isCollapsed;

  const _ToggleButton({
    required this.onToggle,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? 'Expandir sidebar' : 'Recolher sidebar',
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: isCollapsed ? 0.5 : 0,
            child: Icon(
              Icons.chevron_left,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
