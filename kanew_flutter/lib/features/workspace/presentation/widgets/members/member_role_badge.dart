import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

/// Badge displaying member role with color coding
class MemberRoleBadge extends StatelessWidget {
  final MemberRole role;
  final bool compact;

  const MemberRoleBadge({
    super.key,
    required this.role,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label) = _getRoleStyle(context);

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

  /// Returns (color, label) for each role
  (Color, String) _getRoleStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (role) {
      case MemberRole.owner:
        return (colorScheme.primary, 'Proprietário');
      case MemberRole.admin:
        return (Colors.orange, 'Admin');
      case MemberRole.member:
        return (colorScheme.secondary, 'Membro');
      case MemberRole.guest:
        return (colorScheme.outline, 'Convidado');
    }
  }
}
