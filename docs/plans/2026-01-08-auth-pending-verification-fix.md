# Auth Pending Verification Fix

> REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix auth flow to properly handle accounts with pending email verification - auto-redirect to verification screen and resend code when needed.

**Architecture:** Serverpod 3.x Email IDP returns new `accountRequestId` when `startRegistration()` is called for pending accounts. We'll leverage this by catching specific exceptions in `AuthViewModel` and exposing state to let screens redirect appropriately.

**Tech Stack:** Flutter 3.32, Serverpod 3.x Auth IDP, zenRouter

---

## Proposed Changes

### Bug Fix

---

#### [MODIFY] [auth_service.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/core/auth/auth_service.dart)

Remove duplicate code and fix syntax error. The file has duplicate class closure and duplicate `signOut` method.

---

### Auth Flow Improvements

---

#### [MODIFY] [auth_viewmodel.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/features/auth/viewmodel/auth_viewmodel.dart)

Add `resendVerificationCode()` method and expose pending verification state to allow screens to detect and handle this scenario.

---

#### [MODIFY] [login_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/features/auth/view/login_screen.dart)

When login fails with `invalidCredentials`, offer to resend verification code and redirect to verification screen.

---

#### [MODIFY] [signup_screen.dart](file:///c:/Users/Rigley/Documents/kanew/kanew_flutter/lib/features/auth/view/signup_screen.dart)

Remove unused password/userName fields (only email is needed for step 1). Handle the case where `startRegistration` succeeds for a pending account.

---

## Tasks

### Task 1: Fix auth_service.dart Syntax Error

**Files:**
- Fix: `kanew_flutter/lib/core/auth/auth_service.dart`

**Step 1: Replace the entire file with corrected version**

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';

/// Service to check authentication state
/// Works with FlutterAuthSessionManager's secure storage
class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'serverpod_auth_access_token';

  /// Check if user has a stored auth token
  static Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('AuthService: Error checking auth state: $e');
      return false;
    }
  }

  /// Sign out user properly using Serverpod Auth
  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      debugPrint('AuthService: Error signing out: $e');
    }
  }
}
```

**Step 2: Verify file compiles**

Run: `cd kanew_flutter && flutter analyze lib/core/auth/auth_service.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add kanew_flutter/lib/core/auth/auth_service.dart
git commit -m "fix: remove duplicate code in auth_service.dart"
```

---

### Task 2: Add Resend Verification to AuthViewModel

**Files:**
- Modify: `kanew_flutter/lib/features/auth/viewmodel/auth_viewmodel.dart`

**Step 1: Add resendVerificationCode method after startRegistration**

Add this method after line 91 (after `startRegistration`):

```dart
  /// Resend verification code for an existing pending registration.
  /// Calls startRegistration again which generates a new code.
  /// Returns the new accountRequestId.
  Future<UuidValue> resendVerificationCode({required String email}) async {
    _setLoading(true);
    _setError(null);

    try {
      // startRegistration generates new code even for pending accounts
      final accountRequestId = await client.emailIdp.startRegistration(
        email: email,
      );
      return accountRequestId;
    } catch (e) {
      _setError('Failed to resend verification code: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
```

**Step 2: Verify file compiles**

Run: `cd kanew_flutter && flutter analyze lib/features/auth/viewmodel/auth_viewmodel.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add kanew_flutter/lib/features/auth/viewmodel/auth_viewmodel.dart
git commit -m "feat: add resendVerificationCode method to AuthViewModel"
```

---

### Task 3: Update LoginScreen to Handle Pending Verification

**Files:**
- Modify: `kanew_flutter/lib/features/auth/view/login_screen.dart`

**Step 1: Update _showLoginFailedDialog to offer verification resend**

Replace the `_showLoginFailedDialog` method (lines 68-94) with:

```dart
  void _showLoginFailedDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login failed'),
        content: Text(
          '$errorMsg\n\n'
          'If you created an account but didn\'t complete email verification, '
          'you can resend the verification code.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try again'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _handleResendVerification();
            },
            child: const Text('Resend verification code'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResendVerification() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final accountRequestId = await _viewModel.resendVerificationCode(
        email: email,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent! Check your email (or server console)'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );

        widget.coordinator.push(
          VerificationRoute(
            email: email,
            accountRequestId: accountRequestId.toString(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This email is not registered. Please sign up first.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
```

**Step 2: Add import for VerificationRoute if missing**

Ensure this import exists at the top of the file (should already be there via `app_routes.dart`).

**Step 3: Verify file compiles**

Run: `cd kanew_flutter && flutter analyze lib/features/auth/view/login_screen.dart`
Expected: No errors

**Step 4: Commit**

```bash
git add kanew_flutter/lib/features/auth/view/login_screen.dart
git commit -m "feat: add resend verification option in login screen"
```

---

### Task 4: Simplify SignupScreen (Remove Unused Fields)

**Files:**
- Modify: `kanew_flutter/lib/features/auth/view/signup_screen.dart`

**Step 1: Remove password and userName controllers and fields**

The Serverpod Email IDP flow only needs email for step 1. Password is set in VerificationScreen after code verification.

Remove from state class:
- `_passwordController` declaration and disposal
- `_userNameController` declaration and disposal
- Password `FTextField` widget
- User Name `FTextField` widget

**Step 2: Update the file**

Replace the `_SignupScreenState` class with this simplified version:

```dart
class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleStartRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final accountRequestId = await _viewModel.startRegistration(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verification code sent! Check your email (or server console in dev)',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );

        widget.coordinator.push(
          VerificationRoute(
            email: _emailController.text.trim(),
            accountRequestId: accountRequestId.toString(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.error ?? 'Failed to start registration'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.authGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: FCard(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Icon(
                            Icons.dashboard_rounded,
                            size: 64,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Kanew',
                            style: context.theme.typography.xl2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your account',
                            style: context.theme.typography.sm.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 32),
                          FTextField(
                            label: const Text('Email'),
                            control: FTextFieldControl.managed(
                              controller: _emailController,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            hint: 'Enter your email',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You\'ll set your password after verifying your email',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FButton(
                              style: FButtonStyle.primary(),
                              onPress: _viewModel.isLoading
                                  ? null
                                  : _handleStartRegistration,
                              child: _viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Continue'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account?',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7),
                                    ),
                              ),
                              FButton(
                                style: FButtonStyle.ghost(),
                                onPress: () => widget.coordinator.pop(),
                                child: const Text('Log In'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

**Step 3: Verify file compiles**

Run: `cd kanew_flutter && flutter analyze lib/features/auth/view/signup_screen.dart`
Expected: No errors

**Step 4: Commit**

```bash
git add kanew_flutter/lib/features/auth/view/signup_screen.dart
git commit -m "refactor: simplify signup screen - only collect email in step 1"
```

---

### Task 5: Final Verification

**Step 1: Run full analysis**

Run: `cd kanew_flutter && flutter analyze`
Expected: No errors

**Step 2: Test manually**

1. Start server: `cd kanew_server && dart run serverpod start`
2. Run app: `cd kanew_flutter && flutter run -d chrome`
3. Test flows:
   - [ ] Create new account → Verify code → Set password → Redirects to Home
   - [ ] Don't complete verification → Try login → Click "Resend code" → Redirects to Verification
   - [ ] Close app → Reopen → Session persists (goes to Home, not Login)

**Step 3: Final commit**

```bash
git add -A
git commit -m "feat: complete auth pending verification handling"
```

---

## Verification Plan

### Automated Tests

```bash
cd kanew_flutter && flutter analyze
```
Expected: No errors

### Manual Verification

| Scenario | Expected Result |
|----------|-----------------|
| New signup → verify → password → home | ✅ Redirects to Home |
| Incomplete signup → login → resend | ✅ Shows resend option, sends code, redirects to Verification |
| Incomplete signup → signup again | ✅ Sends new code, redirects to Verification |
| Login → close app → reopen | ✅ Session persists, goes to Home |
