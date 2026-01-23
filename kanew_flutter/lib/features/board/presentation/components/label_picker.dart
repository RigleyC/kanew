import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/label_colors.dart';
import '../../../../core/widgets/searchable_list_content.dart';

enum _PickerState { list, selectColor }

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
  _PickerState _state = _PickerState.list;
  String _pendingLabelName = '';

  bool _showCreateOption(String query) {
    if (query.isEmpty) return false;
    return !widget.boardLabels.any(
      (l) => l.name.toLowerCase() == query.toLowerCase(),
    );
  }

  void _startCreateLabel(String labelName) {
    setState(() {
      _pendingLabelName = labelName;
      _state = _PickerState.selectColor;
    });
  }

  void _selectColor(String colorHex) {
    widget.onCreateLabel(_pendingLabelName, colorHex);
    setState(() {
      _state = _PickerState.list;
      _pendingLabelName = '';
    });
  }

  void _cancelColorSelection() {
    setState(() {
      _state = _PickerState.list;
      _pendingLabelName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _PickerState.selectColor) {
      return _ColorPicker(
        pendingLabelName: _pendingLabelName,
        onSelectColor: _selectColor,
        onCancel: _cancelColorSelection,
      );
    }

    final hasLabels = widget.selectedLabels.isNotEmpty;

    return SearchableListContent<LabelDef>(
      items: widget.boardLabels,
      selectedItems: widget.selectedLabels,
      labelBuilder: (l) => l.name,
      leadingBuilder: (l) => _ColorDot(colorHex: l.colorHex),
      onSelect: (l) => widget.onToggleLabel(l.id!),
      searchHint: hasLabels ? 'Change or add labels...' : 'Add labels...',
      isEqual: (a, b) => a.id == b.id,
      footerBuilder: (query) => _showCreateOption(query)
          ? _CreateLabelOption(
              labelName: query,
              onTap: () => _startCreateLabel(query),
            )
          : null,
    );
  }
}

class _ColorDot extends StatelessWidget {
  final String colorHex;

  const _ColorDot({required this.colorHex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: LabelColors.parseHex(colorHex),
      ),
    );
  }
}

class _CreateLabelOption extends StatelessWidget {
  final String labelName;
  final VoidCallback onTap;

  const _CreateLabelOption({
    required this.labelName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 14,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Criar nova etiqueta: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '"$labelName"',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String pendingLabelName;
  final Function(String) onSelectColor;
  final VoidCallback onCancel;

  const _ColorPicker({
    required this.pendingLabelName,
    required this.onSelectColor,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.circular(4),
                child: const Icon(Icons.keyboard_arrow_left, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Pick a color",
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...LabelColors.options.map(
            (option) => InkWell(
              onTap: () => onSelectColor(option.hex),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: option.color,
                      ),
                    ),
                    Text(
                      option.name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
