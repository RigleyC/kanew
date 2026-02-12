import 'package:flutter/material.dart' hide Card;
import 'package:kanew_client/kanew_client.dart';

import '../../../../core/constants/label_colors.dart';
import '../../../../core/constants/priority_utils.dart';
import '../../../../core/ui/kanew_ui.dart';
import '../../../../core/widgets/calendar/calendar.dart';
import '../../../../core/widgets/member/member_avatar.dart';
import 'label_chip.dart';
import 'priority_chip.dart';
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
        KanewPopover(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          offset: const Offset(0, 8),
          anchorBuilder: (context, controller) => GestureDetector(
            onTap: controller.toggle,
            child: SidebarSection(
              title: 'Lista',
              trailing: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              content: Text(
                listName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          contentBuilder: (context, close) => _menuContainer(
            context,
            width: 240,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: boardLists.map((list) {
                  final isSelected = list.id == _currentListId;
                  return ListTile(
                    dense: true,
                    leading: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: colorScheme.primary,
                          )
                        : const SizedBox(width: 16),
                    title: Text(
                      list.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () {
                      onListChanged(list.id!);
                      close();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        KanewPopover(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          offset: const Offset(0, 8),
          anchorBuilder: (context, controller) => GestureDetector(
            onTap: controller.toggle,
            child: SidebarSection(
              title: 'Prioridade',
              trailing: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              content: PriorityChip(priority: card.priority, showLabel: true),
            ),
          ),
          contentBuilder: (context, close) => _menuContainer(
            context,
            width: 240,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: CardPriority.values.map((priority) {
                  return ListTile(
                    dense: true,
                   
                    title: Text(
                      priority.label,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    trailing: priority == card.priority
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      onPriorityChanged(priority);
                      close();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        KanewPopover(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          offset: const Offset(0, 8),
          anchorBuilder: (context, controller) => GestureDetector(
            onTap: controller.toggle,
            child: SidebarSection(
              title: 'Etiquetas',
              trailing: Icon(
                Icons.add,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              placeholder: Text(
                'Nenhuma etiqueta',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              content: labels.isNotEmpty
                  ? Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: labels
                          .map((l) => LabelChip(name: l.name, colorHex: l.colorHex))
                          .toList(),
                    )
                  : null,
            ),
          ),
          contentBuilder: (context, _) => _menuContainer(
            context,
            width: 280,
            maxHeight: 420,
            child: _LabelsMenu(
              labels: boardLabels,
              selectedLabels: labels,
              onToggleLabel: onToggleLabel,
              onCreateLabel: onCreateLabel,
            ),
          ),
        ),
        KanewPopover(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          offset: const Offset(0, 8),
          anchorBuilder: (context, controller) => GestureDetector(
            onTap: controller.toggle,
            child: SidebarSection(
              title: 'Membros',
              trailing: Icon(
                Icons.add,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              placeholder: Text(
                'Nenhum membro',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              content: assignee == null
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
          ),
          contentBuilder: (context, close) => _menuContainer(
            context,
            width: 280,
            maxHeight: 420,
            child: _MembersMenu(
              members: members,
              selectedMemberId: card.assigneeMemberId,
              onSelect: (memberId) {
                onAssigneeChanged(memberId);
                close();
              },
            ),
          ),
        ),
        KanewPopover(
          menuAnchor: Alignment.topRight,
          childAnchor: Alignment.bottomRight,
          offset: const Offset(0, 8),
          anchorBuilder: (context, controller) => GestureDetector(
            onTap: controller.toggle,
            child: SidebarSection(
              title: 'Data de vencimento',
              trailing: Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              placeholder: Text(
                'Sem data definida',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              content: card.dueDate != null
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
          ),
          contentBuilder: (context, close) => _menuContainer(
            context,
            width: 320,
            child: KanewCalendar(
              initialDate: card.dueDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              onDateSelected: (date) {
                onDueDateChanged(date);
                close();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuContainer(
    BuildContext context, {
    required Widget child,
    double? width,
    double maxHeight = 360,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MembersMenu extends StatefulWidget {
  final List<MemberWithUser> members;
  final UuidValue? selectedMemberId;
  final void Function(UuidValue? memberId) onSelect;

  const _MembersMenu({
    required this.members,
    required this.selectedMemberId,
    required this.onSelect,
  });

  @override
  State<_MembersMenu> createState() => _MembersMenuState();
}

class _MembersMenuState extends State<_MembersMenu> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MemberWithUser> get _filteredMembers {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return widget.members;
    return widget.members.where((m) {
      return m.userName.toLowerCase().contains(q) ||
          m.userEmail.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Pesquisar...',
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            dense: true,
            leading: widget.selectedMemberId == null
                ? Icon(Icons.check, size: 18, color: theme.colorScheme.primary)
                : const SizedBox(width: 18),
            title: Text('Sem responsável', style: theme.textTheme.bodyMedium),
            onTap: () => widget.onSelect(null),
          ),
          const Divider(height: 1),
          if (_filteredMembers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Nenhum membro encontrado',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            ..._filteredMembers.map((m) {
              final isSelected = m.member.id == widget.selectedMemberId;
              return ListTile(
                dense: true,
                leading: isSelected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                    : const SizedBox(width: 18),
                title: Row(
                  spacing: 8,
                  children: [
                    MemberAvatar(email: m.userEmail, size: 24),
                    Expanded(
                      child: Text(
                        m.userName,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  m.userEmail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => widget.onSelect(m.member.id),
              );
            }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LabelsMenu extends StatefulWidget {
  final List<LabelDef> labels;
  final List<LabelDef> selectedLabels;
  final Function(UuidValue labelId) onToggleLabel;
  final Function(String name, String color) onCreateLabel;

  const _LabelsMenu({
    required this.labels,
    required this.selectedLabels,
    required this.onToggleLabel,
    required this.onCreateLabel,
  });

  @override
  State<_LabelsMenu> createState() => _LabelsMenuState();
}

class _LabelsMenuState extends State<_LabelsMenu> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _pendingLabelName = '';
  bool _showColorPicker = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LabelDef> get _filteredLabels {
    if (_searchQuery.isEmpty) return widget.labels;
    return widget.labels.where((label) {
      return label.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  bool _showCreateOption(String query) {
    if (query.isEmpty) return false;
    return !widget.labels.any(
      (l) => l.name.toLowerCase() == query.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_showColorPicker) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _showColorPicker = false),
                    borderRadius: BorderRadius.circular(4),
                    child: const Icon(Icons.keyboard_arrow_left, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Escolha uma cor',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ...LabelColors.options.map(
              (option) => InkWell(
                onTap: () {
                  widget.onCreateLabel(_pendingLabelName, option.hex);
                  setState(() {
                    _searchQuery = '';
                    _pendingLabelName = '';
                    _showColorPicker = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: option.color,
                        ),
                      ),
                      Text(option.name, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Pesquisar...',
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (_filteredLabels.isNotEmpty) ...[
            const Divider(height: 1),
            const SizedBox(height: 8),
            ..._filteredLabels.map((label) {
              final isSelected = widget.selectedLabels.any((l) => l.id == label.id);
              final colorOption = LabelColors.options.firstWhere(
                (o) => o.hex == label.colorHex,
                orElse: () => LabelColors.options[4],
              );
              return CheckboxListTile(
                value: isSelected,
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorOption.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(label.name, style: theme.textTheme.bodyMedium),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                onChanged: (_) => widget.onToggleLabel(label.id!),
              );
            }),
          ],
          if (_showCreateOption(_searchQuery)) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            InkWell(
              onTap: () {
                setState(() {
                  _pendingLabelName = _searchQuery;
                  _showColorPicker = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
                    Expanded(
                      child: Text(
                        'Criar nova etiqueta: "$_searchQuery"',
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_filteredLabels.isEmpty && !_showCreateOption(_searchQuery)) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Nenhuma etiqueta encontrada',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
