import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../member/member_avatar.dart';

class MemberSidebarMenu extends StatefulWidget {
  final List<MemberWithUser> members;
  final UuidValue? selectedMemberId;
  final void Function(UuidValue? memberId) onSelect;

  const MemberSidebarMenu({
    super.key,
    required this.members,
    required this.selectedMemberId,
    required this.onSelect,
  });

  @override
  State<MemberSidebarMenu> createState() => _MemberSidebarMenuState();
}

class _MemberSidebarMenuState extends State<MemberSidebarMenu> {
  final MenuController _controller = MenuController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onMenuOpen() {
    setState(() => _searchQuery = '');
    _searchController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
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

    return MenuAnchor(
      alignmentOffset: const Offset(-240, 8),
      controller: _controller,
      consumeOutsideTap: true,
      onOpen: _onMenuOpen,
      menuChildren: [
        SizedBox(
          width: 240,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
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
        ),
        const Divider(height: 1),
        SizedBox(
          width: 240,
          child: ListTile(
            dense: true,
            leading: widget.selectedMemberId == null
                ? Icon(Icons.check, size: 18, color: theme.colorScheme.primary)
                : const SizedBox(width: 18),
            title: Text(
              'Sem responsável',
              style: theme.textTheme.bodyMedium,
            ),
            onTap: () {
              widget.onSelect(null);
              _controller.close();
            },
          ),
        ),
        const Divider(height: 1),
        if (_filteredMembers.isEmpty)
          SizedBox(
            width: 240,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Nenhum membro encontrado',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          ..._filteredMembers.map((m) {
            final isSelected = m.member.id == widget.selectedMemberId;
            return SizedBox(
              width: 240,
              child: ListTile(
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
                onTap: () {
                  widget.onSelect(m.member.id);
                  _controller.close();
                },
              ),
            );
          }),
        const SizedBox(height: 8),
      ],
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }
}
