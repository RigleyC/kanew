import 'package:flutter/material.dart';
import 'package:forui/widgets/popover.dart';

class KanewPopover extends StatefulWidget {
  final Widget anchor;
  final Widget Function(VoidCallback close) contentBuilder;
  final Alignment menuAnchor;
  final Alignment childAnchor;
  final Offset offset;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? contentPadding;

  const KanewPopover({
    super.key,
    required this.anchor,
    required this.contentBuilder,
    this.menuAnchor = Alignment.topLeft,
    this.childAnchor = Alignment.bottomLeft,
    this.offset = Offset.zero,
    this.width,
    this.constraints,
    this.contentPadding,
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

  void _toggle() {
    _controller.toggle();
  }

  void _close() {
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FPopover(
      control: FPopoverControl.managed(controller: _controller),
      childAnchor: widget.childAnchor,
      popoverAnchor: widget.menuAnchor,
      offset: widget.offset,
      popoverBuilder: (context, _) {
        final content = widget.contentBuilder(_close);
        return ConstrainedBox(
          constraints: widget.constraints ?? const BoxConstraints(),
          child: Container(
            width: widget.width,
            padding: widget.contentPadding,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: content,
          ),
        );
      },
      child: GestureDetector(
        onTap: _toggle,
        child: widget.anchor,
      ),
    );
  }
}
