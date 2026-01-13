import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Coordinator coordinator;

  const ForgotPasswordScreen({
    super.key,
    required this.coordinator,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<AuthViewModel>();

    try {
      final requestId = await viewModel.startPasswordReset(email: email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código enviado! Verifique o console do servidor.'),
            backgroundColor: Colors.green,
          ),
        );

        widget.coordinator.push(
          ResetPasswordRoute(
            email: email,
            accountRequestId: requestId,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Erro ao enviar código'),
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
                            'Esqueceu a Senha',
                            style: typography.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Digite seu email para redefinir a senha',
                            style: typography.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                            textAlign: TextAlign.center,
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
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: FButton(
                              onPress: viewModel.isLoading
                                  ? null
                                  : _handleResetRequest,
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Enviar Código'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () => widget.coordinator.pop(),
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
