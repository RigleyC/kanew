import 'package:flutter/material.dart';
import 'package:kanew_flutter/core/auth/auth_service.dart';
import 'package:zenrouter/zenrouter.dart';
import '../../../core/router/app_routes.dart';

/// Placeholder workspace list screen (expanded in Phase 2)
/// For now, this redirects to login if not authenticated
class WorkspaceListScreen extends StatelessWidget {
  final Coordinator coordinator;
  const WorkspaceListScreen({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workspaces'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.signOut();
              coordinator.replace(LoginRoute());
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Kanew!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your workspaces will appear here.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
