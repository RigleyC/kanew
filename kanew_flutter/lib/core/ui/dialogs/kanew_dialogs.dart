import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

Future<void> showKanewConfirmDialog({
  required BuildContext context,
  required String title,
  String? body,
  Widget? bodyWidget,
  String cancelText = 'Cancelar',
  String confirmText = 'Confirmar',
  bool destructive = false,
  VoidCallback? onCancel,
  required VoidCallback onConfirm,
}) async {
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
          style: destructive ? FButtonStyle.outline() : FButtonStyle.primary(),
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

Future<String?> showKanewTextPromptDialog({
  required BuildContext context,
  required String title,
  required String labelText,
  String? hintText,
  String cancelText = 'Cancelar',
  String confirmText = 'Confirmar',
  String initialValue = '',
}) async {
  final controller = TextEditingController(text: initialValue);
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  controller.dispose();
  return result?.trim();
}
