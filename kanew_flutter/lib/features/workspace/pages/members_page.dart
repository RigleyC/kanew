import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../core/widgets/sidebar/sidebar.dart';
import '../../../core/widgets/base/button.dart';

/// Members page - gerenciamento de membros do workspace
class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = SidebarProvider.maybeOf(context);
    final isMobile = provider?.isMobile ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SidebarTrigger(),
                ),
              Text(
                'Membros',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              KanbnButton(
                label: 'Convidar',
                variant: ButtonVariant.primary,
                iconLeft: const Icon(FIcons.userPlus),
                onPressed: () {
                  // TODO: Invite member
                },
              ),
            ],
          ),
        ),
        // Content
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Página de membros em desenvolvimento',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
