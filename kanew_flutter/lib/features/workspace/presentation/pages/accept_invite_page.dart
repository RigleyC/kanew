import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

import '../../../../core/di/injection.dart';
import '../../../../core/router/auth_route_helper.dart';
import '../../../../core/router/route_paths.dart';
import '../controllers/accept_invite_controller.dart';
import '../states/invite_state.dart';
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
  late final AcceptInviteController _controller;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    developer.log(
      '[AcceptInvitePage] initState - inviteCode: ${widget.inviteCode}, isAuth: ${getIt<AuthController>().isAuthenticated}',
      name: 'accept_invite',
    );
    
    _controller = getIt<AcceptInviteController>();
    _authController = getIt<AuthController>();
    
    _authController.addListener(_onAuthChanged);
    _controller.validateInvite(widget.inviteCode);
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Called when auth state changes - auto-accept invite if authenticated
  void _onAuthChanged() {
    final state = _controller.state;
    developer.log(
      '[AcceptInvitePage] _onAuthChanged - isAuth: ${_authController.isAuthenticated}, '
      'state: $state',
      name: 'accept_invite',
    );
    
    if (_authController.isAuthenticated &&
        state is InviteValidated &&
        _controller.state is! InviteAccepting &&
        _controller.state is! InviteAccepted) {
      developer.log(
        '[AcceptInvitePage] Auto-accepting invite',
        name: 'accept_invite',
      );
      _acceptInvite();
    }
  }

  Future<void> _acceptInvite() async {
    developer.log(
      '[AcceptInvitePage] _acceptInvite called',
      name: 'accept_invite',
    );
    
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

    await _controller.acceptInvite(widget.inviteCode);
    
    final state = _controller.state;
    if (state is InviteAccepted) {
      developer.log(
        '[AcceptInvitePage] Navigating to workspace: ${state.result.workspaceSlug}',
        name: 'accept_invite',
      );
      
      // Reload workspaces to include the new workspace
      final workspaceController = getIt<WorkspaceController>();
      await workspaceController.loadWorkspaces();

      // Redirect to the workspace boards page
      if (mounted) {
        context.go(RoutePaths.workspaceBoards(state.result.workspaceSlug));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = _authController.isAuthenticated;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: ValueListenableBuilder<InviteState>(
                valueListenable: _controller.store,
                builder: (context, state, _) {
                  return _buildContent(context, state, isAuthenticated);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, InviteState state, bool isAuthenticated) {
    return Column(
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
        switch (state) {
          InviteInitial() => const CircularProgressIndicator(),
          InviteValidating() => const Column(
              spacing: 16,
              children: [
                CircularProgressIndicator(),
                Text('Validando convite...'),
              ],
            ),
          InviteValidated(:final details) => _buildValidatedState(context, details, isAuthenticated),
          InviteAccepting() => const Column(
              spacing: 16,
              children: [
                CircularProgressIndicator(),
                Text('Aceitando convite...'),
              ],
            ),
          InviteAccepted() => const Column(
              spacing: 16,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                Text('Convite aceito com sucesso!'),
                Text('Redirecionando...'),
              ],
            ),
          InviteError(:final message) => _buildErrorState(context, message),
        },
      ],
    );
  }

  Widget _buildValidatedState(BuildContext context, InviteDetails details, bool isAuthenticated) {
    return Column(
      spacing: 16,
      children: [
        Text(
          'Você foi convidado para participar de "${details.workspaceName}".',
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
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Column(
      spacing: 16,
      children: [
        Text(
          message,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        FilledButton(
          onPressed: () => _controller.validateInvite(widget.inviteCode),
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}
