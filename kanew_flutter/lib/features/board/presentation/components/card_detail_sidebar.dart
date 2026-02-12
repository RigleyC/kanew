import 'package:flutter/material.dart' hide Card;
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/widgets/calendar/calendar.dart';
import '../../../../core/widgets/sidebar_menu/index.dart';
import '../../../../core/widgets/member/member_avatar.dart';
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
  final List<MemberWithUser> members;
  final Function(DateTime) onDueDateChanged;
  final VoidCallback onDueDateCleared;
  final Function(UuidValue) onToggleLabel;
  final Function(String, String) onCreateLabel;
  final Function(UuidValue) onListChanged;
  final Function(CardPriority) onPriorityChanged;
  final void Function(UuidValue? memberId) onAssigneeChanged;

  const CardDetailSidebar({
    super.key,
    required this.card,
    required this.listName,
    required this.boardLists,
    required this.labels,
    required this.boardLabels,
    required this.members,
    required this.onDueDateChanged,
    required this.onDueDateCleared,
    required this.onToggleLabel,
    required this.onCreateLabel,
    required this.onListChanged,
    required this.onPriorityChanged,
    required this.onAssigneeChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  UuidValue get _currentListId => card.listId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    MemberWithUser? assignee;
    final assigneeId = card.assigneeMemberId;
    if (assigneeId != null) {
      for (final m in members) {
        if (m.member.id == assigneeId) {
          assignee = m;
          break;
        }
      }
    }

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
          child: PriorityChip(priority: card.priority, showLabel: true),
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
            style: Theme.of(context).textTheme.bodyMedium,
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
          trailing: MemberSidebarMenu(
            members: members,
            selectedMemberId: card.assigneeMemberId,
            onSelect: onAssigneeChanged,
          ),
          placeholder: Text(
            'Nenhum membro',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          child: assignee == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    MemberAvatar(email: assignee.userEmail, size: 20),
                    Flexible(
                      child: Text(
                        assignee.userName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
            width: 320,
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
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(card.dueDate!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onDueDateCleared,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ],
    );
  }
}
