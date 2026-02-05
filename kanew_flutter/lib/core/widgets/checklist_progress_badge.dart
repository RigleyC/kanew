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
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),

      child: Row(
        spacing: 6,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 26,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    progressColor ?? Color(0xFF4EA7FC),
                  ),
                );
              },
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
