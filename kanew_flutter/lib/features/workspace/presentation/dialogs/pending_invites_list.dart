import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;
import 'package:intl/intl.dart';
import '../../../../config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/ui/kanew_ui.dart';

class PendingInvitesList extends StatelessWidget {
  final List<WorkspaceInvite> invites;
  final void Function(UuidValue inviteId) onRevoke;

  const PendingInvitesList({
    super.key,
    required this.invites,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    if (invites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Nenhum convite pendente',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invites.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final invite = invites[index];
        return _InviteTile(
          invite: invite,
          onRevoke: () => onRevoke(invite.id!),
        );
      },
    );
  }
}

class _InviteTile extends StatelessWidget {
  final WorkspaceInvite invite;
  final VoidCallback onRevoke;

  const _InviteTile({
    required this.invite,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final inviteLink = '${getIt<AppConfig>().webUrl}/invite/${invite.code}';
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          Icons.mail_outline,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        invite.email ?? 'Convite generico',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            'Criado em ${dateFormatter.format(invite.createdAt)}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${invite.initialPermissions.length} permissoes',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar link',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: inviteLink));
              showKanewInfoToast(
                context,
                title: 'Link copiado!',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Revogar convite',
            onPressed: () => _confirmRevoke(context),
          ),
        ],
      ),
    );
  }

  void _confirmRevoke(BuildContext context) {
    showKanewConfirmDialog(
      context: context,
      title: 'Revogar Convite',
      body:
          'Tem certeza que deseja revogar este convite? Esta acao nao pode ser desfeita.',
      confirmText: 'Revogar',
      destructive: true,
      onConfirm: () {
        onRevoke();
      },
    );
  }
}
