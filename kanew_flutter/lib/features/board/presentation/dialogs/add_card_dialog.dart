import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/core/ui/kanew_ui.dart';

/// Shows a dialog to add a new card
Future<void> showAddCardDialog(
  BuildContext context,
  UuidValue listId,
  Future<void> Function(UuidValue listId, String title) onAddCard,
) async {
  final result = await showKanewTextPromptDialog(
    context: context,
    title: 'Novo Card',
    labelText: 'Título do card',
    hintText: 'Ex: Implementar feature X',
    confirmText: 'Criar',
  );

  if (result != null && result.isNotEmpty) {
    await onAddCard(listId, result);
  }
}
