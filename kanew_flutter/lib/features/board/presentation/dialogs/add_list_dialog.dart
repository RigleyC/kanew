import 'package:flutter/material.dart';

/// Shows a dialog to add a new list
Future<void> showAddListDialog(
  BuildContext context,
  Future<void> Function(String title) onCreateList,
) async {
  final textController = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Nova Lista'),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nome da lista',
          hintText: 'Ex: A Fazer, Em Progresso...',
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
    await onCreateList(result.trim());
  }
}
