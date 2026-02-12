import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/ui/kanew_ui.dart';
import '../../../core/router/auth_route_helper.dart';
import '../viewmodel/auth_controller.dart';

/// Screen for starting the signup process.
///
/// Collects user's email and initiates verification.
/// On success, navigates to verification screen.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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

  /// Starts the signup process.
  Future<void> _handleStartRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showKanewErrorToast(context, title: 'Por favor, digite seu email');
      return;
    }

    final viewModel = getIt<AuthController>();
    await viewModel.startRegistration(email: email);

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthNeedsVerification():
        showKanewSuccessToast(
          context,
          title: 'Código de verificação enviado',
          description: 'Verifique o console do servidor.',
        );
        developer.log(
          'Verification code sent - email: $email, requestId: ${state.accountRequestId}',
          name: 'signup_screen',
        );
    if (mounted) {
      final redirect = AuthRouteHelper.getRedirect(GoRouterState.of(context));
      context.go(
        AuthRouteHelper.verification(
          email: email,
          accountRequestId: (viewModel.state as AuthNeedsVerification)
              .accountRequestId
              .toString(),
          redirect: redirect,
        ),
      );
    }

      case AuthAccountExistsError():
        showKanewInfoToast(
          context,
          title: state.message,
        );
        developer.log(
          'Account already exists',
          name: 'signup_screen',
        );

      case AuthError():
        showKanewErrorToast(
          context,
          title: 'Erro no cadastro',
          description: state.message,
        );
        developer.log(
          'Signup failed',
          name: 'signup_screen',
          level: 1000,
          error: state.message,
        );

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                              Icons.dashboard_rounded,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Kanew',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Crie sua conta',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 32),

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
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 24),

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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Já tem uma conta?',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                ),
                                FButton(
                                  style: FButtonStyle.ghost(),
                                  onPress: () {
                                    final state = GoRouterState.of(context);
                                    final redirect =
                                        state.uri.queryParameters['redirect'];
                                    context.go(
                                      AuthRouteHelper.login(redirect: redirect),
                                    );
                                  },
                                  child: const Text('Entrar'),
                                ),
                              ],
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
