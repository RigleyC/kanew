import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/priority_utils.dart';

class PriorityChip extends StatelessWidget {
  final CardPriority priority;
  final bool showLabel;

  const PriorityChip({
    super.key,
    required this.priority,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        SvgPicture.asset(
          priority.iconPath!,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            priority.color,
            BlendMode.srcIn,
          ),
        ),
        if (showLabel) ...[
          Text(
            priority.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
