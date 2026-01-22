import 'package:flutter/material.dart';

/// Data passed down to sidebar children via InheritedWidget
class SidebarData extends InheritedWidget {
  /// Whether the sidebar is currently collapsed
  final bool isCollapsed;

  /// The sidebar's current width
  final double width;

  const SidebarData({
    super.key,
    required this.isCollapsed,
    required this.width,
    required super.child,
  });

  static SidebarData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SidebarData>();
  }

  static bool isCollapsedOf(BuildContext context) {
    return maybeOf(context)?.isCollapsed ?? false;
  }

  static double widthOf(BuildContext context) {
    return maybeOf(context)?.width ?? 250;
  }

  @override
  bool updateShouldNotify(SidebarData oldWidget) {
    return isCollapsed != oldWidget.isCollapsed || width != oldWidget.width;
  }
}
