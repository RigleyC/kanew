import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../viewmodel/auth_controller.dart';

/// Screen for setting name and password after email verification.
///
/// Completes the signup flow by setting user credentials.
/// On success, navigates to home screen.
class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String registrationToken;

  const SetPasswordScreen({
    super.key,
    required this.email,
    required this.registrationToken,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates password and completes signup.
  Future<void> _handleFinishSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 8 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = getIt<AuthController>();
    await viewModel.finishRegistration(
      registrationToken: widget.registrationToken,
      password: password,
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthAuthenticated():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        developer.log(
          'Signup completed, navigating to home',
          name: 'set_password_screen',
        );
        if (mounted) {
          context.go('/');
        }

      case AuthError():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
        developer.log(
          'Failed to complete signup',
          name: 'set_password_screen',
          level: 1000,
          error: state.message,
        );

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typography = theme.textTheme;

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
                              Icons.person_add_rounded,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Finalize seu Cadastro',
                              style: typography.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Defina sua senha',
                              style: typography.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.email,
                              style: typography.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _passwordController,
                              ),
                              label: const Text('Senha'),
                              hint: 'Mínimo 8 caracteres',
                              obscureText: true,
                              enabled: !viewModel.isLoading,
                            ),
                            const SizedBox(height: 16),

                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _confirmPasswordController,
                              ),
                              label: const Text('Confirmar Senha'),
                              hint: 'Digite a senha novamente',
                              obscureText: true,
                              enabled: !viewModel.isLoading,
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: FButton(
                                onPress: viewModel.isLoading
                                    ? null
                                    : _handleFinishSignup,
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Criar Conta'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            FButton(
                              style: FButtonStyle.ghost(),
                              onPress: () => context.pop(),
                              child: const Text('Voltar'),
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
