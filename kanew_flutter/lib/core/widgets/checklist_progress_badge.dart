import 'package:flutter/material.dart';

class ChecklistProgressBadge extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final Color? progressColor;
  final Color? backgroundColor;

  const ChecklistProgressBadge({
    super.key,
    required this.completedCount,
    required this.totalCount,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                progressColor ?? colorScheme.primary,
              ),
            ),
          ),

          Text(
            '$completedCount/$totalCount',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
