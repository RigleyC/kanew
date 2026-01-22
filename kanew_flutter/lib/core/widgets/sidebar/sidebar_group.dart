import 'package:flutter/material.dart';

import 'sidebar_data.dart';

/// A group of sidebar items with optional label
class SidebarGroup extends StatelessWidget {
  /// Optional group label
  final String? label;

  /// Optional action widget
  final Widget? action;

  /// Items in this group
  final List<Widget> children;

  const SidebarGroup({
    super.key,
    this.label,
    this.action,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isCollapsed = SidebarData.isCollapsedOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group label (only when expanded)
          if (label != null && !isCollapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),

          // Children
          ...children,
        ],
      ),
    );
  }
}
