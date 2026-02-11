import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart' hide Card;

class PermissionMatrix extends StatefulWidget {
  final List<PermissionInfo> permissions;
  final ValueChanged<List<UuidValue>> onChanged;
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
  late Set<UuidValue> _selectedIds;

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
              final isRemoved = perm.isRemoved;
              final isAdded = perm.isAdded;
              final isDefault = perm.isDefault;
              
              return _buildPermissionTile(
                context,
                perm: perm,
                isChecked: isChecked,
                isRemoved: isRemoved,
                isAdded: isAdded,
                isDefault: isDefault,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(
    BuildContext context, {
    required PermissionInfo perm,
    required bool isChecked,
    required bool isRemoved,
    required bool isAdded,
    required bool isDefault,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    TextStyle titleStyle = const TextStyle(fontSize: 13);
    Widget? trailing;
    
    if (isRemoved) {
      titleStyle = titleStyle.copyWith(
        color: colorScheme.error,
        decoration: TextDecoration.lineThrough,
      );
      trailing = Icon(
        Icons.remove_circle_outline,
        color: colorScheme.error,
        size: 16,
      );
    } else if (isAdded) {
      trailing = Icon(
        Icons.add_circle_outline,
        color: Colors.green,
        size: 16,
      );
    } else if (isDefault) {
      trailing = Icon(
        Icons.settings,
        color: colorScheme.onSurfaceVariant,
        size: 16,
      );
    }

    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Text(
              perm.permission.description ?? perm.permission.slug,
              style: titleStyle,
            ),
          ),
          if (trailing != null) trailing,
        ],
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
  }

  void _togglePermission(UuidValue permissionId, bool granted) {
    setState(() {
      if (granted) {
        _selectedIds.add(permissionId);
      } else {
        _selectedIds.remove(permissionId);
      }
    });
    widget.onChanged(_selectedIds.toList());
  }

  Map<String, List<PermissionInfo>> _groupPermissions() {
    final Map<String, List<PermissionInfo>> grouped = {};

    for (final perm in widget.permissions) {
      final slug = perm.permission.slug;
      final resource = slug.split('.').first;

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
