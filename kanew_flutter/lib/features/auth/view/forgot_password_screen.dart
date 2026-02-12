import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/auth_route_helper.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/states/auth_state.dart';

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

  Future<void> _handleResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final authController = getIt<AuthController>();
    await authController.startPasswordReset(email: email);

    if (!mounted) return;

    final state = authController.state;
    if (state is AuthPasswordResetCodeSent) {
      context.go(
        AuthRouteHelper.resetPassword(
          email: state.email,
          requestId: state.requestId.toString(),
        ),
      );
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
                  child: ValueListenableBuilder<AuthState>(
                    valueListenable: getIt<AuthController>().store,
                    builder: (context, _, __) {
                      final viewModel = getIt<AuthController>();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_reset_rounded, size: 64),
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
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                              onPress: viewModel.isLoading ? null : _handleResetRequest,
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Enviar Codigo'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FButton(
                            style: FButtonStyle.ghost(),
                            onPress: () => context.pop(),
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

