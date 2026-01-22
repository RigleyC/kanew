import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../controllers/card_detail_controller.dart';

class ChecklistWidget extends StatefulWidget {
  final Checklist checklist;
  final List<ChecklistItem> items;
  final CardDetailPageController controller;

  const ChecklistWidget({
    super.key,
    required this.checklist,
    required this.items,
    required this.controller,
  });

  @override
  State<ChecklistWidget> createState() => _ChecklistWidgetState();
}

class _ChecklistWidgetState extends State<ChecklistWidget> {
  bool _isAddingItem = false;
  final _newItemController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _newItemController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitItem() {
    final title = _newItemController.text.trim();
    if (title.isNotEmpty) {
      widget.controller.addItem(widget.checklist.id!, title);
      _newItemController.clear();
    }
    setState(() {
      _isAddingItem = false;
    });
  }

  void _deleteChecklist() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir checklist?'),
        content: const Text(
            'Todos os itens desta checklist serão excluídos permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              widget.controller.deleteChecklist(widget.checklist.id!);
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = _calculateProgress();
    final items = widget.items;

    // Sort items by rank (or ID if rank is string based and complex, but let's assume simple sort for now)
    // Actually, backend returns sorted, but optimistic updates might need sorting.
    // Let's rely on list order for now.

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.check_box_outlined, color: colorScheme.onSurface),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.checklist.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.items.isNotEmpty)
                 Text(
                   '${(progress * 100).toInt()}%',
                   style: TextStyle(
                     fontSize: 12,
                     color: colorScheme.onSurfaceVariant,
                   ),
                 ),
              const SizedBox(width: 8),
              PopupMenuButton(
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: _deleteChecklist,
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
          
          // Progress bar
          if (items.isNotEmpty) ...[
             const SizedBox(height: 8),
             ClipRRect(
               borderRadius: BorderRadius.circular(4),
               child: LinearProgressIndicator(
                 value: progress,
                 minHeight: 6,
                 backgroundColor: colorScheme.surfaceContainerHighest,
                 valueColor: AlwaysStoppedAnimation(colorScheme.primary),
               ),
             ),
          ],
          
          const SizedBox(height: 16),
          
          // Items
          ...items.map((item) => ChecklistItemWidget(
            item: item,
            controller: widget.controller,
            checklistId: widget.checklist.id!,
          )),
          
          // Add Item Button/Input
          if (_isAddingItem)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newItemController,
                      focusNode: _focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Adicionar um item',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _submitItem(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _submitItem,
                    child: const Text('Adicionar'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _isAddingItem = false),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  setState(() => _isAddingItem = true);
                },
                child: const Text('Adicionar um item'),
              ),
            ),
        ],
      ),
    );
  }

  double _calculateProgress() {
    if (widget.items.isEmpty) return 0;
    final checkedCount = widget.items.where((i) => i.isChecked).length;
    return checkedCount / widget.items.length;
  }
}

class ChecklistItemWidget extends StatefulWidget {
  final ChecklistItem item;
  final int checklistId;
  final CardDetailPageController controller;

  const ChecklistItemWidget({
    super.key,
    required this.item,
    required this.checklistId,
    required this.controller,
  });

  @override
  State<ChecklistItemWidget> createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<ChecklistItemWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: widget.item.isChecked,
                onChanged: (value) {
                  widget.controller.toggleItem(
                    widget.checklistId,
                    widget.item.id!,
                    value ?? false,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.item.title,
                style: TextStyle(
                  decoration: widget.item.isChecked ? TextDecoration.lineThrough : null,
                  color: widget.item.isChecked ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                ),
              ),
            ),
            if (_isHovering)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  widget.controller.deleteItem(widget.checklistId, widget.item.id!);
                },
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
