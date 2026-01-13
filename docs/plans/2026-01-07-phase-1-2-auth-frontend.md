# Phase 1.2: Authentication Frontend

> REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement auth screens (Login, Signup, Password Reset) with premium UI using forui components, integrating with Serverpod Auth IDP and zenRouter for navigation.

**Architecture:** Use `zenRouter` Coordinator pattern with `RouteRedirect` for auth guards. Use `forui` components for consistent, beautiful UI. Wrap Serverpod Auth widgets with custom styling.

**Tech Stack:** Flutter 3.32, zenrouter 0.4.17, forui 0.17.0, serverpod_auth_idp_flutter

---

## Proposed Changes

### Dependencies

---

#### [MODIFY] [pubspec.yaml](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/pubspec.yaml)

Add zenrouter and forui:

```yaml
dependencies:
  # ... existing deps
  zenrouter: ^0.4.17
  forui: ^0.17.0
```

---

### Router Setup (zenRouter Coordinator Pattern)

---

#### [NEW] [app_routes.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/config/routes/app_routes.dart)

Define all route classes:

```dart
import 'package:flutter/material.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../main.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/workspace/workspace_list_screen.dart';

/// Base class for all app routes
abstract class AppRoute extends RouteTarget with RouteUnique {}

/// Home/Workspace list - protected route
class HomeRoute extends AppRoute with RouteRedirect {
  @override
  Uri toUri() => Uri.parse('/');

  @override
  Future<AppRoute?> redirect() async {
    final isAuthenticated = client.auth.isAuthenticated;
    if (!isAuthenticated) {
      return LoginRoute();
    }
    return null; // No redirect, proceed normally
  }

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return WorkspaceListScreen(coordinator: coordinator);
  }
}

/// Login screen
class LoginRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/auth/login');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return LoginScreen(coordinator: coordinator);
  }
}

/// Signup screen
class SignupRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/auth/signup');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return SignupScreen(coordinator: coordinator);
  }
}

/// Forgot password screen
class ForgotPasswordRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/auth/forgot-password');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ForgotPasswordScreen(coordinator: coordinator);
  }
}

/// Reset password screen with token
class ResetPasswordRoute extends AppRoute {
  final String token;
  ResetPasswordRoute({required this.token});

  @override
  Uri toUri() => Uri.parse('/auth/reset-password?token=$token');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ResetPasswordScreen(coordinator: coordinator, token: token);
  }
}

/// Invite accept screen (prepared for Phase 8)
class InviteAcceptRoute extends AppRoute {
  final String code;
  InviteAcceptRoute({required this.code});

  @override
  Uri toUri() => Uri.parse('/invite/$code');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    // Placeholder - will be implemented in Phase 8
    return Scaffold(body: Center(child: Text('Invite: $code')));
  }
}

/// 404 Not Found
class NotFoundRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/404');

  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
```

---

#### [NEW] [app_coordinator.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/config/routes/app_coordinator.dart)

Create the coordinator that parses URIs to routes:

```dart
import 'package:zenrouter/zenrouter.dart';
import 'app_routes.dart';

class AppCoordinator extends Coordinator<AppRoute> {
  @override
  AppRoute parseRouteFromUri(Uri uri) {
    final segments = uri.pathSegments;
    
    return switch (segments) {
      // Home
      [] => HomeRoute(),
      
      // Auth routes
      ['auth', 'login'] => LoginRoute(),
      ['auth', 'signup'] => SignupRoute(),
      ['auth', 'forgot-password'] => ForgotPasswordRoute(),
      ['auth', 'reset-password'] => ResetPasswordRoute(
          token: uri.queryParameters['token'] ?? '',
        ),
      
      // Invite route
      ['invite', String code] => InviteAcceptRoute(code: code),
      
      // Not found
      _ => NotFoundRoute(),
    };
  }
}

/// Global coordinator instance
final appCoordinator = AppCoordinator();
```

---

### Forui Theme Setup

---

#### [NEW] [app_theme.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/config/app_theme.dart)

Configure forui theme:

```dart
import 'package:forui/forui.dart';

/// App theme configuration using forui
class AppTheme {
  /// Dark theme (primary for Kanew)
  static FThemeData get dark => FThemes.zinc.dark;
  
  /// Light theme
  static FThemeData get light => FThemes.zinc.light;
  
  /// Custom accent color (cyan)
  static const accentColor = Color(0xFF00d9ff);
}
```

---

### Auth Screens with Forui

---

#### [NEW] [login_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/screens/auth/login_screen.dart)

Login screen using forui components:

```dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../config/routes/app_routes.dart';
import '../../main.dart';

class LoginScreen extends StatelessWidget {
  final Coordinator coordinator;
  const LoginScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return FScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: FCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Icon(
                        Icons.dashboard_rounded,
                        size: 64,
                        color: Color(0xFF00d9ff),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kanew',
                        style: theme.typography.xl2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Welcome back!',
                        style: theme.typography.sm.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Serverpod Auth Widget
                      SignInWidget(
                        client: client,
                        onAuthenticated: () {
                          coordinator.replace(HomeRoute());
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Signup link
                      FButton.text(
                        onPress: () => coordinator.push(SignupRoute()),
                        child: Text("Don't have an account? Sign up"),
                      ),
                      
                      // Forgot Password link
                      FButton.text(
                        onPress: () => coordinator.push(ForgotPasswordRoute()),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: theme.colors.mutedForeground),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

#### [NEW] [signup_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/screens/auth/signup_screen.dart)

Signup screen:

```dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../config/routes/app_routes.dart';
import '../../main.dart';

class SignupScreen extends StatelessWidget {
  final Coordinator coordinator;
  const SignupScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return FScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: FCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Icon(
                        Icons.dashboard_rounded,
                        size: 64,
                        color: Color(0xFF00d9ff),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kanew',
                        style: theme.typography.xl2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your account',
                        style: theme.typography.sm.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Serverpod Auth Widget (signup mode)
                      SignInWidget(
                        client: client,
                        onAuthenticated: () {
                          coordinator.replace(HomeRoute());
                        },
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Login link
                      FButton.text(
                        onPress: () => coordinator.pop(),
                        child: Text('Already have an account? Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

#### [NEW] [forgot_password_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/screens/auth/forgot_password_screen.dart)

Forgot password screen:

```dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../config/routes/app_routes.dart';
import '../../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Coordinator coordinator;
  const ForgotPasswordScreen({super.key, required this.coordinator});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _requestReset() async {
    if (_emailController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    try {
      await client.passwordReset.requestReset(_emailController.text);
      setState(() => _emailSent = true);
    } catch (e) {
      if (mounted) {
        FToaster.of(context).add(
          FToast.error(
            title: const Text('Error'),
            description: Text(e.toString()),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return FScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: FCard(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: _emailSent ? _buildSuccessMessage(theme) : _buildForm(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(FThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.mark_email_read, size: 64, color: Colors.green),
        SizedBox(height: 16),
        Text(
          'Check your email',
          style: theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'We sent a password reset link to ${_emailController.text}',
          textAlign: TextAlign.center,
          style: theme.typography.sm.copyWith(color: theme.colors.mutedForeground),
        ),
        SizedBox(height: 24),
        FButton.text(
          onPress: () => widget.coordinator.replace(LoginRoute()),
          child: Text('Back to login'),
        ),
      ],
    );
  }

  Widget _buildForm(FThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_reset, size: 64, color: Color(0xFF00d9ff)),
        SizedBox(height: 16),
        Text(
          'Reset Password',
          style: theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your email and we will send you a reset link',
          textAlign: TextAlign.center,
          style: theme.typography.sm.copyWith(color: theme.colors.mutedForeground),
        ),
        SizedBox(height: 32),
        FTextField(
          controller: _emailController,
          label: const Text('Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 24),
        FButton(
          onPress: _isLoading ? null : _requestReset,
          child: _isLoading
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Send Reset Link'),
        ),
        SizedBox(height: 16),
        FButton.text(
          onPress: () => widget.coordinator.pop(),
          child: Text('Back to login'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
```

---

#### [NEW] [reset_password_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/screens/auth/reset_password_screen.dart)

Reset password with token:

```dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../config/routes/app_routes.dart';
import '../../main.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Coordinator coordinator;
  final String token;
  const ResetPasswordScreen({super.key, required this.coordinator, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmController.text) {
      FToaster.of(context).add(
        FToast.error(title: const Text('Passwords do not match')),
      );
      return;
    }
    
    if (_passwordController.text.length < 8) {
      FToaster.of(context).add(
        FToast.error(title: const Text('Password must be at least 8 characters')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await client.passwordReset.resetPassword(
        widget.token,
        _passwordController.text,
      );
      
      if (mounted) {
        FToaster.of(context).add(
          FToast.success(title: const Text('Password reset successfully!')),
        );
        widget.coordinator.replace(LoginRoute());
      }
    } catch (e) {
      if (mounted) {
        FToaster.of(context).add(
          FToast.error(title: const Text('Invalid or expired token')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return FScaffold(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: FCard(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_open, size: 64, color: Color(0xFF00d9ff)),
                    SizedBox(height: 16),
                    Text(
                      'New Password',
                      style: theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 32),
                    FTextField(
                      controller: _passwordController,
                      label: const Text('New Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    FTextField(
                      controller: _confirmController,
                      label: const Text('Confirm Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    FButton(
                      onPress: _isLoading ? null : _resetPassword,
                      child: _isLoading
                          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('Reset Password'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}
```

---

#### [NEW] [workspace_list_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/screens/workspace/workspace_list_screen.dart)

Placeholder workspace list (expanded in Phase 2):

```dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../config/routes/app_routes.dart';
import '../../main.dart';

class WorkspaceListScreen extends StatelessWidget {
  final Coordinator coordinator;
  const WorkspaceListScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return FScaffold(
      header: FHeader(
        title: const Text('My Workspaces'),
        actions: [
          FButton.icon(
            onPress: () async {
              await client.auth.signOutDevice();
              coordinator.replace(LoginRoute());
            },
            child: const Icon(FIcons.logOut),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Welcome! Your workspaces will appear here.',
          style: theme.typography.base.copyWith(color: theme.colors.mutedForeground),
        ),
      ),
    );
  }
}
```

---

#### [MODIFY] [main.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/main.dart)

Update to use zenRouter and forui:

```dart
import 'package:kanew_client/kanew_client.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'config/routes/app_coordinator.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final config = await AppConfig.loadConfig();
  final serverUrl = serverUrlFromEnv.isEmpty
      ? config.apiUrl ?? 'http://$localhost:8080/'
      : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const KanewApp());
}

class KanewApp extends StatelessWidget {
  const KanewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.dark;
    
    return MaterialApp.router(
      title: 'Kanew',
      debugShowCheckedModeBanner: false,
      supportedLocales: FLocalizations.supportedLocales,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FAnimatedTheme(
        data: theme,
        child: FToaster(child: child!),
      ),
      routerDelegate: appCoordinator.routerDelegate,
      routeInformationParser: appCoordinator.routeInformationParser,
    );
  }
}
```

---

## Verification Plan

### Automated Tests

#### Build Check
```bash
cd kanew_flutter && flutter pub get && flutter analyze
```
**Expected:** No errors

### Manual Verification

1. **Start server:**
   ```bash
   cd kanew_server && dart run serverpod start
   ```

2. **Run Flutter app:**
   ```bash
   cd kanew_flutter && flutter run -d chrome
   ```

3. **Test flows:**
   - [ ] App redirects to `/auth/login` when not authenticated (RouteRedirect works)
   - [ ] Signup form creates account via SignInWidget
   - [ ] After signup, redirects to workspace list via `coordinator.replace(HomeRoute())`
   - [ ] Login form works for existing users
   - [ ] Forgot password shows success message with FToast
   - [ ] Logout button calls `client.auth.signOutDevice()` and redirects to login
   - [ ] forui dark theme with FCard, FButton, FTextField renders correctly
   - [ ] Deep linking works (navigate directly to `/auth/signup` in browser)
