import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    final item = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 12,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              IconTheme(
                data: IconThemeData(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                child: icon,
              ),

              // Label (only when expanded)
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Trailing (only when expanded)
              if (!isCollapsed && trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );

    // Wrap with tooltip when collapsed
    if (isCollapsed) {
      return Tooltip(
        message: label,
        preferBelow: false,
        child: item,
      );
    }

    return item;
  }
}
