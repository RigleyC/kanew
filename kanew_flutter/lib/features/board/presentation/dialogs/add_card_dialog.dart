import 'package:flutter/material.dart';

/// Shows a dialog to add a new card
Future<void> showAddCardDialog(
  BuildContext context,
  int listId,
  Future<void> Function(int listId, String title) onAddCard,
) async {
  final textController = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Novo Card'),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Título do card',
          hintText: 'Ex: Implementar feature X',
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(textController.text),
          child: const Text('Criar'),
        ),
      ],
    ),
  );

  if (result != null && result.trim().isNotEmpty) {
    await onAddCard(listId, result);
  }
}
