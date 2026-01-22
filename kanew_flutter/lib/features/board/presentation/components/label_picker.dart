import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';

class LabelPicker extends StatefulWidget {
  final List<LabelDef> boardLabels;
  final List<LabelDef> selectedLabels;
  final Function(int) onToggleLabel;
  final Function(String, String) onCreateLabel;

  const LabelPicker({
    super.key,
    required this.boardLabels,
    required this.selectedLabels,
    required this.onToggleLabel,
    required this.onCreateLabel,
  });

  @override
  State<LabelPicker> createState() => _LabelPickerState();
}

class _LabelPickerState extends State<LabelPicker> {
  Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  void _showCreateLabelDialog(BuildContext context) {
    final nameController = TextEditingController();
    // Default colors
    final colors = [
      '#2196F3', '#4CAF50', '#F44336', '#FF9800', '#9C27B0', '#E91E63'
    ];
    String selectedColor = colors[0];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Criar etiqueta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: colors.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _parseColor(color),
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(width: 3, color: Colors.white) : null,
                          boxShadow: isSelected ? [
                            const BoxShadow(color: Colors.black26, blurRadius: 4),
                          ] : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    widget.onCreateLabel(nameController.text, selectedColor);
                    Navigator.pop(dialogContext); // Only pop the dialog
                  }
                },
                child: const Text('Criar'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Etiquetas',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Procurar etiquetas...',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                children: widget.boardLabels.map((label) {
                  final isSelected = widget.selectedLabels.any((l) => l.id == label.id);
                  
                  return InkWell(
                    onTap: () => widget.onToggleLabel(label.id!),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: _parseColor(label.colorHex),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                label.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.check, size: 16),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () {
              // Show create label dialog
              _showCreateLabelDialog(context);
            },
            child: const Text('Criar uma nova etiqueta'),
          ),
        ],
      ),
    );
  }
}
