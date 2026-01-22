import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../viewmodel/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

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

  /// Request reset - ViewModel cuida de toasts e navegação.
  Future<void> _handleResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    await getIt<AuthController>().startPasswordReset(email: email);
    // ViewModel cuida do resto
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
                            Icon(Icons.lock_reset_rounded, size: 64),
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
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
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
                              onPress: () => context.pop(), // Voltar ao login
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
