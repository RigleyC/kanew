import 'package:flutter/material.dart';
import 'package:kanew_flutter/core/utils/date_formater.dart';

class DateChip extends StatelessWidget {
  final DateTime date;

  const DateChip({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 12,
          ),
          Text(
            DateFormater.formatDate(date),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
