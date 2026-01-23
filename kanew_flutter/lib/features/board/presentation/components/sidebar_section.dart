import 'package:flutter/material.dart';

class SidebarSection extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? placeholder;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const SidebarSection({
    super.key,
    required this.title,
    this.child,
    this.placeholder,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = child ?? placeholder;

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          if (content != null) content,
        ],
      ),
    );
  }
}
