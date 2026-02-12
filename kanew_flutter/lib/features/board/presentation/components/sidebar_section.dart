import 'package:flutter/material.dart';

class SidebarSection extends StatelessWidget {
  final String title;
  final Widget? content;
  final Widget? placeholder;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool enabled;

  const SidebarSection({
    super.key,
    required this.title,
    this.content,
    this.placeholder,
    this.trailing,
    this.padding,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sectionContent = content ?? placeholder;
    final body = Column(
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
        if (sectionContent != null) sectionContent,
      ],
    );

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: onTap == null
          ? body
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(8),
                child: body,
              ),
            ),
    );
  }
}
