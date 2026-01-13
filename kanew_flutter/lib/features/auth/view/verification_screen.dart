import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../../../core/auth/auth_service.dart' as app_auth;

/// Screen for entering email verification code.
/// After verification, navigates to SetPasswordScreen to complete signup.
class VerificationScreen extends StatefulWidget {
  final Coordinator coordinator;
  final String email;
  final String accountRequestId;

  const VerificationScreen({
    super.key,
    required this.coordinator,
    required this.email,
    required this.accountRequestId,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _accountRequestId;

  @override
  void initState() {
    super.initState();
    _accountRequestId = widget.accountRequestId;
  }

  @override
  void dispose() {
    _codeController.dispose();
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
    await viewModel.verifyCode(
      accountRequestId: _accountRequestId,
      code: _codeController.text.trim(),
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthCodeVerified():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código verificado!'),
            backgroundColor: Colors.green,
          ),
        );

        // Check if user is already authenticated (e.g. from login flow)
        final isAuthenticated = await app_auth.AuthService.isAuthenticated();
        if (isAuthenticated) {
          // Navigate to home directly
          widget.coordinator.replace(HomeRoute());
        } else {
          // Continue to set password (signup flow)
          widget.coordinator.push(
            SetPasswordRoute(
              email: widget.email,
              registrationToken: state.registrationToken,
            ),
          );
        }
        break;

      case AuthError():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
        break;

      default:
        break;
    }
  }

  Future<void> _handleResendCode() async {
    final viewModel = context.read<AuthViewModel>();
    await viewModel.resendCode(email: widget.email);

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthVerificationCodeSent():
        setState(() {
          _accountRequestId = state.accountRequestId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Novo código enviado!'),
            backgroundColor: Colors.green,
          ),
        );
        break;

      case AuthError():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ),
        );
        break;

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
                            Icons.verified_user_rounded,
                            size: 64,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Verificação',
                            style: typography.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Digite o código enviado para:',
                            style: typography.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
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

                          // Code field
                          FTextField(
                            control: FTextFieldControl.managed(
                              controller: _codeController,
                            ),
                            label: const Text('Código de Verificação'),
                            hint: 'Digite o código do console do servidor',
                            enabled: !viewModel.isLoading,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 24),

                          // Verify button
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
                          const SizedBox(height: 16),

                          // Resend code button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Não recebeu?',
                                style: typography.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                              FButton(
                                style: FButtonStyle.ghost(),
                                onPress: viewModel.isLoading
                                    ? null
                                    : _handleResendCode,
                                child: const Text('Reenviar código'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Back button
                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () => widget.coordinator.pop(),
                            child: const Text('Voltar'),
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
