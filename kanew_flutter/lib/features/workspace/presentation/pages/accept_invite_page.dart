import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

import '../../../../core/di/injection.dart';
import '../../../../core/router/auth_route_helper.dart';
import '../../../../core/router/route_paths.dart';
import '../../data/member_repository.dart';
import '../../../auth/viewmodel/auth_controller.dart';
import '../../viewmodel/workspace_controller.dart';

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
  InviteDetails? _inviteDetails;

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
      (inviteDetails) {
        if (mounted) {
          setState(() {
            _inviteDetails = inviteDetails;
            _isLoading = false;
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
        context.go(AuthRouteHelper.login(
          redirect: RoutePaths.invite(widget.inviteCode),
        ));
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
      (acceptResult) async {
        if (mounted) {
          // Reload workspaces to include the new workspace
          final workspaceController = getIt<WorkspaceController>();
          await workspaceController.loadWorkspaces();
          
          // Redirect to the workspace boards page
          if (mounted) {
            context.go(RoutePaths.workspaceBoards(acceptResult.workspaceSlug));
          }
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
                      'Você foi convidado para participar de "${_inviteDetails?.workspaceName ?? 'um workspace'}".',
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
                              AuthRouteHelper.login(
                                redirect: RoutePaths.invite(widget.inviteCode),
                              ),
                            ),
                            child: const Text('Fazer Login'),
                          ),
                          OutlinedButton(
                            onPressed: () => context.go(
                              AuthRouteHelper.signup(
                                redirect: RoutePaths.invite(widget.inviteCode),
                              ),
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
