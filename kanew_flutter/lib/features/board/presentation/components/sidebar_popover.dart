import 'package:flutter/material.dart';

class SidebarPopover extends StatefulWidget {
  final Widget anchor;
  final Widget Function(VoidCallback close) contentBuilder;
  final Offset? offset;

  const SidebarPopover({
    super.key,
    required this.anchor,
    required this.contentBuilder,
    this.offset,
  });

  @override
  State<SidebarPopover> createState() => _SidebarPopoverState();
}

class _SidebarPopoverState extends State<SidebarPopover> {
  final MenuController _controller = MenuController();

  void _toggle() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  void _close() {
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _controller,
      alignmentOffset: widget.offset ?? const Offset(-280, 8),
      menuChildren: [
        widget.contentBuilder(_close),
      ],
      child: GestureDetector(
        onTap: _toggle,
        child: widget.anchor,
      ),
    );
  }
}
