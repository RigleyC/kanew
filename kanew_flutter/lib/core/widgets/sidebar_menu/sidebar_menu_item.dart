import 'package:flutter/material.dart';

class SidebarMenuItem {
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isDestructive;

  const SidebarMenuItem({
    this.leading,
    required this.title,
    this.trailing,
    required this.onTap,
    this.isDestructive = false,
  });
}
