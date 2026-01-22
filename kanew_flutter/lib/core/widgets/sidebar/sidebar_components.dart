import 'package:flutter/material.dart';

import 'sidebar_provider.dart';

/// Button to toggle the sidebar
class SidebarTrigger extends StatelessWidget {
  final Widget? icon;
  final double size;

  const SidebarTrigger({
    super.key,
    this.icon,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final provider = SidebarProvider.maybeOf(context);

    return IconButton(
      icon: icon ?? Icon(Icons.menu, size: size),
      onPressed: provider?.toggleSidebar,
      tooltip: provider?.isOpen == true
          ? 'Recolher sidebar'
          : 'Expandir sidebar',
    );
  }
}

/// A horizontal separator line
class SidebarSeparator extends StatelessWidget {
  const SidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: colorScheme.outlineVariant,
    );
  }
}

/// A small badge for notifications/counts
class SidebarBadge extends StatelessWidget {
  final String text;
  final Color? color;

  const SidebarBadge({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
