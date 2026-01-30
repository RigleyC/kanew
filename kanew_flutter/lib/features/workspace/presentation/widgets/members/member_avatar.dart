import 'package:flutter/material.dart';

/// Circular avatar displaying user initials from email
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
    // If image URL is provided, show network image
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      );
    }

    // Extract initials from email (first 2 characters before @)
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

  /// Extracts initials from email (first 2 chars before @)
  String _getInitialsFromEmail(String email) {
    final parts = email.split('@');
    if (parts.isEmpty) return '??';

    final username = parts[0];
    if (username.isEmpty) return '??';

    // Return first 2 characters uppercase
    return username.substring(0, username.length > 1 ? 2 : 1).toUpperCase();
  }
}
