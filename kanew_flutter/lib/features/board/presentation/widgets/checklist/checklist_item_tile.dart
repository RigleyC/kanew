import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../../core/widgets/editable_inline_text.dart';

class ChecklistItemTile extends StatefulWidget {
  final ChecklistItem item;
  final void Function(bool isChecked) onToggle;
  final VoidCallback onDelete;
  final Future<void> Function(String title) onRename;
  final Widget? dragHandle;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onRename,
    this.dragHandle,
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
        padding: const EdgeInsets.fromLTRB(0, 6, 12, 6),
        child: Row(
          children: [
            if (widget.dragHandle != null) ...[
              SizedBox(
                width: 18,
                child: AnimatedOpacity(
                  opacity: _isHovering ? 1 : 0,
                  duration: const Duration(milliseconds: 120),
                  child: IgnorePointer(
                    ignoring: !_isHovering,
                    child: widget.dragHandle!,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
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
              child: EditableInlineText(
                text: widget.item.title,
                onSave: widget.onRename,
                textStyle: TextStyle(
                  fontSize: 14,
                  decoration: widget.item.isChecked
                      ? TextDecoration.lineThrough
                      : null,
                  color: widget.item.isChecked
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
                editingTextStyle: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
