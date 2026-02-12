import 'package:flutter/material.dart';
import 'package:forui/widgets/toast.dart';

void showKanewSuccessToast(
  BuildContext context, {
  required String title,
  String? description,
}) {
  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.check_circle, color: Colors.green),
  );
}

void showKanewErrorToast(
  BuildContext context, {
  required String title,
  String? description,
}) {
  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.error, color: Colors.red),
  );
}

void showKanewInfoToast(
  BuildContext context, {
  required String title,
  String? description,
}) {
  showFToast(
    context: context,
    title: Text(title),
    description: description != null ? Text(description) : null,
    icon: const Icon(Icons.info, color: Colors.blue),
  );
}
