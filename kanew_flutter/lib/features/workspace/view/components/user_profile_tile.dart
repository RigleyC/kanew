import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../core/widgets/sidebar/sidebar.dart';

/// User profile tile showing email and avatar with logout option
class UserProfileTile extends StatelessWidget {
  final VoidCallback onLogout;
  final String email;

  const UserProfileTile({
    super.key,
    required this.onLogout,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final isCollapsed = SidebarData.isCollapsedOf(context);

    return FPopoverMenu.tiles(
      menuAnchor: Alignment.topLeft,
      childAnchor: Alignment.bottomLeft,
      offset: const Offset(0, -8),
      menu: [
        FTileGroup(
          children: [
            FTile(
              prefix: const Icon(Icons.logout),
              title: const Text('Sair'),
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
                ? _buildCollapsedContent(email)
                : _buildExpandedContent(email),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent(String displayEmail) {
    return FAvatar.raw(
      size: 32,
      child: Text(displayEmail),
    );
  }

  Widget _buildExpandedContent(String displayEmail) {
    return FTile(
      title: Text(displayEmail),
    );
  }
}

String _getInitials(String email) {
  if (email.contains('@')) {
    final name = email.split('@')[0];
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
  return email.isNotEmpty ? email[0].toUpperCase() : '?';
}
