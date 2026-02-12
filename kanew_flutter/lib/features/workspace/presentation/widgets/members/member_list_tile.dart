import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../../core/ui/kanew_ui.dart';
import '../../../../../core/widgets/member/member_avatar.dart';
import '../../../../../core/widgets/member/member_role_badge.dart';
import '../../../../../core/widgets/member/member_status_badge.dart';

/// List tile displaying member info with actions menu
class MemberListTile extends StatelessWidget {
  final MemberWithUser memberWithUser;
  final VoidCallback? onRemove;
  final void Function(MemberRole)? onChangeRole;
  final VoidCallback? onManagePermissions;
  final VoidCallback? onTransferOwnership;
  final bool canEdit;

  const MemberListTile({
    super.key,
    required this.memberWithUser,
    this.onRemove,
    this.onChangeRole,
    this.onManagePermissions,
    this.onTransferOwnership,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    final member = memberWithUser.member;
    final email = memberWithUser.userEmail;
    final name = memberWithUser.userName;
    final role = member.role;
    final status = member.status;
    final isOwner = role == MemberRole.owner;

    final tile = ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: MemberAvatar(
        email: email,
        imageUrl: memberWithUser.userImageUrl,
        size: 48,
      ),
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MemberRoleBadge(role: role, compact: true),
          if (status != MemberStatus.active)
            MemberStatusBadge(status: status, compact: true),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          email,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: canEdit && !isOwner ? const Icon(Icons.more_vert) : null,
    );

    if (!canEdit || isOwner) return tile;

    return KanewPopover(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      offset: const Offset(0, 8),
      anchorBuilder: (context, controller) => InkWell(
        onTap: controller.toggle,
        borderRadius: BorderRadius.circular(8),
        child: tile,
      ),
      contentBuilder: (context, close) => _MemberActionsMenu(
        onAction: (action) {
          close();
          _handleMenuAction(action, context);
        },
        canChangeRole: onChangeRole != null,
        canManagePermissions: onManagePermissions != null,
        canTransferOwnership: onTransferOwnership != null && role == MemberRole.admin,
        canRemove: onRemove != null,
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'role_guest':
        onChangeRole?.call(MemberRole.guest);
        break;
      case 'role_member':
        onChangeRole?.call(MemberRole.member);
        break;
      case 'role_admin':
        onChangeRole?.call(MemberRole.admin);
        break;
      case 'permissions':
        onManagePermissions?.call();
        break;
      case 'transfer':
        onTransferOwnership?.call();
        break;
      case 'remove':
        onRemove?.call();
        break;
    }
  }
}

class _MemberActionsMenu extends StatelessWidget {
  final void Function(String action) onAction;
  final bool canChangeRole;
  final bool canManagePermissions;
  final bool canTransferOwnership;
  final bool canRemove;

  const _MemberActionsMenu({
    required this.onAction,
    required this.canChangeRole,
    required this.canManagePermissions,
    required this.canTransferOwnership,
    required this.canRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 240,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canChangeRole) ...[
            _menuItem(context, 'Definir como Convidado', () => onAction('role_guest')),
            _menuItem(context, 'Definir como Membro', () => onAction('role_member')),
            _menuItem(context, 'Definir como Admin', () => onAction('role_admin')),
            Divider(height: 1, color: colorScheme.outlineVariant),
          ],
          if (canManagePermissions)
            _menuItem(context, 'Gerenciar Permissões', () => onAction('permissions')),
          if (canTransferOwnership)
            _menuItem(context, 'Transferir Propriedade', () => onAction('transfer')),
          if (canRemove) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _menuItem(
              context,
              'Remover',
              () => onAction('remove'),
              color: colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
