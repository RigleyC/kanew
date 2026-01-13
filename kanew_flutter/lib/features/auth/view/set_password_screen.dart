import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:zenrouter/zenrouter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Screen for setting name and password after email verification.
class SetPasswordScreen extends StatefulWidget {
  final Coordinator coordinator;
  final String email;
  final String registrationToken;

  const SetPasswordScreen({
    super.key,
    required this.coordinator,
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

  Future<void> _handleFinishSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu nome'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    final viewModel = context.read<AuthViewModel>();
    await viewModel.finishSignup(
      registrationToken: widget.registrationToken,
      name: name,
      password: password,
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthRegistrationComplete():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to home, replacing the entire auth stack
        widget.coordinator.replace(HomeRoute());
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
                            Icons.person_add_rounded,
                            size: 64,
                            color: AppTheme.accentColor,
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
                            'Defina seu nome e senha',
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

                          // Name field
                          FTextField(
                            control: FTextFieldControl.managed(
                              controller: _nameController,
                            ),
                            label: const Text('Nome Completo'),
                            hint: 'Digite seu nome',
                            enabled: !viewModel.isLoading,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),

                          // Password field
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

                          // Confirm password field
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

                          // Finish signup button
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
