import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  final Coordinator coordinator;
  final String email;
  final String accountRequestId;

  const ResetPasswordScreen({
    super.key,
    required this.coordinator,
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

  Future<void> _handleVerifyCode() async {
    if (_codeController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O código deve ter pelo menos 6 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<AuthViewModel>();

    try {
      final token = await viewModel.verifyPasswordResetCode(
        passwordResetRequestId: widget.accountRequestId,
        verificationCode: _codeController.text.trim(),
      );

      setState(() {
        _resetToken = token;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código verificado! Defina sua nova senha.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Código inválido'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 8 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<AuthViewModel>();

    try {
      if (_resetToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, verifique o código primeiro'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await viewModel.finishPasswordReset(
        finishPasswordResetToken: _resetToken!,
        newPassword: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha redefinida com sucesso! Faça login.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.coordinator.replace(LoginRoute());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Erro ao redefinir senha'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typography = theme.textTheme;

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
                    child: Consumer<AuthViewModel>(
                      builder: (context, viewModel, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_reset_rounded,
                            size: 64,
                            color: AppTheme.accentColor,
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
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'Redefinindo para:\n${widget.email}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                            ),
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
                            onPress: () =>
                                widget.coordinator.replace(LoginRoute()),
                            child: const Text('Voltar ao Login'),
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
