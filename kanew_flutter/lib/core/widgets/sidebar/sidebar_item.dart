import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'sidebar_data.dart';

/// A sidebar navigation item that adapts to collapsed/expanded state
class SidebarItem extends StatelessWidget {
  /// The icon to display
  final Widget icon;

  /// The label text
  final String label;

  /// Whether this item is selected
  final bool selected;

  /// Callback when pressed
  final VoidCallback? onPress;

  /// Optional trailing widget (badge, chevron, etc)
  final Widget? trailing;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isCollapsed = SidebarData.isCollapsedOf(context);

    return FSidebarItem(
      selected: selected,
      onPress: onPress,
      icon: icon,
      label: isCollapsed ? null : Text(label),
    );
  }
}
