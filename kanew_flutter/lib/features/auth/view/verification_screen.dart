import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/auth_route_helper.dart';
import '../../../core/ui/kanew_ui.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/states/auth_state.dart';

/// Screen for entering email verification code.
///
/// After successful verification, navigates to [SetPasswordScreen] to complete signup.
class VerificationScreen extends StatefulWidget {
  final String email;
  final String accountRequestId;
  final String? redirect;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.accountRequestId,
    this.redirect,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UuidValue _accountRequestId;

  @override
  void initState() {
    super.initState();
    _accountRequestId = UuidValue.fromString(widget.accountRequestId);
    developer.log(
      'Verification screen initialized - email: ${widget.email}',
      name: 'verification_screen',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// Handles verification code submission.
  Future<void> _handleVerifyCode() async {
    if (_codeController.text.length < 6) {
      showKanewErrorToast(
        context,
        title: 'O c?digo deve ter pelo menos 6 caracteres',
      );
      return;
    }

    final viewModel = getIt<AuthController>();
    await viewModel.verifyRegistrationCode(
      accountRequestId: _accountRequestId,
      code: _codeController.text.trim(),
    );

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthCodeVerified():
        showKanewSuccessToast(context, title: 'C?digo verificado!');
        developer.log(
          'Code verified, navigating to set password',
          name: 'verification_screen',
        );
        if (mounted) {
          context.go(
            AuthRouteHelper.setPassword(
              email: widget.email,
              token: state.registrationToken,
              redirect: widget.redirect,
            ),
          );
        }

      case AuthError():
        showKanewErrorToast(
          context,
          title: 'Falha na verifica??o',
          description: state.message,
        );
        developer.log(
          'Verification failed',
          name: 'verification_screen',
          level: 1000,
          error: state.message,
        );

      default:
        break;
    }
  }

  /// Handles resend verification code request.
  Future<void> _handleResendCode() async {
    final viewModel = getIt<AuthController>();
    await viewModel.resendVerificationCode(email: widget.email);

    if (!mounted) return;

    final state = viewModel.state;

    switch (state) {
      case AuthNeedsVerification():
        setState(() {
          _accountRequestId = state.accountRequestId;
        });
        showKanewSuccessToast(context, title: 'Novo c?digo enviado!');
        developer.log(
          'Verification code resent - newRequestId: ${state.accountRequestId}',
          name: 'verification_screen',
        );

      case AuthError():
        showKanewErrorToast(
          context,
          title: 'Falha ao reenviar c?digo',
          description: state.message,
        );
        developer.log(
          'Failed to resend code',
          name: 'verification_screen',
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
    final colorScheme = theme.colorScheme;
    final typography = theme.textTheme;

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
                    child: ValueListenableBuilder<AuthState>(
                      valueListenable: getIt<AuthController>().store,
                      builder: (context, _, __) {
                        final viewModel = getIt<AuthController>();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              size: 64,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Verifica??o',
                              style: typography.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Digite o c?digo enviado para:',
                              style: typography.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
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

                            FTextField(
                              control: FTextFieldControl.managed(
                                controller: _codeController,
                              ),
                              label: const Text('C?digo de Verifica??o'),
                              hint: 'Digite o c?digo do console do servidor',
                              enabled: !viewModel.isLoading,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 24),

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
                                    : const Text('Verificar C?digo'),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'N?o recebeu?',
                                  style: typography.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                FButton(
                                  style: FButtonStyle.ghost(),
                                  onPress: viewModel.isLoading
                                      ? null
                                      : _handleResendCode,
                                  child: const Text('Reenviar c?digo'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            FButton(
                              style: FButtonStyle.ghost(),
                              onPress: () => context.pop(),
                              child: const Text('Voltar'),
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


