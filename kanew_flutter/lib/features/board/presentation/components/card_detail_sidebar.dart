import 'package:flutter/material.dart' hide Card;
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/widgets/add_button.dart';
import '../../../../core/widgets/calendar/calendar.dart';
import '../../../../core/widgets/searchable_list_content.dart';
import 'label_chip.dart';
import 'label_picker.dart';
import 'sidebar_popover.dart';
import 'sidebar_section.dart';

class CardDetailSidebar extends StatelessWidget {
  final Card card;
  final String listName;
  final List<CardList> boardLists;
  final List<LabelDef> labels;
  final List<LabelDef> boardLabels;
  final VoidCallback onAddChecklist;
  final Function(DateTime) onDueDateChanged;
  final Function(int) onToggleLabel;
  final Function(String, String) onCreateLabel;
  final Function(int) onListChanged;

  const CardDetailSidebar({
    super.key,
    required this.card,
    required this.listName,
    required this.boardLists,
    required this.labels,
    required this.boardLabels,
    required this.onAddChecklist,
    required this.onDueDateChanged,
    required this.onToggleLabel,
    required this.onCreateLabel,
    required this.onListChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  CardList get _currentList => boardLists.firstWhere(
        (l) => l.id == card.listId,
        orElse: () => boardLists.first,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lista
        SidebarSection(
          title: 'Lista',
          trailing: SidebarPopover(
            anchor: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            contentBuilder: (close) => SearchableListContent<CardList>(
              items: boardLists,
              selectedItems: [_currentList],
              labelBuilder: (l) => l.title,
              onSelect: (l) => onListChanged(l.id!),
              onClose: close,
              closeOnSelect: true,
              isEqual: (a, b) => a.id == b.id,
              searchHint: 'Buscar lista...',
            ),
          ),
          child: Text(
            _currentList.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        // Etiquetas
        SidebarSection(
          title: 'Etiquetas',
          trailing: SidebarPopover(
            anchor: const AddButton(),
            contentBuilder: (_) => LabelPicker(
              boardLabels: boardLabels,
              selectedLabels: labels,
              onToggleLabel: onToggleLabel,
              onCreateLabel: onCreateLabel,
            ),
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

        // Checklist
        SidebarSection(
          title: 'Checklist',
          trailing: GestureDetector(
            onTap: onAddChecklist,
            child: const AddButton(),
          ),
          placeholder: Text(
            'Nenhum checklist',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // Membros
        SidebarSection(
          title: 'Membros',
          trailing: GestureDetector(
            onTap: () {
              // TODO: Implement members
            },
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

        // Data de vencimento
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
