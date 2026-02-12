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
