import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

class ChecklistItemTile extends StatefulWidget {
  final ChecklistItem item;
  final void Function(bool isChecked) onToggle;
  final VoidCallback onDelete;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends State<ChecklistItemTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: Colors.blue,
                checkColor: Colors.white,
                value: widget.item.isChecked,
                onChanged: (value) => widget.onToggle(value ?? false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item.title,
                style: TextStyle(
                  decoration: widget.item.isChecked
                      ? TextDecoration.lineThrough
                      : null,
                  color: widget.item.isChecked
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
              ),
            ),
            if (_isHovering)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: widget.onDelete,
                color: colorScheme.onSurfaceVariant,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}
