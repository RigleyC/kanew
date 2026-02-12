import 'package:flutter/material.dart';
import '../../ui/kanew_ui.dart';
import 'sidebar_menu_item.dart';

class SidebarMenuAnchor extends StatefulWidget {
  final Widget trigger;
  final List<SidebarMenuItem> items;
  final Offset? alignmentOffset;
  final double menuWidth;

  const SidebarMenuAnchor({
    super.key,
    required this.trigger,
    required this.items,
    this.alignmentOffset,
    this.menuWidth = 200,
  });

  @override
  State<SidebarMenuAnchor> createState() => _SidebarMenuAnchorState();
}

class _SidebarMenuAnchorState extends State<SidebarMenuAnchor> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return KanewPopover(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      offset: widget.alignmentOffset ?? const Offset(0, 8),
      width: widget.menuWidth,
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      anchor: widget.trigger,
      contentBuilder: (close) => Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.items
            .map((item) => _buildMenuItem(item, theme, close))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    SidebarMenuItem item,
    ThemeData theme,
    VoidCallback close,
  ) {
    return InkWell(
      onTap: () {
        item.onTap();
        close();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: item.leading ?? const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: item.isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
                child: item.title,
              ),
            ),
            if (item.trailing != null) ...[
              const SizedBox(width: 8),
              item.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
