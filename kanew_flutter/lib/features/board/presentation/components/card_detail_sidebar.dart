import 'package:flutter/material.dart' hide Card;
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/widgets/calendar/calendar.dart';
import '../components/label_picker.dart';

class CardDetailSidebar extends StatefulWidget {
  final Card card;
  final String listName;
  final List<LabelDef> labels;
  final List<LabelDef> boardLabels;
  final VoidCallback onAddChecklist;
  final Function(DateTime) onDueDateChanged;
  final Function(int) onToggleLabel;
  final Function(String, String) onCreateLabel;

  const CardDetailSidebar({
    super.key,
    required this.card,
    required this.listName,
    required this.labels,
    required this.boardLabels,
    required this.onAddChecklist,
    required this.onDueDateChanged,
    required this.onToggleLabel,
    required this.onCreateLabel,
  });

  @override
  State<CardDetailSidebar> createState() => _CardDetailSidebarState();
}

class _CardDetailSidebarState extends State<CardDetailSidebar> with SingleTickerProviderStateMixin {
  late final FPopoverController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // List
        _SidebarItem(
          label: 'Lista',
          value: widget.listName,
        ),
        const SizedBox(height: 20),

        // Labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Etiquetas',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...widget.labels.map((label) => Chip(
                  label: Text(
                    label.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _parseColor(label.colorHex),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                )),
                MenuAnchor(
                  builder: (context, controller, child) {
                    return InkWell(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    );
                  },
                  menuChildren: [
                    LabelPicker(
                      boardLabels: widget.boardLabels,
                      selectedLabels: widget.labels,
                      onToggleLabel: (id) {
                        widget.onToggleLabel(id);
                      },
                      onCreateLabel: widget.onCreateLabel,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Checklists
        _SidebarItem(
          label: 'Checklist',
          action: '+ Adicionar checklist',
          onTap: widget.onAddChecklist,
        ),
        const SizedBox(height: 20),

        // Members (stub)
        _SidebarItem(
          label: 'Membros',
          action: '+ Adicionar membro',
          onTap: () {
            // TODO: Implement members
          },
        ),
        const SizedBox(height: 20),

        // Due date
        FPopover(
          control: FPopoverControl.managed(controller: _calendarController),
          child: _SidebarItem(
            label: 'Data de\nvencimento',
            value: widget.card.dueDate != null ? _formatDate(widget.card.dueDate!) : null,
            action: widget.card.dueDate == null ? '+ Definir data de vencimento' : null,
            onTap: _calendarController.toggle,
            valueOnTap: _calendarController.toggle,
          ),
          popoverBuilder: (context, _) => KanewCalendar(
            initialDate: widget.card.dueDate ?? DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
            onDateSelected: (date) {
              widget.onDueDateChanged(date);
              _calendarController.hide();
            },
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final String? value;
  final String? action;
  final VoidCallback? onTap;
  final VoidCallback? valueOnTap;

  const _SidebarItem({
    required this.label,
    this.value,
    this.action,
    this.onTap,
    this.valueOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        if (value != null)
          InkWell(
            onTap: valueOnTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                value!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          )
        else if (action != null)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                action!,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
