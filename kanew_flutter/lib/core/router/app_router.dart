import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../di/injection.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/auth/view/forgot_password_screen.dart';
import '../../features/auth/view/reset_password_screen.dart';
import '../../features/auth/view/verification_screen.dart';
import '../../features/auth/view/set_password_screen.dart';

import '../../features/workspace/view/workspace_shell.dart';
import '../../features/workspace/pages/boards_page.dart';
import '../../features/workspace/pages/members_page.dart';
import '../../features/workspace/pages/settings_page.dart';
import '../../features/workspace/presentation/pages/accept_invite_page.dart';
import '../../features/workspace/viewmodel/workspace_controller.dart';
import '../../features/board/presentation/pages/board_view_page.dart';
import '../../features/board/presentation/pages/card_detail_page.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: false,
  refreshListenable: Listenable.merge([
    getIt<WorkspaceController>(),
    getIt<FlutterAuthSessionManager>().authInfoListenable,
  ]),
  redirect: (context, state) {
    final authManager = getIt<FlutterAuthSessionManager>();
    final workspaceViewModel = getIt<WorkspaceController>();
    final isAuthenticated = authManager.isAuthenticated;
    final path = state.uri.path;
    final isAuthRoute = path.startsWith('/auth');

    developer.log(
      'Router redirect - path: $path, auth: $isAuthenticated, '
      'hasWorkspaces: ${workspaceViewModel.hasWorkspaces}, '
      'loading: ${workspaceViewModel.isLoading}',
      name: 'app_router',
    );

    final isInviteRoute = path.startsWith('/invite');

    if (!isAuthenticated && !isAuthRoute && !isInviteRoute) {
      developer.log(
        'Redirecting to login (not authenticated)',
        name: 'app_router',
      );
      return Uri(
        path: RoutePaths.login,
        queryParameters: {'redirect': state.uri.toString()},
      ).toString();
    }

    if (isAuthenticated && (path == '/auth/login' || path == '/auth/signup')) {
      // Always check for redirect parameter first
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        developer.log(
          'Redirecting to preserved route: $redirect',
          name: 'app_router',
        );
        return redirect;
      }

      // No redirect - go to default workspace
      if (workspaceViewModel.isLoading) {
        developer.log('Waiting for workspaces to load...', name: 'app_router');
        return null; // Don't redirect yet, wait for workspaces
      }

      if (workspaceViewModel.hasWorkspaces) {
        final slug = workspaceViewModel.workspaces.first.slug;
        developer.log('Redirecting to workspace: $slug', name: 'app_router');
        return RoutePaths.workspaceBoards(slug);
      }

      return '/';
    }

    if (isAuthenticated && path == '/') {
      if (workspaceViewModel.isLoading) {
        return null;
      }

      if (workspaceViewModel.hasWorkspaces) {
        final slug = workspaceViewModel.workspaces.first.slug;
        developer.log(
          'Redirecting to first workspace: $slug',
          name: 'app_router',
        );
        return RoutePaths.workspaceBoards(slug);
      }

      return null;
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Página não encontrada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.path,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Voltar ao início'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ListenableBuilder(
        listenable: getIt<WorkspaceController>(),
        builder: (context, child) {
          final viewModel = getIt<WorkspaceController>();

          if (getIt<FlutterAuthSessionManager>().isAuthenticated &&
              !viewModel.hasWorkspaces &&
              !viewModel.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              developer.log(
                'Triggering workspace load from root route',
                name: 'app_router',
              );
              viewModel.loadWorkspaces();
            });
          }

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.isLoading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Carregando...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ] else if (viewModel.error != null) ...[
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Erro ao carregar',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        viewModel.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        developer.log(
                          'Retrying workspace load',
                          name: 'app_router',
                        );
                        viewModel.loadWorkspaces();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      'Carregando...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    ),

    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/invite/:code',
      builder: (context, state) {
        final code = state.pathParameters['code'] ?? '';
        return AcceptInvitePage(inviteCode: code);
      },
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final email =
            extras?['email'] ?? state.uri.queryParameters['email'] ?? '';
        final requestId =
            extras?['requestId'] ??
            state.uri.queryParameters['requestId'] ??
            '';
        return ResetPasswordScreen(email: email, accountRequestId: requestId);
      },
    ),
    GoRoute(
      path: '/auth/verification',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final email =
            extras?['email'] ?? state.uri.queryParameters['email'] ?? '';
        final requestId =
            extras?['requestId'] ??
            state.uri.queryParameters['requestId'] ??
            state.uri.queryParameters['accountRequestId'] ??
            '';
        final redirect =
            extras?['redirect'] ?? state.uri.queryParameters['redirect'];

        return VerificationScreen(
          email: email,
          accountRequestId: requestId,
          redirect: redirect,
        );
      },
    ),
    GoRoute(
      path: '/auth/set-password',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final email =
            extras?['email'] ?? state.uri.queryParameters['email'] ?? '';
        final token =
            extras?['token'] ?? state.uri.queryParameters['token'] ?? '';
        final redirect =
            extras?['redirect'] ?? state.uri.queryParameters['redirect'];

        return SetPasswordScreen(
          email: email,
          registrationToken: token,
          redirect: redirect,
        );
      },
    ),

    GoRoute(
      path: '/w/:slug',
      redirect: (context, state) {
        final slug = state.pathParameters['slug'];
        final fullPath = state.uri.path;

        if (fullPath == '/w/$slug') {
          return RoutePaths.workspaceBoards(slug!);
        }
        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            final uri = state.uri;
            final pathSegments = uri.pathSegments;
            final slug = pathSegments.length > 1 ? pathSegments[1] : null;

            return WorkspaceShell(
              navigationShell: navigationShell,
              workspaceSlug: slug ?? '',
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'boards',
                  pageBuilder: (context, state) {
                    final uri = state.uri;
                    final pathSegments = uri.pathSegments;
                    final workspaceSlug = pathSegments.length > 1
                        ? pathSegments[1]
                        : '';
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: BoardsPage(workspaceSlug: workspaceSlug),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: ':boardSlug',
                      pageBuilder: (context, state) {
                        final uri = state.uri;
                        final pathSegments = uri.pathSegments;
                        final workspaceSlug = pathSegments.length > 1
                            ? pathSegments[1]
                            : '';
                        final boardSlug =
                            state.pathParameters['boardSlug'] ?? '';
                        final extra = state.extra;
                        final boardId = extra is Map ? extra['boardId'] as int? : null;
                        return NoTransitionPage(
                          key: state.pageKey,
                          child: BoardViewPage(
                            workspaceSlug: workspaceSlug,
                            boardSlug: boardSlug,
                            boardId: boardId,
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'c/:cardUuid',
                          pageBuilder: (context, state) {
                            final uri = state.uri;
                            final pathSegments = uri.pathSegments;
                            final workspaceSlug = pathSegments.length > 1
                                ? pathSegments[1]
                                : '';
                            final boardSlug =
                                state.pathParameters['boardSlug'] ?? '';
                            final cardUuid =
                                state.pathParameters['cardUuid'] ?? '';
                            return NoTransitionPage(
                              key: state.pageKey,
                              child: CardDetailPage(
                                workspaceSlug: workspaceSlug,
                                boardSlug: boardSlug,
                                cardUuid: cardUuid,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'members',
                  pageBuilder: (context, state) {
                    final workspaceSlug = state.pathParameters['slug'] ?? '';
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: MembersPage(workspaceSlug: workspaceSlug),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'settings',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const SettingsPage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
