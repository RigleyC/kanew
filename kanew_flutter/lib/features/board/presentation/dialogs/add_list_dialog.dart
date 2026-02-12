import 'package:flutter/material.dart';
import 'package:kanew_flutter/core/ui/kanew_ui.dart';

/// Shows a dialog to add a new list
Future<void> showAddListDialog(
  BuildContext context,
  Future<void> Function(String title) onCreateList,
) async {
  final result = await showKanewTextPromptDialog(
    context: context,
    title: 'Nova Lista',
    labelText: 'Nome da lista',
    hintText: 'Ex: A Fazer, Em Progresso...',
    confirmText: 'Criar',
  );

  if (result != null && result.isNotEmpty) {
    await onCreateList(result);
  }
}
