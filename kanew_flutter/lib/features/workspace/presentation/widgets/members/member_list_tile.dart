import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
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

    return ListTile(
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
      trailing: canEdit && !isOwner
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _handleMenuAction(value, context),
              itemBuilder: (context) => [
                if (onChangeRole != null) ...[
                  const PopupMenuItem(
                    value: 'role_member',
                    child: Text('Definir como Membro'),
                  ),
                  const PopupMenuItem(
                    value: 'role_admin',
                    child: Text('Definir como Admin'),
                  ),
                  const PopupMenuDivider(),
                ],
                if (onManagePermissions != null)
                  const PopupMenuItem(
                    value: 'permissions',
                    child: Text('Gerenciar Permissões'),
                  ),
                if (onTransferOwnership != null && role == MemberRole.admin)
                  const PopupMenuItem(
                    value: 'transfer',
                    child: Text('Transferir Propriedade'),
                  ),
                if (onRemove != null) ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            )
          : isOwner
              ? const Chip(
                  label: Text('Proprietário'),
                  labelStyle: TextStyle(fontSize: 12),
                  visualDensity: VisualDensity.compact,
                )
              : null,
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
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
