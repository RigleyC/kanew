import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Widget de calendário customizado que encapsula o FCalendar da forui
/// seguindo o tema do projeto
class KanewCalendar extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  const KanewCalendar({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: FCalendar(
        control: FCalendarControl.managedDate(
          initial: initialDate ?? DateTime.now(),
          onChange: (date) {
            if (date != null) {
              onDateSelected(date);
            }
          },
        ),
        start: firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
        end: lastDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
      ),
    );
  }
}
