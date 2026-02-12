import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;
import '../../../../core/ui/kanew_ui.dart';
import '../../../../core/widgets/member/member_avatar.dart';
import '../../../../core/widgets/member/member_role_badge.dart';

class TransferOwnershipDialog extends StatefulWidget {
  final List<MemberWithUser> members;
  final Future<bool> Function(UuidValue newOwnerId) onTransfer;

  const TransferOwnershipDialog({
    super.key,
    required this.members,
    required this.onTransfer,
  });

  @override
  State<TransferOwnershipDialog> createState() {
    return _TransferOwnershipDialogState();
  }
}

class _TransferOwnershipDialogState extends State<TransferOwnershipDialog> {
  MemberWithUser? _selectedMember;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final eligibleMembers = widget.members
        .where((m) => m.member.role == MemberRole.admin)
        .toList();

    return AlertDialog(
      title: const Text('Transferir Propriedade'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const Text(
              'Selecione um administrador para se tornar o novo proprietario do workspace. '
              'Voce perdera o status de proprietario e se tornara um administrador.',
              style: TextStyle(fontSize: 14),
            ),
            const Divider(),
            if (eligibleMembers.isEmpty)
              const Text(
                'Nao ha administradores disponiveis para transferencia.',
                style: TextStyle(color: Colors.orange),
              )
            else
              DropdownButtonFormField<MemberWithUser>(
                decoration: const InputDecoration(
                  labelText: 'Novo Proprietario',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedMember,
                items: eligibleMembers.map((member) {
                  return DropdownMenuItem(
                    value: member,
                    child: Row(
                      spacing: 12,
                      children: [
                        MemberAvatar(
                          email: member.userEmail,
                          imageUrl: member.userImageUrl,
                          size: 32,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                member.userEmail,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        MemberRoleBadge(
                          role: member.member.role,
                          compact: true,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedMember = value);
                },
              ),
            if (_selectedMember != null) ...[
              const Divider(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Estaacao e irreversivel. Voce nao podera desfazer esta operacao.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _selectedMember == null || _isLoading
              ? null
              : _handleTransfer,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Transferir'),
        ),
      ],
    );
  }

  Future<void> _handleTransfer() async {
    if (_selectedMember == null) return;

    setState(() => _isLoading = true);

    try {
      final success = await widget.onTransfer(_selectedMember!.member.id!);

      if (mounted) {
        if (success) {
          Navigator.of(context).pop();
          showKanewSuccessToast(
            context,
            title: 'Propriedade transferida com sucesso!',
          );
        } else {
          showKanewErrorToast(
            context,
            title: 'Erro ao transferir propriedade',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showKanewErrorToast(
          context,
          title: 'Erro ao transferir propriedade',
          description: '$e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
