import 'package:flutter/material.dart' hide Card;
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:intl/intl.dart';

/// Kanban Card Widget - represents a single card in the board
///
/// Displays card title, priority indicator, and due date.
class KanbanCard extends StatelessWidget {
  final Card card;
  final VoidCallback? onTap;
  // TODO: onComplete - standby for future use
  // final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const KanbanCard({
    super.key,
    required this.card,
    this.onTap,
    // this.onComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityColor = _getPriorityColor(card.priority, colorScheme);
    final isOverdue =
        card.dueDate != null && card.dueDate!.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Priority indicator bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(7),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          card.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),

                      // Menu button
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        padding: EdgeInsets.zero,
                        splashRadius: 16,
                        onSelected: (value) {
                          if (value == 'delete') {
                            onDelete?.call();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Excluir',
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Metadata row (due date, description indicator)
                  if (card.dueDate != null || card.descriptionDocument != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          // Due date
                          if (card.dueDate != null) ...[
                            Icon(
                              isOverdue
                                  ? Icons.warning_outlined
                                  : Icons.schedule,
                              size: 14,
                              color: isOverdue
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDueDate(card.dueDate!),
                              style: TextStyle(
                                fontSize: 12,
                                color: isOverdue
                                    ? colorScheme.error
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],

                          // Description indicator
                          if (card.descriptionDocument != null &&
                              card.descriptionDocument!.isNotEmpty) ...[
                            Icon(
                              FIcons.fileText,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(CardPriority priority, ColorScheme colorScheme) {
    switch (priority) {
      case CardPriority.none:
        return colorScheme.outlineVariant;
      case CardPriority.high:
        return colorScheme.error;
      case CardPriority.medium:
        return Colors.orange;
      case CardPriority.low:
        return colorScheme.primary;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoje';
    } else if (dateOnly == tomorrow) {
      return 'Amanhã';
    } else if (dateOnly.isBefore(today)) {
      final diff = today.difference(dateOnly).inDays;
      return '$diff dias atrás';
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }
}
