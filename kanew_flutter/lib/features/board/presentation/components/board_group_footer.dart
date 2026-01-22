import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';

/// Group footer widget for AppFlowyBoard
///
/// Shows the "Add card" button at the bottom of each list.
class BoardGroupFooter extends StatelessWidget {
  final AppFlowyGroupData groupData;
  final VoidCallback onAddCard;

  const BoardGroupFooter({
    super.key,
    required this.groupData,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onAddCard,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Adicionar card',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
