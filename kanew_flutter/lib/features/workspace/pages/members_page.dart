import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

import '../../../core/di/injection.dart';
import '../../../core/ui/kanew_ui.dart';
import '../../../core/widgets/base/button.dart';
import '../../../core/widgets/member/permission_matrix.dart';
import '../presentation/controllers/members_controller.dart';
import '../presentation/states/members_state.dart';
import '../presentation/dialogs/invite_member_dialog.dart';
import '../presentation/dialogs/transfer_ownership_dialog.dart';
import '../presentation/dialogs/pending_invites_list.dart';
import '../presentation/widgets/members/member_list_tile.dart';

class MembersPage extends StatefulWidget {
  final String workspaceSlug;

  const MembersPage({
    super.key,
    required this.workspaceSlug,
  });

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late final MembersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = getIt<MembersController>();
    _controller.init(widget.workspaceSlug);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Membros',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              KanbnButton(
                label: 'Convidar',
                variant: ButtonVariant.primary,
                iconLeft: const Icon(FIcons.userPlus),
                onPressed: _showInviteDialog,
              ),
            ],
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<MembersState>(
            valueListenable: _controller.store,
            builder: (context, state, _) {
              return switch (state) {
                MembersInitial() => _buildLoadingState(
                  context,
                  'Inicializando...',
                ),
                MembersLoading() => _buildLoadingState(
                  context,
                  'Carregando membros...',
                ),
                MembersLoaded(
                  :final members,
                  :final invites,
                  :final allPermissions,
                ) =>
                  _buildContent(context, members, invites, allPermissions),
                MembersError(:final message) => _buildError(context, message),
              };
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<MemberWithUser> members,
    List<WorkspaceInvite> invites,
    List<Permission> allPermissions,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Text(
            'Membros Ativos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Card(
            child: members.isEmpty
                ? _buildEmptyState(
                    context,
                    icon: Icons.people_outline,
                    message: 'Nenhum membro encontrado',
                  )
                : Column(
                    children: members.map((memberWithUser) {
                      final isOwner =
                          memberWithUser.member.role == MemberRole.owner;
                      return MemberListTile(
                        memberWithUser: memberWithUser,
                        canEdit: !isOwner,
                        onRemove: () async {
                          await _confirmRemoveMember(
                            context,
                            memberWithUser.member.id!,
                            memberWithUser.userName,
                          );
                        },
                        onChangeRole: (newRole) => _changeMemberRole(
                          memberWithUser.member.id!,
                          newRole,
                        ),
                        onManagePermissions: () => _showPermissionsDialog(
                          memberWithUser.member.id!,
                          memberWithUser.userName,
                        ),
                        onTransferOwnership: () =>
                            _showTransferOwnershipDialog(members),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 32),
          Text(
            'Convites Pendentes',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          Card(
            child: invites.isEmpty
                ? _buildEmptyState(
                    context,
                    icon: Icons.mail_outline,
                    message: 'Nenhum convite pendente',
                  )
                : PendingInvitesList(
                    invites: invites,
                    onRevoke: _revokeInvite,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          const CircularProgressIndicator(),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          Text(message),
          FilledButton(
            onPressed: () => _controller.init(widget.workspaceSlug),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog() {
    final state = _controller.state;
    if (state is! MembersLoaded) return;

    showDialog(
      context: context,
      builder: (context) => InviteMemberDialog(
        allPermissions: state.allPermissions
            .map(
              (p) => PermissionInfo(
                permission: p,
                granted: false,
                isDefault: false,
                isAdded: false,
                isRemoved: false,
              ),
            )
            .toList(),
        onCreateInvite: (permissionIds, email) {
          return _controller.createInvite(
            _controller.workspaceId!,
            permissionIds,
            email: email,
          );
        },
      ),
    );
  }

  Future<void> _confirmRemoveMember(
    BuildContext parentContext,
    UuidValue memberId,
    String userName,
  ) async {
    await showKanewConfirmDialog(
      context: parentContext,
      title: 'Remover Membro',
      body: 'Tem certeza que deseja remover $userName do workspace?',
      confirmText: 'Remover',
      destructive: true,
      onConfirm: () async {
        final success = await _controller.removeMember(memberId);
        if (!mounted || !parentContext.mounted) return;
        if (success) {
          showKanewSuccessToast(
            parentContext,
            title: 'Membro removido com sucesso',
          );
        } else {
          showKanewErrorToast(
            parentContext,
            title: 'Erro ao remover membro',
          );
        }
      },
    );
  }

  Future<void> _changeMemberRole(UuidValue memberId, MemberRole newRole) async {
    final success = await _controller.updateMemberRole(memberId, newRole);
    if (mounted) {
      if (success) {
        showKanewSuccessToast(context, title: 'Papel atualizado com sucesso');
      } else {
        showKanewErrorToast(context, title: 'Erro ao atualizar papel');
      }
    }
  }

  Future<void> _showPermissionsDialog(
    UuidValue memberId,
    String userName,
  ) async {
    final permissions = await _controller.getMemberPermissions(memberId);
    if (permissions == null || !mounted) return;

    await showDialog(
      context: context,
      builder: (context) => _PermissionsDialog(
        memberId: memberId,
        userName: userName,
        permissions: permissions,
        onSave: (selectedIds) =>
            _controller.updateMemberPermissions(memberId, selectedIds),
      ),
    );
  }

  void _showTransferOwnershipDialog(List<MemberWithUser> members) {
    showDialog(
      context: context,
      builder: (context) => TransferOwnershipDialog(
        members: members,
        onTransfer: (newOwnerId) {
          return _controller.transferOwnership(
            _controller.workspaceId!,
            newOwnerId,
          );
        },
      ),
    );
  }

  Future<void> _revokeInvite(UuidValue inviteId) async {
    final success = await _controller.revokeInvite(inviteId);
    if (mounted) {
      if (success) {
        showKanewSuccessToast(context, title: 'Convite revogado');
      } else {
        showKanewErrorToast(context, title: 'Erro ao revogar convite');
      }
    }
  }
}

class _PermissionsDialog extends StatefulWidget {
  final UuidValue memberId;
  final String userName;
  final List<PermissionInfo> permissions;
  final Future<bool> Function(List<UuidValue> selectedIds) onSave;

  const _PermissionsDialog({
    required this.memberId,
    required this.userName,
    required this.permissions,
    required this.onSave,
  });

  @override
  State<_PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<_PermissionsDialog> {
  late Set<UuidValue> _selectedIds;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.permissions
        .where((p) => p.granted)
        .map((p) => p.permission.id!)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permissões de ${widget.userName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: PermissionMatrix(
                    permissions: widget.permissions,
                    onChanged: (selectedIds) {
                      setState(() => _selectedIds = selectedIds.toSet());
                    },
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: _isSaving ? null : _handleSave,
                    child: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      final success = await widget.onSave(_selectedIds.toList());

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
          showKanewSuccessToast(
            context,
            title: 'Permissões atualizadas com sucesso',
          );
        } else {
          showKanewErrorToast(
            context,
            title: 'Erro ao salvar permissões',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showKanewErrorToast(
          context,
          title: 'Erro ao salvar permissões',
          description: '$e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
