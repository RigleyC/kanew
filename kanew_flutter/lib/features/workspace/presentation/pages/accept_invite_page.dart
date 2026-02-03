import 'package:flutter/material.dart';
import 'dart:developer' as developer;
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
  bool _isAccepting = false;
  String? _error;
  InviteDetails? _inviteDetails;

  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    developer.log(
      '[AcceptInvitePage] initState - inviteCode: ${widget.inviteCode}, isAuth: ${getIt<AuthController>().isAuthenticated}',
      name: 'accept_invite',
    );
    _authController = getIt<AuthController>();
    _authController.addListener(_onAuthChanged);
    _validateInvite();
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthChanged);
    super.dispose();
  }

  /// Called when auth state changes - auto-accept invite if authenticated
  void _onAuthChanged() {
    developer.log(
      '[AcceptInvitePage] _onAuthChanged - isAuth: ${_authController.isAuthenticated}, '
      'hasDetails: ${_inviteDetails != null}, isAccepting: $_isAccepting, isLoading: $_isLoading',
      name: 'accept_invite',
    );
    if (_authController.isAuthenticated &&
        _inviteDetails != null &&
        !_isAccepting &&
        !_isLoading) {
      developer.log(
        '[AcceptInvitePage] Auto-accepting invite',
        name: 'accept_invite',
      );
      _acceptInvite();
    }
  }

  Future<void> _validateInvite() async {
    developer.log(
      '[AcceptInvitePage] _validateInvite starting',
      name: 'accept_invite',
    );
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final repository = getIt<MemberRepository>();
    final result = await repository.getInviteByCode(widget.inviteCode);

    result.fold(
      (failure) {
        developer.log(
          '[AcceptInvitePage] _validateInvite failed: ${failure.message}',
          name: 'accept_invite',
        );
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        }
      },
      (inviteDetails) {
        developer.log(
          '[AcceptInvitePage] _validateInvite success: inviteDetails=${inviteDetails?.workspaceName}',
          name: 'accept_invite',
        );
        if (mounted) {
          if (inviteDetails == null) {
            // Invite not found or already used
            developer.log(
              '[AcceptInvitePage] Invite is null - not found or already used',
              name: 'accept_invite',
            );
            setState(() {
              _error = 'Convite não encontrado ou já foi utilizado.';
              _isLoading = false;
            });
          } else {
            setState(() {
              _inviteDetails = inviteDetails;
              _isLoading = false;
            });

            // Auto-accept if user is already authenticated
            if (_authController.isAuthenticated) {
              developer.log(
                '[AcceptInvitePage] User is authenticated, auto-accepting',
                name: 'accept_invite',
              );
              _acceptInvite();
            } else {
              developer.log(
                '[AcceptInvitePage] User NOT authenticated, waiting for login',
                name: 'accept_invite',
              );
            }
          }
        }
      },
    );
  }

  Future<void> _acceptInvite() async {
    developer.log(
      '[AcceptInvitePage] _acceptInvite called',
      name: 'accept_invite',
    );
    // Prevent double-acceptance
    if (_isAccepting) {
      developer.log(
        '[AcceptInvitePage] Already accepting, skipping',
        name: 'accept_invite',
      );
      return;
    }

    // Check if user is authenticated
    if (!_authController.isAuthenticated) {
      developer.log(
        '[AcceptInvitePage] Not authenticated, redirecting to login',
        name: 'accept_invite',
      );
      if (mounted) {
        context.go(
          AuthRouteHelper.login(
            redirect: RoutePaths.invite(widget.inviteCode),
          ),
        );
      }
      return;
    }

    setState(() {
      _isAccepting = true;
      _error = null;
    });

    final repository = getIt<MemberRepository>();
    final result = await repository.acceptInvite(widget.inviteCode);

    result.fold(
      (failure) {
        developer.log(
          '[AcceptInvitePage] acceptInvite failed: ${failure.message}',
          name: 'accept_invite',
        );
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isAccepting = false;
          });
        }
      },
      (acceptResult) async {
        developer.log(
          '[AcceptInvitePage] acceptInvite success! workspaceSlug: ${acceptResult.workspaceSlug}',
          name: 'accept_invite',
        );
        if (mounted) {
          // Reload workspaces to include the new workspace
          final workspaceController = getIt<WorkspaceController>();
          await workspaceController.loadWorkspaces();

          // Redirect to the workspace boards page
          if (mounted) {
            developer.log(
              '[AcceptInvitePage] Navigating to workspace: ${acceptResult.workspaceSlug}',
              name: 'accept_invite',
            );
            context.go(RoutePaths.workspaceBoards(acceptResult.workspaceSlug));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = _authController.isAuthenticated;
    final isProcessing = _isLoading || _isAccepting;

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
                  if (isProcessing)
                    Column(
                      spacing: 16,
                      children: [
                        const CircularProgressIndicator(),
                        if (_isAccepting)
                          const Text(
                            'Aceitando convite...',
                            textAlign: TextAlign.center,
                          ),
                      ],
                    )
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
