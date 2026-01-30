import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../data/member_repository.dart';
import '../../../auth/viewmodel/auth_controller.dart';

/// Public page for accepting workspace invites
class AcceptInvitePage extends StatefulWidget {
  final String inviteCode;

  const AcceptInvitePage({
    super.key,
    required this.inviteCode,
  });

  @override
  State<AcceptInvitePage> createState() => _AcceptInvitePageState();
}

class _AcceptInvitePageState extends State<AcceptInvitePage> {
  bool _isLoading = true;
  String? _error;
  String? _workspaceName;

  @override
  void initState() {
    super.initState();
    _validateInvite();
  }

  Future<void> _validateInvite() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repository = getIt<MemberRepository>();
    final result = await repository.getInviteByCode(widget.inviteCode);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        }
      },
      (invite) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            // In a real app, you'd fetch workspace name here
            _workspaceName = 'Workspace';
          });
        }
      },
    );
  }

  Future<void> _acceptInvite() async {
    final authController = getIt<AuthController>();

    // Check if user is authenticated
    if (!authController.isAuthenticated) {
      if (mounted) {
        // Redirect to login with return URL
        context.go('/auth/login?redirect=/invite/${widget.inviteCode}');
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repository = getIt<MemberRepository>();
    final result = await repository.acceptInvite(widget.inviteCode);

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        }
      },
      (workspaceId) {
        if (mounted) {
          // Redirect to the workspace
          context.go('/workspace/$workspaceId');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = getIt<AuthController>();
    final isAuthenticated = authController.isAuthenticated;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 24,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    'Convite para Workspace',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_error != null)
                    Column(
                      spacing: 16,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        FilledButton(
                          onPressed: _validateInvite,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    )
                  else ...[
                    Text(
                      'Você foi convidado para participar de "$_workspaceName".',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (!isAuthenticated)
                      Text(
                        'Faça login ou crie uma conta para aceitar o convite.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        if (isAuthenticated)
                          FilledButton.icon(
                            onPressed: _acceptInvite,
                            icon: const Icon(Icons.check),
                            label: const Text('Aceitar Convite'),
                          )
                        else ...[
                          FilledButton(
                            onPressed: () => context.go(
                              '/auth/login?redirect=/invite/${widget.inviteCode}',
                            ),
                            child: const Text('Fazer Login'),
                          ),
                          OutlinedButton(
                            onPressed: () => context.go(
                              '/auth/signup?redirect=/invite/${widget.inviteCode}',
                            ),
                            child: const Text('Criar Conta'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
