import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// Obtém o context do router global.
BuildContext? get _context => rootNavigatorKey.currentContext;

/// Helper para navegação simples via GoRouter usando contexto global
void routerGo(String location, {Object? extra}) {
  _context?.go(location, extra: extra);
}

void routerPush(String location, {Object? extra}) {
  _context?.push(location, extra: extra);
}

void routerPop() {
  if (_context != null && _context!.canPop()) {
    _context!.pop();
  }
}

// ============================================================
// DIALOGS
// ============================================================

/// Mostra um dialog customizado.
Future<T?> showCustomDialog<T>({
  required Widget dialog,
  bool barrierDismissible = true,
}) {
  final context = _context;
  if (context == null) return Future.value(null);

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => dialog,
  );
}

/// Mostra um dialog de confirmação com Forui.
Future<void> showConfirmDialog({
  required String title,
  String? body,
  Widget? bodyWidget,
  String cancelText = 'Cancelar',
  String confirmText = 'Confirmar',
  VoidCallback? onCancel,
  required VoidCallback onConfirm,
}) async {
  final context = _context;
  if (context == null) return;

  await showFDialog(
    context: context,
    builder: (context, style, animation) => FDialog(
      animation: animation,
      direction: Axis.horizontal,
      title: Text(title),
      body:
          bodyWidget ??
          (body != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(body),
                )
              : null),
      actions: [
        FButton(
          style: FButtonStyle.outline(),
          onPress: () {
            context.pop();
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        FButton(
          onPress: () {
            context.pop();
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

/// Mostra um dialog de informação com botão único.
Future<void> showInfoDialog({
  required String title,
  String? body,
  String buttonText = 'OK',
  VoidCallback? onDismiss,
}) async {
  final context = _context;
  if (context == null) return;

  await showFDialog(
    context: context,
    builder: (context, style, animation) => FDialog(
      animation: animation,
      direction: Axis.horizontal,
      title: Text(title),
      body: body != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(body),
            )
          : null,
      actions: [
        FButton(
          onPress: () {
            context.pop();
            onDismiss?.call();
          },
          child: Text(buttonText),
        ),
      ],
    ),
  );
}

// ============================================================
// TOASTS
// ============================================================

/// Mostra um toast de sucesso.
void showSuccessToast({required String title, String? description}) {
  final context = _context;
  if (context == null) return;

  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.check_circle, color: Colors.green),
  );
}

/// Mostra um toast de erro.
void showErrorToast({required String title, String? description}) {
  final context = _context;
  if (context == null) return;

  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.error, color: Colors.red),
  );
}

/// Mostra um toast de informação.
void showInfoToast({required String title, String? description}) {
  final context = _context;
  if (context == null) return;

  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.info, color: Colors.blue),
  );
}

/// Mostra um toast de aviso.
void showWarningToast({required String title, String? description}) {
  final context = _context;
  if (context == null) return;

  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.warning, color: Colors.amber),
  );
}
