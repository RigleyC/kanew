import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  final Coordinator coordinator;
  final String? email;

  const LoginScreen({
    super.key,
    required this.coordinator,
    this.email,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final viewModel = context.read<AuthViewModel>();

    await viewModel.login(email: email, password: password);

    if (!mounted) return;

    // Handle state changes
    final state = viewModel.state;

    switch (state) {
      case AuthLoginSuccess():
        // Wait for session to be registered securely
        int retries = 0;
        while (!await AuthService.isAuthenticated() && retries < 5) {
          await Future.delayed(const Duration(milliseconds: 100));
          retries++;
        }

        if (await AuthService.isAuthenticated()) {
          widget.coordinator.replace(HomeRoute());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha ao registrar sessão. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;

      case AuthAccountNotFound():
        // Show message and offer to sign up
        _showAccountNotFoundDialog(email);
        break;

      case AuthEmailNotVerified():
        // Navigate to verification screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email não verificado. Código enviado!'),
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
              widget.coordinator.push(SignupRoute());
            },
            child: const Text('Criar conta'),
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
                            'Bem-vindo de volta!',
                            style: context.theme.typography.sm.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Email field
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

                          // Password field
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

                          // Login button
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

                          // Sign up link
                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () =>
                                widget.coordinator.push(SignupRoute()),
                            child: const Text('Criar uma conta'),
                          ),
                          const SizedBox(height: 8),

                          // Forgot password link
                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () =>
                                widget.coordinator.push(ForgotPasswordRoute()),
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
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
        ),
      ),
    );
  }
}
