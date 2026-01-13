import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  final Coordinator coordinator;

  const SignupScreen({super.key, required this.coordinator});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleStartRegistration() async {
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
    await viewModel.startSignup(email: email);

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthVerificationCodeSent():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Código de verificação enviado! Verifique o console do servidor.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        widget.coordinator.push(
          VerificationRoute(
            email: email,
            accountRequestId: state.accountRequestId,
          ),
        );
        break;

      case AuthEmailNotVerified():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta pendente. Código reenviado!'),
            backgroundColor: Colors.orange,
          ),
        );
        widget.coordinator.push(
          VerificationRoute(
            email: email,
            accountRequestId: state.accountRequestId ?? '',
          ),
        );
        break;

      case AuthError():
        if (state.status == AuthStatus.accountAlreadyExists) {
          _showAccountExistsDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;

      default:
        break;
    }
  }

  void _showAccountExistsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conta já existe'),
        content: Text(
          'O email "${_emailController.text.trim()}" já está cadastrado. '
          'Deseja fazer login ou verificar o cadastro pendente?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.coordinator.replace(
                LoginRoute(email: _emailController.text.trim()),
              );
            },
            child: const Text('Fazer login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Try to resend code to see if it's a pending account
              context.read<AuthViewModel>().resendCode(
                email: _emailController.text.trim(),
              );
            },
            child: const Text('Verificar cadastro'),
          ),
        ],
      ),
    );
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
                    child: Consumer<AuthViewModel>(
                      builder: (context, viewModel, _) => Column(
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
                            'Crie sua conta',
                            style: context.theme.typography.sm.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Email field
                          FTextField(
                            label: const Text('Email'),
                            control: FTextFieldControl.managed(
                              controller: _emailController,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            hint: 'Digite seu email',
                            enabled: !viewModel.isLoading,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Você definirá sua senha após verificar o email',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                          ),
                          const SizedBox(height: 24),

                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            child: FButton(
                              style: FButtonStyle.primary(),
                              onPress: viewModel.isLoading
                                  ? null
                                  : _handleStartRegistration,
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Continuar'),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Já tem uma conta?',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                              ),
                              FButton(
                                style: FButtonStyle.ghost(),
                                onPress: () => widget.coordinator.pop(),
                                child: const Text('Entrar'),
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
