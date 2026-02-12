import 'package:flutter/material.dart';

/// Calendário do Kanew para seleção de 1 data.
///
/// Pensado para ser usado dentro de um popover/menu (ex.: `MenuAnchor`),
/// semelhante ao date picker do shadcn_flutter, sem dependências externas.
class KanewCalendar extends StatefulWidget {
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
  State<KanewCalendar> createState() => _KanewCalendarState();
}

class _KanewCalendarState extends State<KanewCalendar> {
  late final DateTime _firstDate;
  late final DateTime _lastDate;

  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _firstDate = _startOfDay(
      widget.firstDate ?? now.subtract(const Duration(days: 365)),
    );
    _lastDate = _startOfDay(
      widget.lastDate ?? now.add(const Duration(days: 365 * 5)),
    );

    final initial = widget.initialDate ?? now;
    _selectedDate = _clampToRange(_startOfDay(initial));
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  DateTime _startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  DateTime _clampToRange(DateTime date) {
    if (date.isBefore(_firstDate)) return _firstDate;
    if (date.isAfter(_lastDate)) return _lastDate;
    return date;
  }

  bool _monthBackEnabled() {
    final previousMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    final lastDayPrevMonth = DateTime(previousMonth.year, previousMonth.month + 1, 0);
    return !lastDayPrevMonth.isBefore(_firstDate);
  }

  bool _monthForwardEnabled() {
    final nextMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    final firstDayNextMonth = DateTime(nextMonth.year, nextMonth.month, 1);
    return !firstDayNextMonth.isAfter(_lastDate);
  }

  void _goToPreviousMonth() {
    if (!_monthBackEnabled()) return;
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    if (!_monthForwardEnabled()) return;
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = MaterialLocalizations.of(context);

    final monthYearLabel = localizations.formatMonthYear(_displayedMonth);
    final weekdayLabels = _weekdayLabels(localizations);

    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstDayOffset = DateUtils.firstDayOffset(
      _displayedMonth.year,
      _displayedMonth.month,
      localizations,
    );

    final totalCells = firstDayOffset + daysInMonth;
    final trailing = (7 - (totalCells % 7)) % 7;
    final gridCells = totalCells + trailing;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _MonthNavButton(
                icon: Icons.chevron_left,
                enabled: _monthBackEnabled(),
                onPressed: _goToPreviousMonth,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  monthYearLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _MonthNavButton(
                icon: Icons.chevron_right,
                enabled: _monthForwardEnabled(),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final label in weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _CalendarTable(
            firstDayOffset: firstDayOffset,
            daysInMonth: daysInMonth,
            gridCells: gridCells,
            month: _displayedMonth,
            firstDate: _firstDate,
            lastDate: _lastDate,
            selectedDate: _selectedDate,
            colorScheme: colorScheme,
            onSelect: (date) {
              setState(() => _selectedDate = date);
              widget.onDateSelected(date);
            },
          ),
        ],
      ),
    );
  }

  List<String> _weekdayLabels(MaterialLocalizations localizations) {
    final firstDayIndex = localizations.firstDayOfWeekIndex;
    final weekdays = localizations.narrowWeekdays;

    final ordered = <String>[];
    for (var i = 0; i < weekdays.length; i++) {
      ordered.add(weekdays[(firstDayIndex + i) % weekdays.length]);
    }
    return ordered;
  }
}

class _CalendarTable extends StatelessWidget {
  final int firstDayOffset;
  final int daysInMonth;
  final int gridCells;
  final DateTime month;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final ColorScheme colorScheme;
  final ValueChanged<DateTime> onSelect;

  const _CalendarTable({
    required this.firstDayOffset,
    required this.daysInMonth,
    required this.gridCells,
    required this.month,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.colorScheme,
    required this.onSelect,
  });

  DateTime _startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    // Avoid viewports (GridView/ListView) inside MenuAnchor because MenuAnchor
    // may ask for intrinsic dimensions, which viewports can't provide.
    final rows = (gridCells / 7).ceil();

    final tableRows = <TableRow>[];
    for (var row = 0; row < rows; row++) {
      final children = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final index = row * 7 + col;
        if (index < firstDayOffset) {
          children.add(const SizedBox(width: 40, height: 40));
          continue;
        }

        final day = index - firstDayOffset + 1;
        if (day > daysInMonth) {
          children.add(const SizedBox(width: 40, height: 40));
          continue;
        }

        final date = DateTime(month.year, month.month, day);
        final normalized = _startOfDay(date);

        final isDisabled = normalized.isBefore(firstDate) || normalized.isAfter(lastDate);
        final isSelected = DateUtils.isSameDay(normalized, selectedDate);
        final isToday = DateUtils.isSameDay(normalized, _startOfDay(DateTime.now()));

        Color? background;
        Color foreground = colorScheme.onSurface;
        BorderSide? border;

        if (isDisabled) {
          foreground = colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
        } else if (isSelected) {
          background = colorScheme.primary;
          foreground = colorScheme.onPrimary;
        } else if (isToday) {
          border = BorderSide(color: colorScheme.primary, width: 1);
        }

        children.add(
          Padding(
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              width: 40,
              height: 40,
              child: _DayCell(
                label: '$day',
                enabled: !isDisabled,
                background: background,
                foreground: foreground,
                border: border,
                onTap: () {
                  if (isDisabled) return;
                  onSelect(normalized);
                },
              ),
            ),
          ),
        );
      }

      tableRows.add(TableRow(children: children));
    }

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows,
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _MonthNavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: enabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color? background;
  final Color foreground;
  final BorderSide? border;
  final VoidCallback onTap;

  const _DayCell({
    required this.label,
    required this.enabled,
    required this.background,
    required this.foreground,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: background ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: border ?? BorderSide.none,
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
