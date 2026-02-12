/* import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

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

    return FSidebarGroup(
      label: label != null && !isCollapsed
          ? Text(
              label!.toUpperCase(),
            )
          : null,
      action: label != null && !isCollapsed ? action : null,
      children: children,
    );
  }
}
 */