import 'package:flutter/material.dart';
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
  final MenuController _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuAnchor(
      alignmentOffset: widget.alignmentOffset ?? const Offset(-200, 8),
      consumeOutsideTap: true,
      menuChildren: [
        SizedBox(
          width: widget.menuWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items
                .map((item) => _buildMenuItem(item, theme))
                .toList(),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: widget.trigger,
        );
      },
    );
  }

  Widget _buildMenuItem(SidebarMenuItem item, ThemeData theme) {
    return MenuItemButton(
      onPressed: () {
        item.onTap();
        _controller.close();
      },
      leadingIcon: item.leading,
      trailingIcon: item.trailing,
      child: DefaultTextStyle(
        style: TextStyle(
          color: item.isDestructive ? theme.colorScheme.error : null,
        ),
        child: item.title,
      ),
    );
  }
}
