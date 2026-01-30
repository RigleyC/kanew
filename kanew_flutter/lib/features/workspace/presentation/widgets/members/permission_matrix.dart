import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

/// Grid of checkboxes for managing CRUD permissions
/// Displays permissions grouped by resource (Workspace, Board, Card)
class PermissionMatrix extends StatefulWidget {
  final List<PermissionInfo> permissions;
  final ValueChanged<List<int>> onChanged;
  final bool readOnly;

  const PermissionMatrix({
    super.key,
    required this.permissions,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  State<PermissionMatrix> createState() => _PermissionMatrixState();
}

class _PermissionMatrixState extends State<PermissionMatrix> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.permissions
        .where((p) => p.granted)
        .map((p) => p.permission.id!)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupPermissions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          'Permissões',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        ...grouped.entries.map((entry) {
          return _buildPermissionGroup(
            context,
            resource: entry.key,
            permissions: entry.value,
          );
        }),
      ],
    );
  }

  Widget _buildPermissionGroup(
    BuildContext context, {
    required String resource,
    required List<PermissionInfo> permissions,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              _getResourceLabel(resource),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Divider(),
            ...permissions.map((perm) {
              final isChecked = _selectedIds.contains(perm.permission.id);
              return CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  perm.permission.description ?? perm.permission.slug,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  perm.permission.slug,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                value: isChecked,
                onChanged: widget.readOnly
                    ? null
                    : (value) => _togglePermission(perm.permission.id!, value!),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _togglePermission(int permissionId, bool granted) {
    setState(() {
      if (granted) {
        _selectedIds.add(permissionId);
      } else {
        _selectedIds.remove(permissionId);
      }
    });
    widget.onChanged(_selectedIds.toList());
  }

  /// Groups permissions by resource (workspace, board, card)
  Map<String, List<PermissionInfo>> _groupPermissions() {
    final Map<String, List<PermissionInfo>> grouped = {};

    for (final perm in widget.permissions) {
      final slug = perm.permission.slug;
      final resource = slug.split('.').first; // e.g., "workspace" from "workspace.read"

      grouped.putIfAbsent(resource, () => []);
      grouped[resource]!.add(perm);
    }

    return grouped;
  }

  String _getResourceLabel(String resource) {
    switch (resource) {
      case 'workspace':
        return 'Workspace';
      case 'board':
        return 'Board';
      case 'card':
        return 'Card';
      default:
        return resource.toUpperCase();
    }
  }
}
