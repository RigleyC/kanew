import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/priority_utils.dart';

class PriorityChip extends StatelessWidget {
  final CardPriority priority;

  const PriorityChip({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
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
        const SizedBox(width: 6),
        Text(priority.label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
