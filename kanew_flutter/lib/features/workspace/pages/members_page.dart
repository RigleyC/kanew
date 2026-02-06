import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

import '../../../core/di/injection.dart';
import '../../../core/widgets/sidebar/sidebar.dart';
import '../../../core/widgets/base/button.dart';
import '../../../core/dialogs/members/invite_member_dialog.dart';
import '../../../core/dialogs/members/transfer_ownership_dialog.dart';
import '../../../core/dialogs/members/pending_invites_list.dart';
import '../../../core/widgets/member/permission_matrix.dart';
import '../presentation/controllers/members_page_controller.dart';
import '../presentation/widgets/members/member_list_tile.dart';

import '../viewmodel/workspace_controller.dart';

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
  late final MembersPageController _controller;
  late final WorkspaceController _workspaceController;
  Object? _initError;
  int? _workspaceId;

  @override
  void initState() {
    super.initState();
    _workspaceController = getIt<WorkspaceController>();
    _controller = getIt<MembersPageController>();
    _loadWorkspace();
  }

  Future<void> _loadWorkspace() async {
    try {
      final success = await _workspaceController.setCurrentWorkspaceBySlug(
        widget.workspaceSlug,
      );

      if (!success) {
        throw Exception('Workspace not found');
      }

      final workspace = _workspaceController.currentWorkspace!;

      if (mounted) {
        setState(() {
          _workspaceId = workspace.id;
          _initError = null;
        });
      }

      if (_workspaceId != null) {
        await _controller.loadData(_workspaceId!);
      }
    } catch (e) {
      debugPrint('[MembersPage] Error loading workspace: $e');
      if (mounted) {
        setState(() {
          _initError = e;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = SidebarProvider.maybeOf(context);
    final isMobile = provider?.isMobile ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SidebarTrigger(),
                ),
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
        // Content
        Expanded(
          child: _initError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      Text('Erro ao carregar workspace: $_initError'),
                      FilledButton(
                        onPressed: _loadWorkspace,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _workspaceId == null
              ? const Center(child: CircularProgressIndicator())
              : ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    if (_controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_controller.error != null) {
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
                            Text(_controller.error!),
                            FilledButton(
                              onPressed: () =>
                                  _controller.loadData(_workspaceId!),
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 24,
                        children: [
                          // Members list
                          Text(
                            'Membros Ativos',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Card(
                            child: Column(
                              children: _controller.members.map((
                                memberWithUser,
                              ) {
                                final isOwner =
                                    memberWithUser.member.role ==
                                    MemberRole.owner;
                                return MemberListTile(
                                  memberWithUser: memberWithUser,
                                  canEdit: !isOwner,
                                  onRemove: () => _confirmRemoveMember(
                                    context,
                                    memberWithUser.member.id!,
                                    memberWithUser.userName,
                                  ),
                                  onChangeRole: (newRole) => _changeMemberRole(
                                    memberWithUser.member.id!,
                                    newRole,
                                  ),
                                  onManagePermissions: () =>
                                      _showPermissionsDialog(
                                        memberWithUser.member.id!,
                                        memberWithUser.userName,
                                      ),
                                  onTransferOwnership: () =>
                                      _showTransferOwnershipDialog(),
                                );
                              }).toList(),
                            ),
                          ),

                          // Pending invites
                          const SizedBox(height: 32),
                          Text(
                            'Convites Pendentes',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Card(
                            child: PendingInvitesList(
                              invites: _controller.invites,
                              onRevoke: _revokeInvite,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showInviteDialog() {
    showDialog(
      context: context,
      builder: (context) => InviteMemberDialog(
        allPermissions: _controller.allPermissions
            .map((p) => PermissionInfo(permission: p, granted: false))
            .toList(),
        onCreateInvite: (permissionIds, email) {
          return _controller.createInvite(
            _workspaceId!,
            permissionIds,
            email: email,
          );
        },
      ),
    );
  }

  void _confirmRemoveMember(
    BuildContext context,
    int memberId,
    String userName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Membro'),
        content: Text('Tem certeza que deseja remover $userName do workspace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await _controller.removeMember(memberId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Membro removido com sucesso'
                          : 'Erro ao remover membro',
                    ),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeMemberRole(int memberId, MemberRole newRole) async {
    final success = await _controller.updateMemberRole(memberId, newRole);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Papel atualizado com sucesso'
                : 'Erro ao atualizar papel',
          ),
        ),
      );
    }
  }

  Future<void> _showPermissionsDialog(int memberId, String userName) async {
    final permissions = await _controller.getMemberPermissions(memberId);
    if (permissions == null || !mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      'Permissões de $userName',
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
                      permissions: permissions,
                      onChanged: (selectedIds) {
                        // Update will be triggered on save button
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
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTransferOwnershipDialog() {
    showDialog(
      context: context,
      builder: (context) => TransferOwnershipDialog(
        members: _controller.members,
        onTransfer: (newOwnerId) {
          return _controller.transferOwnership(_workspaceId!, newOwnerId);
        },
      ),
    );
  }

  Future<void> _revokeInvite(int inviteId) async {
    final success = await _controller.revokeInvite(inviteId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Convite revogado' : 'Erro ao revogar convite',
          ),
        ),
      );
    }
  }
}
