import 'package:flutter/material.dart';

class SearchableListContent<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) labelBuilder;
  final Widget Function(T)? leadingBuilder;
  final void Function(T) onSelect;
  final VoidCallback? onClose;
  final String searchHint;
  final bool closeOnSelect;
  final bool Function(T, T)? isEqual;
  final Widget? emptyBuilder;
  final Widget? Function(String searchQuery)? footerBuilder;
  final void Function(String)? onSearchChanged;

  const SearchableListContent({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.labelBuilder,
    this.leadingBuilder,
    required this.onSelect,
    this.onClose,
    this.searchHint = 'Buscar...',
    this.closeOnSelect = false,
    this.isEqual,
    this.emptyBuilder,
    this.footerBuilder,
    this.onSearchChanged,
  });

  @override
  State<SearchableListContent<T>> createState() =>
      _SearchableListContentState<T>();
}

class _SearchableListContentState<T> extends State<SearchableListContent<T>> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _searchQuery => _searchController.text.trim();

  List<T> get _filteredItems {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) return widget.items;
    return widget.items
        .where((item) => widget.labelBuilder(item).toLowerCase().contains(query))
        .toList();
  }

  bool _isSelected(T item) {
    if (widget.isEqual != null) {
      return widget.selectedItems.any((s) => widget.isEqual!(s, item));
    }
    return widget.selectedItems.contains(item);
  }

  void _handleSelect(T item) {
    widget.onSelect(item);
    if (widget.closeOnSelect && widget.onClose != null) {
      widget.onClose!();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {});
    widget.onSearchChanged?.call(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filteredItems;
    final footer = widget.footerBuilder?.call(_searchQuery);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: widget.searchHint,
                isDense: true,
                border: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filtered.isEmpty && widget.emptyBuilder != null)
                    widget.emptyBuilder!
                  else
                    ...filtered.map((item) => _buildItem(item, colorScheme)),
                  if (footer != null) ...[
                    const Divider(height: 16),
                    footer,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(T item, ColorScheme colorScheme) {
    final isSelected = _isSelected(item);

    return InkWell(
      onTap: () => _handleSelect(item),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            if (isSelected)
              Icon(Icons.check, size: 16, color: colorScheme.onSurface)
            else
              const SizedBox(width: 16),
            const SizedBox(width: 8),
            if (widget.leadingBuilder != null) ...[
              widget.leadingBuilder!(item),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                widget.labelBuilder(item),
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
