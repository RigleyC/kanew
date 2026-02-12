import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'sidebar_data.dart';
import 'sidebar_provider.dart';

/// The main sidebar widget with animated collapse
class AppSidebar extends StatelessWidget {
  /// Header widget (e.g., logo, workspace switcher)
  final Widget? header;

  /// Footer widget (e.g., user profile)
  final Widget? footer;

  /// Content widgets
  final List<Widget> children;

  /// Expanded width
  final double expandedWidth;

  /// Collapsed width (icons only)
  final double collapsedWidth;

  /// Animation duration
  final Duration animationDuration;

  const AppSidebar({
    super.key,
    this.header,
    this.footer,
    this.children = const [],
    this.expandedWidth = 250,
    this.collapsedWidth = 72,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.maybeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    final isOpen = provider?.isOpen ?? true;
    final isMobile = provider?.isMobile ?? false;
    final isCollapsed = !isOpen && !isMobile;

    final currentWidth = isCollapsed ? collapsedWidth : expandedWidth;

    // Desktop: animated sidebar
    return SidebarData(
      isCollapsed: isCollapsed,
      width: currentWidth,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        width: currentWidth,
        child: _buildSidebarContent(context, colorScheme),
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, ColorScheme colorScheme) {
    final data = SidebarData.maybeOf(context);
    final width = data?.width ?? expandedWidth;

    return FSidebar(
      style: (base) => FSidebarStyle(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            right: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
        ),
        constraints: BoxConstraints.tightFor(width: width),
        groupStyle: base.groupStyle,
        backgroundFilter: base.backgroundFilter,
        headerPadding: const EdgeInsets.all(12),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        footerPadding: const EdgeInsets.all(12),
      ),
      header: header != null
          ? _SidebarSection(
              padding: EdgeInsets.zero,
              hasBorder: true,
              child: header!,
            )
          : null,
      footer: footer != null
          ? _SidebarSection(
              padding: EdgeInsets.zero,
              hasBorder: true,
              isTop: true,
              child: footer!,
            )
          : null,
      children: children,
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool hasBorder;
  final bool isTop;

  const _SidebarSection({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.hasBorder = false,
    this.isTop = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: hasBorder
          ? BoxDecoration(
              border: Border(
                top: isTop
                    ? BorderSide(color: colorScheme.outlineVariant, width: 1)
                    : BorderSide.none,
                bottom: !isTop
                    ? BorderSide(color: colorScheme.outlineVariant, width: 1)
                    : BorderSide.none,
              ),
            )
          : null,
      child: child,
    );
  }
}

/// Mobile drawer with backdrop overlay
class _MobileDrawer extends StatelessWidget {
  final bool isOpen;
  final double width;
  final VoidCallback onClose;
  final Widget child;

  const _MobileDrawer({
    required this.isOpen,
    required this.width,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isOpen ? 0.5 : 0,
                child: Container(color: Colors.black),
              ),
            ),
          ),

        // Drawer
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: isOpen ? 0 : -width,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
      ],
    );
  }
}
