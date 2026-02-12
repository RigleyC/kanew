import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/di/injection.dart';
import '../../../core/ui/kanew_ui.dart';
import '../viewmodel/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String accountRequestId;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.accountRequestId,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _resetToken;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Verify reset code.
  Future<void> _handleVerifyCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final viewModel = getIt<AuthController>();
    await viewModel.verifyPasswordResetCode(
      requestId: UuidValue.fromString(widget.accountRequestId),
      code: code,
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthPasswordResetVerified():
        setState(() {
          _resetToken = state.token;
        });
        showKanewSuccessToast(context, title: 'Código verificado!');
        developer.log(
          'Password reset code verified',
          name: 'reset_password_screen',
        );

      case AuthError():
        showKanewErrorToast(
          context,
          title: 'Falha ao verificar código',
          description: state.message,
        );
        developer.log(
          'Password reset code verification failed',
          name: 'reset_password_screen',
          level: 1000,
          error: state.message,
        );

      default:
        break;
    }
  }

  /// Reset password.
  Future<void> _handleResetPassword() async {
    if (_resetToken == null) return;

    final password = _passwordController.text;
    if (password.length < 8) {
      showKanewErrorToast(
        context,
        title: 'A senha deve ter pelo menos 8 caracteres',
      );
      return;
    }

    final viewModel = getIt<AuthController>();
    await viewModel.finishPasswordReset(
      token: _resetToken!,
      newPassword: password,
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthInitial():
        showKanewSuccessToast(
          context,
          title: 'Senha redefinida com sucesso!',
        );
        developer.log(
          'Password reset completed, navigating to login',
          name: 'reset_password_screen',
        );
        if (mounted) {
          context.go('/auth/login');
        }

      case AuthError():
        showKanewErrorToast(
          context,
          title: 'Falha ao redefinir senha',
          description: state.message,
        );
        developer.log(
          'Password reset failed',
          name: 'reset_password_screen',
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
    final typography = theme.textTheme;

    return Scaffold(
      body: Center(
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
                            Icons.lock_reset_rounded,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Redefinir Senha',
                            style: typography.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _resetToken == null
                                ? 'Verifique o código do email'
                                : 'Defina sua nova senha',
                            style: typography.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'Redefinindo para:\n${widget.email}',
                            textAlign: TextAlign.center,
                            style: typography.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          // Code field
                          FTextField(
                            control: FTextFieldControl.managed(
                              controller: _codeController,
                            ),
                            label: const Text('Código de Verificação'),
                            hint: 'Digite o código do email',
                            enabled:
                                _resetToken == null && !viewModel.isLoading,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),

                          if (_resetToken == null)
                            SizedBox(
                              width: double.infinity,
                              child: FButton(
                                onPress: viewModel.isLoading
                                    ? null
                                    : _handleVerifyCode,
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Verificar Código'),
                              ),
                            ),

                          if (_resetToken != null) ...[
                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _passwordController,
                              ),
                              label: const Text('Nova Senha'),
                              hint: 'Mínimo 8 caracteres',
                              obscureText: true,
                              enabled: !viewModel.isLoading,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: FButton(
                                onPress: viewModel.isLoading
                                    ? null
                                    : _handleResetPassword,
                                child: viewModel.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Definir Nova Senha'),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () => context.go('/auth/login'),
                            child: const Text('Voltar ao Login'),
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
    );
  }
}
