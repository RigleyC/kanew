import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;
import '../../../../config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/member/permission_matrix.dart';

class InviteMemberDialog extends StatefulWidget {
  final List<PermissionInfo> allPermissions;
  final Future<WorkspaceInvite?> Function(
    List<UuidValue> permissionIds,
    String? email,
  ) onCreateInvite;

  const InviteMemberDialog({
    super.key,
    required this.allPermissions,
    required this.onCreateInvite,
  });

  @override
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  final _emailController = TextEditingController();
  List<UuidValue> _selectedPermissionIds = [];
  bool _isLoading = false;
  String? _inviteLink;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                    'Convidar Membro',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (opcional)',
                  hintText: 'email@exemplo.com',
                  border: OutlineInputBorder(),
                  helperText: 'Deixe vazio para gerar link generico',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Expanded(
                child: widget.allPermissions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16,
                          children: [
                            const Icon(
                              Icons.sentiment_dissatisfied,
                              size: 48,
                              color: Colors.grey,
                            ),
                            Text(
                              'Nenhuma permissao disponivel encontrada.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: PermissionMatrix(
                          permissions: widget.allPermissions,
                          onChanged: (ids) {
                            setState(() => _selectedPermissionIds = ids);
                          },
                        ),
                      ),
              ),
              if (_inviteLink != null) ...[
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: SelectableText(
                          _inviteLink!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copiar link',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _inviteLink!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Link copiado!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
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
                    onPressed: _isLoading ? null : _handleCreate,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _inviteLink == null ? 'Criar Convite' : 'Criar Outro',
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreate() async {
    if (_selectedPermissionIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos uma permissao')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final invite = await widget.onCreateInvite(
        _selectedPermissionIds,
        email.isEmpty ? null : email,
      );

      if (invite != null && mounted) {
        setState(() {
          _inviteLink = '${getIt<AppConfig>().webUrl}/invite/${invite.code}';
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Convite criado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar convite: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
