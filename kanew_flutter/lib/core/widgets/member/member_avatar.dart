import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String email;
  final double size;
  final String? imageUrl;

  const MemberAvatar({
    super.key,
    required this.email,
    this.size = 40,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    }

    final initials = _getInitialsFromEmail(email);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size / 2.5,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  String _getInitialsFromEmail(String email) {
    final parts = email.split('@');
    if (parts.isEmpty) return '??';

    final username = parts[0];
    if (username.isEmpty) return '??';

    return username.substring(0, username.length > 1 ? 2 : 1).toUpperCase();
  }
}
