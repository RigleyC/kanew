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
    final selectedBackgroundColor = colorScheme.primaryContainer.withValues(
      alpha: 0.3,
    );
    final borderRadius = BorderRadius.circular(8);

    if (isCollapsed) {
      const collapsedIconBoxSize = 40.0;

      return Tooltip(
        message: label,
        preferBelow: false,
        child: InkWell(
          onTap: onPress,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: collapsedIconBoxSize,
                height: collapsedIconBoxSize,
                decoration: BoxDecoration(
                  color: selected
                      ? selectedBackgroundColor
                      : Colors.transparent,
                  borderRadius: borderRadius,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: selected ? selectedBackgroundColor : Colors.transparent,
            borderRadius: borderRadius,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canShowLabel = constraints.maxWidth >= 120;
              final canShowGap = constraints.maxWidth >= 60;

              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: canShowLabel
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    child: icon,
                  ),
                  if (canShowGap) const SizedBox(width: 12),
                  if (canShowLabel)
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (canShowLabel && trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
