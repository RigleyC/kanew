import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/card_detail_controller.dart';

class CardActivitySection extends StatelessWidget {
  final CardDetailPageController controller;

  const CardActivitySection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activities = controller.activities;
    final comments = controller.comments;

    // Combine and sort (if needed, but they are separate lists in controller)
    // Actually, Trello mixes them. But for now let's show Comments then Activities, or mixed?
    // The controller fetches them separately.
    // Let's render a single list sorted by date.
    
    final mixedList = [
      ...activities.map((a) => _TimelineItem(activity: a)),
      ...comments.map((c) => _TimelineItem(comment: c)),
    ];
    
    mixedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.list),
            const SizedBox(width: 8),
            Text(
              'Atividade',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (mixedList.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Nenhuma atividade recente',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ...mixedList.map((item) {
          if (item.comment != null) {
            return _CommentItem(
              comment: item.comment!,
              onDelete: () => controller.deleteComment(item.comment!.id!),
            );
          } else {
            return _ActivityItem(activity: item.activity!);
          }
        }),
      ],
    );
  }
}

class _TimelineItem {
  final CardActivity? activity;
  final Comment? comment;
  
  _TimelineItem({this.activity, this.comment});
  
  DateTime get createdAt => activity?.createdAt ?? comment!.createdAt;
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onDelete;

  const _CommentItem({required this.comment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              'U', // TODO: User Initials
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Usuário', // TODO: Author Name
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        timeago.format(comment.createdAt, locale: 'pt_BR'),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.content),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onDelete,
                    child: Text(
                      'Excluir',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final CardActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final details = _getActivityDetails(activity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(_getActivityIcon(activity.type), size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: 'Usuário ', // TODO: Actor Name
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: details),
                  TextSpan(
                    text: ' · ${timeago.format(activity.createdAt, locale: 'pt_BR')}',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.create: return Icons.add_circle_outline;
      case ActivityType.update: return Icons.edit_outlined;
      case ActivityType.move: return Icons.arrow_forward;
      case ActivityType.delete: return Icons.delete_outline;
      case ActivityType.archive: return Icons.archive_outlined;
      case ActivityType.restore: return Icons.restore;
      case ActivityType.comment: return Icons.comment_outlined;
      case ActivityType.attachmentAdded: return Icons.attach_file;
      case ActivityType.attachmentDeleted: return Icons.delete_outline;
    }
  }

  String _getActivityDetails(CardActivity activity) {
    switch (activity.type) {
      case ActivityType.create: return 'criou este cartão';
      case ActivityType.update: return activity.details ?? 'atualizou este cartão';
      case ActivityType.move: return 'moveu este cartão';
      case ActivityType.delete: return 'excluiu este cartão';
      case ActivityType.archive: return 'arquivou este cartão';
      case ActivityType.restore: return 'restaurou este cartão';
      case ActivityType.comment: return 'comentou';
      case ActivityType.attachmentAdded: return activity.details ?? 'adicionou um anexo';
      case ActivityType.attachmentDeleted: return activity.details ?? 'removeu um anexo';
    }
  }
}
