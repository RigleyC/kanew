import 'package:flutter/material.dart' hide Card;
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/widgets/add_button.dart';
import '../../../../core/widgets/calendar/calendar.dart';
import '../../../../core/widgets/sidebar_menu/index.dart';
import 'label_chip.dart';
import 'priority_chip.dart';
import 'sidebar_popover.dart';
import 'sidebar_section.dart';

class CardDetailSidebar extends StatelessWidget {
  final Card card;
  final String listName;
  final List<CardList> boardLists;
  final List<LabelDef> labels;
  final List<LabelDef> boardLabels;
  final Function(DateTime) onDueDateChanged;
  final Function(UuidValue) onToggleLabel;
  final Function(String, String) onCreateLabel;
  final Function(UuidValue) onListChanged;
  final Function(CardPriority) onPriorityChanged;

  const CardDetailSidebar({
    super.key,
    required this.card,
    required this.listName,
    required this.boardLists,
    required this.labels,
    required this.boardLabels,
    required this.onDueDateChanged,
    required this.onToggleLabel,
    required this.onCreateLabel,
    required this.onListChanged,
    required this.onPriorityChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  UuidValue get _currentListId => card.listId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SidebarSection(
          title: 'Lista',
          trailing: ListSidebarMenu(
            lists: boardLists,
            currentListId: _currentListId,
            onSelect: onListChanged,
          ),
          child: Text(
            listName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        SidebarSection(
          title: 'Prioridade',
          trailing: PrioritySidebarMenu(
            currentPriority: card.priority,
            onSelect: onPriorityChanged,
          ),
          child: PriorityChip(priority: card.priority),
        ),
        SidebarSection(
          title: 'Etiquetas',
          trailing: LabelSidebarMenu(
            labels: boardLabels,
            selectedLabels: labels,
            onToggleLabel: onToggleLabel,
            onCreateLabel: onCreateLabel,
          ),
          placeholder: Text(
            'Nenhuma etiqueta',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          child: labels.isNotEmpty
              ? Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: labels
                      .map((l) => LabelChip(name: l.name, colorHex: l.colorHex))
                      .toList(),
                )
              : null,
        ),
        SidebarSection(
          title: 'Membros',
          trailing: GestureDetector(
            onTap: () {},
            child: const AddButton(),
          ),
          placeholder: Text(
            'Nenhum membro',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SidebarSection(
          title: 'Data de vencimento',
          trailing: SidebarPopover(
            anchor: Icon(
              Icons.edit_calendar_outlined,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            contentBuilder: (close) => KanewCalendar(
              initialDate: card.dueDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              onDateSelected: (date) {
                onDueDateChanged(date);
                close();
              },
            ),
          ),
          placeholder: Text(
            'Sem data definida',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          child: card.dueDate != null
              ? Text(
                  _formatDate(card.dueDate!),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
