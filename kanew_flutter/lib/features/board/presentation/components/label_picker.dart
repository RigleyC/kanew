import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../../../core/constants/label_colors.dart';

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
  final _searchController = TextEditingController();
  _PickerState _state = _PickerState.list;
  String _pendingLabelName = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LabelDef> get _filteredLabels {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return widget.boardLabels;
    return widget.boardLabels
        .where((l) => l.name.toLowerCase().contains(query))
        .toList();
  }

  bool get _showCreateOption {
    final query = _searchController.text.trim();
    if (query.isEmpty) return false;
    // Show create if no exact match
    return !widget.boardLabels.any(
      (l) => l.name.toLowerCase() == query.toLowerCase(),
    );
  }

  void _startCreateLabel() {
    setState(() {
      _pendingLabelName = _searchController.text.trim();
      _state = _PickerState.selectColor;
    });
  }

  void _selectColor(String colorHex) {
    widget.onCreateLabel(_pendingLabelName, colorHex);
    setState(() {
      _state = _PickerState.list;
      _pendingLabelName = '';
      _searchController.clear();
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      child: _state == _PickerState.selectColor
          ? _buildColorPicker(colorScheme)
          : _buildLabelList(colorScheme),
    );
  }

  Widget _buildLabelList(ColorScheme colorScheme) {
    final filtered = _filteredLabels;
    final hasLabels = widget.selectedLabels.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search input
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: hasLabels ? 'Change or add labels...' : 'Add labels...',
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),

        // Labels list
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...filtered.map((label) => _buildLabelItem(label, colorScheme)),

                // Create option
                if (_showCreateOption) ...[
                  const Divider(height: 16),
                  _buildCreateOption(colorScheme),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelItem(LabelDef label, ColorScheme colorScheme) {
    final isSelected = widget.selectedLabels.any((l) => l.id == label.id);
    final labelColor = LabelColors.parseHex(label.colorHex);

    return InkWell(
      onTap: () => widget.onToggleLabel(label.id!),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Checkbox indicator
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),

            // Color dot
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: labelColor,
                shape: BoxShape.circle,
              ),
            ),

            // Label name
            Expanded(
              child: Text(
                label.name,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption(ColorScheme colorScheme) {
    return InkWell(
      onTap: _startCreateLabel,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 18,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Create new label: ',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '"${_searchController.text.trim()}"',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            InkWell(
              onTap: _cancelColorSelection,
              borderRadius: BorderRadius.circular(4),
              child: const Icon(Icons.arrow_back, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pick a color for "$_pendingLabelName"',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Color options
        ...LabelColors.options.map(
          (option) => InkWell(
            onTap: () => _selectColor(option.hex),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: option.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
