import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

class MemberStatusBadge extends StatelessWidget {
  final MemberStatus status;
  final bool compact;

  const MemberStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _getStatusStyle(context);

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: compact ? 2 : 4,
        children: [
          Icon(
            icon,
            size: compact ? 10 : 12,
            color: color,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData, String) _getStatusStyle(BuildContext context) {
    switch (status) {
      case MemberStatus.active:
        return (Colors.green, Icons.check_circle, 'Ativo');
      case MemberStatus.invited:
        return (Colors.blue, Icons.mail_outline, 'Convidado');
      case MemberStatus.suspended:
        return (Colors.red, Icons.block, 'Suspenso');
    }
  }
}
