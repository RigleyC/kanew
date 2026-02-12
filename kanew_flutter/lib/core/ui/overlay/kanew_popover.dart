import 'package:flutter/material.dart';
import 'package:forui/widgets/popover.dart';

class KanewPopover extends StatefulWidget {
  final Widget Function(BuildContext context, FPopoverController controller)
  anchorBuilder;
  final Widget Function(BuildContext context, VoidCallback close)
  contentBuilder;
  final Alignment menuAnchor;
  final Alignment childAnchor;
  final Offset offset;

  const KanewPopover({
    super.key,
    required this.anchorBuilder,
    required this.contentBuilder,
    this.menuAnchor = Alignment.topLeft,
    this.childAnchor = Alignment.bottomLeft,
    this.offset = const Offset(0, 4),
  });

  @override
  State<KanewPopover> createState() => _KanewPopoverState();
}

class _KanewPopoverState extends State<KanewPopover>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    return FPopover(
      control: FPopoverControl.managed(controller: _controller),
      childAnchor: widget.childAnchor,
      popoverAnchor: widget.menuAnchor,
      offset: widget.offset,
      popoverBuilder: (context, _) => widget.contentBuilder(context, _close),
      child: widget.anchorBuilder(context, _controller),
    );
  }
}
