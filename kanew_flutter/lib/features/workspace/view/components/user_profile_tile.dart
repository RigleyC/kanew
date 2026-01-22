import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../core/widgets/sidebar/sidebar.dart';

/// User profile tile showing email and avatar with logout option
class UserProfileTile extends StatelessWidget {
  final VoidCallback onLogout;
  final String? email;

  const UserProfileTile({
    super.key,
    required this.onLogout,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final displayEmail = email ?? 'Usuário';
    final colorScheme = Theme.of(context).colorScheme;
    final isCollapsed = SidebarData.isCollapsedOf(context);

    return FPopoverMenu.tiles(
      menuAnchor: Alignment.topLeft,
      childAnchor: Alignment.bottomLeft,
      offset: const Offset(0, -8),
      menu: [
        FTileGroup(
          children: [
            FTile(
              prefix: Icon(
                FIcons.logOut,
                color: colorScheme.error,
                size: 18,
              ),
              title: Text(
                'Sair',
                style: TextStyle(color: colorScheme.error),
              ),
              onPress: onLogout,
            ),
          ],
        ),
      ],
      builder: (context, controller, child) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.toggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isCollapsed
                ? _buildCollapsedContent(displayEmail, colorScheme)
                : _buildExpandedContent(displayEmail, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent(String displayEmail, ColorScheme colorScheme) {
    return Tooltip(
      message: displayEmail,
      child: _UserAvatar(
        email: displayEmail,
        colorScheme: colorScheme,
        size: 36,
      ),
    );
  }

  Widget _buildExpandedContent(String displayEmail, ColorScheme colorScheme) {
    return Row(
      children: [
        // Avatar
        _UserAvatar(
          email: displayEmail,
          colorScheme: colorScheme,
          size: 36,
        ),
        const SizedBox(width: 12),

        // Email
        Expanded(
          child: Text(
            displayEmail,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Chevron icon
        Icon(
          FIcons.chevronsUpDown,
          size: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String email;
  final ColorScheme colorScheme;
  final double size;

  const _UserAvatar({
    required this.email,
    required this.colorScheme,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          _getInitials(email),
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }

  String _getInitials(String email) {
    if (email.contains('@')) {
      final name = email.split('@')[0];
      return name.isNotEmpty ? name[0].toUpperCase() : '?';
    }
    return email.isNotEmpty ? email[0].toUpperCase() : '?';
  }
}
