import 'package:flutter/material.dart';
import 'package:kanew_client/kanew_client.dart';
import '../../constants/label_colors.dart';

class LabelSidebarMenu extends StatefulWidget {
  final List<LabelDef> labels;
  final List<LabelDef> selectedLabels;
  final Function(int labelId) onToggleLabel;
  final Function(String name, String color) onCreateLabel;

  const LabelSidebarMenu({
    super.key,
    required this.labels,
    required this.selectedLabels,
    required this.onToggleLabel,
    required this.onCreateLabel,
  });

  @override
  State<LabelSidebarMenu> createState() => _LabelSidebarMenuState();
}

class _LabelSidebarMenuState extends State<LabelSidebarMenu> {
  final MenuController _controller = MenuController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _pendingLabelName = '';
  bool _showColorPicker = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _resetState() {
    setState(() {
      _searchQuery = '';
      _pendingLabelName = '';
      _showColorPicker = false;
    });
    _searchController.clear();
  }

  void _onMenuOpen() {
    setState(() {
      _searchQuery = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _onMenuClose() {
    _resetState();
  }

  List<LabelDef> get _filteredLabels {
    if (_searchQuery.isEmpty) return widget.labels;
    return widget.labels.where((label) {
      return label.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  bool _showCreateOption(String query) {
    if (query.isEmpty) return false;
    return !widget.labels.any(
      (l) => l.name.toLowerCase() == query.toLowerCase(),
    );
  }

  void _startCreateLabel(String labelName) {
    setState(() {
      _pendingLabelName = labelName;
      _showColorPicker = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _selectColor(String colorHex) {
    widget.onCreateLabel(_pendingLabelName, colorHex);
    _resetState();
  }

  void _cancelColorSelection() {
    _resetState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuAnchor(
      alignmentOffset: const Offset(-240, 8),
      controller: _controller,
      consumeOutsideTap: true,
      onOpen: _onMenuOpen,
      onClose: _onMenuClose,
      menuChildren: _buildMenuChildren(theme),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Icon(Icons.add),
        );
      },
    );
  }

  List<Widget> _buildMenuChildren(ThemeData theme) {
    if (_showColorPicker) {
      return [
        SizedBox(
          width: 240,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _cancelColorSelection,
                      borderRadius: BorderRadius.circular(4),
                      child: const Icon(Icons.keyboard_arrow_left, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Escolha uma cor',
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ...LabelColors.options.map(
                (option) => InkWell(
                  onTap: () => _selectColor(option.hex),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: option.color,
                          ),
                        ),
                        Text(
                          option.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ];
    }

    return [
      SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),

      if (_filteredLabels.isNotEmpty) ...[
        const Divider(height: 1),
        SizedBox(height: 16),
        ..._filteredLabels.map(
          (label) {
            final isSelected = widget.selectedLabels.any(
              (l) => l.id == label.id,
            );
            final colorOption = LabelColors.options.firstWhere(
              (o) => o.hex == label.colorHex,
              orElse: () => LabelColors.options[4],
            );

            return SizedBox(
              width: 240,
              child: CheckboxListTile(
                value: isSelected,
                title: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorOption.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label.name,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                onChanged: (_) {
                  widget.onToggleLabel(label.id!);
                },
              ),
            );
          },
        ),
      ],
      if (_showCreateOption(_searchQuery)) ...[
        SizedBox(height: 16),
        const Divider(height: 1),
        SizedBox(height: 16),
        InkWell(
          onTap: () => _startCreateLabel(_searchQuery),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.add,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      Text(
                        'Criar nova etiqueta: ',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '"$_searchQuery"',
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      if (_filteredLabels.isEmpty && !_showCreateOption(_searchQuery)) ...[
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Nenhuma etiqueta encontrada',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
      const SizedBox(height: 8),
    ];
  }
}
