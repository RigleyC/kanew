import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

/// Badge displaying member status with color coding
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
    final (color, label) = _getStatusStyle(context);

    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// Returns (color, label) for each status
  (Color, String) _getStatusStyle(BuildContext context) {
    switch (status) {
      case MemberStatus.active:
        return (Colors.green, 'Ativo');
      case MemberStatus.invited:
        return (Colors.blue, 'Convidado');
      case MemberStatus.suspended:
        return (Colors.red, 'Suspenso');
    }
  }
}
