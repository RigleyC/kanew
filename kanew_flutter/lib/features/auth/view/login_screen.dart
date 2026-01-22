import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../viewmodel/auth_controller.dart';

/// Screen for user authentication.
///
/// Provides login form with email and password fields.
/// Handles login state changes and navigates accordingly.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles login form submission.
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final viewModel = getIt<AuthController>();

    await viewModel.login(email: email, password: password);

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthAuthenticated():
        developer.log(
          'Login successful, navigating to home',
          name: 'login_screen',
        );
        if (mounted) {
          context.go('/');
        }

      case AuthAccountNotFoundError():
        developer.log(
          'Account not found: $email',
          name: 'login_screen',
        );
        _showAccountNotFoundDialog(email);

      case AuthEmailNotVerifiedError():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email não verificado. Código enviado!'),
            backgroundColor: Colors.orange,
          ),
        );
        developer.log(
          'Email not verified, navigating to verification',
          name: 'login_screen',
        );
        if (mounted && state.accountRequestId != null) {
          context.go(
            '/auth/verification',
            extra: {
              'email': email,
              'accountRequestId': state.accountRequestId.toString(),
            },
          );
        }

      case AuthError():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
        developer.log(
          'Login failed',
          name: 'login_screen',
          level: 1000,
          error: state.message,
        );

      default:
        break;
    }
  }

  /// Shows dialog for account not found.
  void _showAccountNotFoundDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conta não encontrada'),
        content: Text(
          'Não existe uma conta com o email "$email".\n\n'
          'Deseja criar uma conta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/auth/signup');
            },
            child: const Text('Criar conta'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: colorScheme.surface),
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
                      listenable: getIt<AuthController>(),
                      builder: (context, _) {
                        final viewModel = getIt<AuthController>();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.dashboard_rounded,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Kanew',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bem-vindo de volta!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 32),

                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _emailController,
                              ),
                              label: const Text('Email'),
                              hint: 'Digite seu email',
                              keyboardType: TextInputType.emailAddress,
                              enabled: !viewModel.isLoading,
                            ),
                            const SizedBox(height: 16),

                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _passwordController,
                              ),
                              label: const Text('Senha'),
                              hint: 'Digite sua senha',
                              obscureText: true,
                              enabled: !viewModel.isLoading,
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: FButton(
                                onPress: viewModel.isLoading
                                    ? null
                                    : _handleLogin,
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Entrar'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            FButton(
                              style: FButtonStyle.ghost(),
                              onPress: () => context.go('/auth/signup'),
                              child: const Text('Criar uma conta'),
                            ),
                            const SizedBox(height: 8),

                            FButton(
                              style: FButtonStyle.ghost(),
                              onPress: () => context.go('/auth/forgot-password'),
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
