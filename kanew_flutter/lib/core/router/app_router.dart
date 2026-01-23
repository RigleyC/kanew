import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/viewmodel/auth_controller.dart';
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
  // Use Listenable.merge to listen to both auth and workspace state changes
  // This is the recommended approach per AGENTS.md
  refreshListenable: Listenable.merge([
    getIt<AuthController>(),
    getIt<WorkspaceController>(),
  ]),
  redirect: (context, state) {
    final authViewModel = getIt<AuthController>();
    final workspaceViewModel = getIt<WorkspaceController>();
    final isAuthenticated = authViewModel.isAuthenticated;
    final path = state.uri.path;
    final isAuthRoute = path.startsWith('/auth');

    developer.log(
      'Router redirect - path: $path, auth: $isAuthenticated, '
      'hasWorkspaces: ${workspaceViewModel.hasWorkspaces}, '
      'loading: ${workspaceViewModel.isLoading}',
      name: 'app_router',
    );

    // 1. Not authenticated and not on auth route → login
    if (!isAuthenticated && !isAuthRoute) {
      developer.log(
        'Redirecting to login (not authenticated)',
        name: 'app_router',
      );
      // Preserve the intended location
      return '${RoutePaths.login}?redirect=$path';
    }

    // 2. Authenticated on login/signup → redirect to workspace or preserved route
    if (isAuthenticated && (path == '/auth/login' || path == '/auth/signup')) {
      if (workspaceViewModel.isLoading) {
        developer.log('Waiting for workspaces to load...', name: 'app_router');
        return '/';
      }

      // Check for redirect param
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        developer.log(
          'Redirecting to preserved route: $redirect',
          name: 'app_router',
        );
        return redirect;
      }

      if (workspaceViewModel.hasWorkspaces) {
        final slug = workspaceViewModel.workspaces.first.slug;
        developer.log('Redirecting to workspace: $slug', name: 'app_router');
        return RoutePaths.workspaceBoards(slug);
      }

      // Edge case: no workspaces yet, go to root to trigger loading
      return '/';
    }

    // 3. Authenticated on root → redirect to first workspace
    if (isAuthenticated && path == '/') {
      // If workspaces are loading, stay on loading screen
      if (workspaceViewModel.isLoading) {
        return null; // Stay on loading screen
      }

      // If we have workspaces, redirect to the first one
      if (workspaceViewModel.hasWorkspaces) {
        final slug = workspaceViewModel.workspaces.first.slug;
        developer.log(
          'Redirecting to first workspace: $slug',
          name: 'app_router',
        );
        return RoutePaths.workspaceBoards(slug);
      }

      // If no workspaces and not loading, trigger loading
      // The builder will handle calling loadWorkspaces()
      return null; // Stay on root to trigger loading
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
          final authViewModel = getIt<AuthController>();

          // Only trigger workspace loading if authenticated and not already loading/loaded
          if (authViewModel.isAuthenticated &&
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

    // ================================================================
    // AUTH ROUTES
    // ================================================================
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
            '';
        return VerificationScreen(email: email, accountRequestId: requestId);
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
        return SetPasswordScreen(email: email, registrationToken: token);
      },
    ),

    // ================================================================
    // WORKSPACE ROUTES with StatefulShellRoute
    // ================================================================
    GoRoute(
      path: '/w/:slug',
      redirect: (context, state) {
        // Redirect /w/:slug to /w/:slug/boards
        final slug = state.pathParameters['slug'];
        final fullPath = state.uri.path;

        // Only redirect if exactly on /w/:slug (not on sub-routes)
        if (fullPath == '/w/$slug') {
          return RoutePaths.workspaceBoards(slug!);
        }
        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            // Extract slug from the current location
            final uri = state.uri;
            final pathSegments = uri.pathSegments;
            // Path is /w/:slug/... so slug is at index 1
            final slug = pathSegments.length > 1 ? pathSegments[1] : null;

            return WorkspaceShell(
              navigationShell: navigationShell,
              workspaceSlug: slug ?? '',
            );
          },
          branches: [
            // Tab 0: Boards (includes board view as nested route)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'boards',
                  pageBuilder: (context, state) {
                    final workspaceSlug = state.pathParameters['slug'] ?? '';
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: BoardsPage(workspaceSlug: workspaceSlug),
                    );
                  },
                  routes: [
                    // Board View Route - nested to keep sidebar visible
                    GoRoute(
                      path: ':boardSlug',
                      pageBuilder: (context, state) {
                        final workspaceSlug =
                            state.pathParameters['slug'] ?? '';
                        final boardSlug =
                            state.pathParameters['boardSlug'] ?? '';
                        return NoTransitionPage(
                          key: state.pageKey,
                          child: BoardViewPage(
                            workspaceSlug: workspaceSlug,
                            boardSlug: boardSlug,
                          ),
                        );
                      },
                      routes: [
                        // Card Detail Route - needs its own BoardScope wrapper
                        GoRoute(
                          path: 'c/:cardUuid',
                          pageBuilder: (context, state) {
                            final workspaceSlug =
                                state.pathParameters['slug'] ?? '';
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
            // Tab 1: Members
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'members',
                  pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const MembersPage(),
                  ),
                ),
              ],
            ),
            // Tab 2: Settings
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
