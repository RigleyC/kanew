import 'package:flutter/material.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:kanew_flutter/core/widgets/checklist_progress_badge.dart';
import 'package:kanew_flutter/features/board/presentation/components/label_chip.dart';
import 'package:kanew_flutter/features/board/presentation/components/priority_chip.dart';

class KanbanCard extends StatelessWidget {
  final CardSummary cardSummary;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const KanbanCard({
    super.key,
    required this.cardSummary,
    this.onTap,
    this.onDelete,
  });

  Card get card => cardSummary.card;
  CardPriority get priority => cardSummary.card.priority;
  List<LabelDef> get labels => cardSummary.cardLabels;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Row(
              mainAxisAlignment: priority != CardPriority.none
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (priority != CardPriority.none)
                  PriorityChip(priority: priority),
                if (cardSummary.checklistTotal > 0)
                  ChecklistProgressBadge(
                    completedCount: cardSummary.checklistCompleted,
                    totalCount: cardSummary.checklistTotal,
                  ),
              ],
            ),
            Text(
              card.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            if (card.descriptionDocument != null)
              Text(
                card.descriptionDocument!,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            if (labels.isNotEmpty) ...[
              Wrap(
                spacing: 4,
                runSpacing: 2,
                children: labels
                    .map(
                      (label) => LabelChip(
                        name: label.name,
                        colorHex: label.colorHex,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 4),
            ],
            if (card.dueDate != null)
              Text(DateFormat('dd MMM ', 'pt-br').format(card.dueDate!)),
            // Badges for counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    if (cardSummary.attachmentCount > 0)
                      _Badge(
                        Icons.attach_file,
                        cardSummary.attachmentCount.toString(),
                      ),
                    if (cardSummary.commentCount > 0)
                      _Badge(
                        Icons.comment,
                        cardSummary.commentCount.toString(),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 14),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
