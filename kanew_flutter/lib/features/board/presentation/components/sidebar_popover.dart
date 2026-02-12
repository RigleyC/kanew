import 'package:flutter/material.dart';
import '../../../../core/ui/kanew_ui.dart';

class SidebarPopover extends StatefulWidget {
  final Widget anchor;
  final Widget Function(VoidCallback close) contentBuilder;
  final Offset? offset;
  final double? width;

  const SidebarPopover({
    super.key,
    required this.anchor,
    required this.contentBuilder,
    this.offset,
    this.width,
  });

  @override
  State<SidebarPopover> createState() => _SidebarPopoverState();
}

class _SidebarPopoverState extends State<SidebarPopover> {
  @override
  Widget build(BuildContext context) {
    return KanewPopover(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      offset: widget.offset ?? const Offset(0, 8),
      width: widget.width,
      anchor: widget.anchor,
      contentBuilder: widget.contentBuilder,
    );
  }
}
