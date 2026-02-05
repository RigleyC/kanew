import 'package:flutter/material.dart';

/// Dropdown com checkboxes para seleção múltipla.
/// Usa MenuAnchor nativo do Flutter (Flutter 3.16+).
///
/// [T] é o tipo dos itens. Pode ser String, int, ou qualquer objeto.
/// Use [itemToString] para converter o item para string (usado na busca).
class KanbanCheckboxDropdown<T> extends StatefulWidget {
  /// Lista de itens disponíveis
  final List<T> items;

  /// Itens atualmente selecionados
  final List<T> selectedItems;

  /// Callback quando seleção muda
  final ValueChanged<List<T>> onChanged;

  /// Label do botão
  final String label;

  /// Função para converter item em string (para busca)
  final String Function(T item) itemToString;

  /// Largura do menu
  final double menuWidth;

  /// Placeholder do campo de busca
  final String searchPlaceholder;

  /// Widget builder para item customizado (opcional)
  /// Se null, usa CheckboxListTile padrão
  final Widget Function(T item, bool isSelected)? itemBuilder;

  /// Footer builder (chamado quando a busca não encontra item existente)
  /// Útil para opção "Criar novo..."
  final Widget Function(String query)? footerBuilder;

  /// Label do botão de criar novo no footer (se null, não mostra)
  final String? createNewLabel;

  /// Callback quando "Create new" é pressionado
  final VoidCallback? onCreateNew;

  const KanbanCheckboxDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.label,
    required this.itemToString,
    this.menuWidth = 220,
    this.searchPlaceholder = 'Search...',
    this.itemBuilder,
    this.footerBuilder,
    this.createNewLabel,
    this.onCreateNew,
  });

  @override
  State<KanbanCheckboxDropdown<T>> createState() =>
      _KanbanCheckboxDropdownState<T>();
}

class _KanbanCheckboxDropdownState<T> extends State<KanbanCheckboxDropdown<T>> {
  final MenuController _controller = MenuController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _showCreateOption {
    if (_searchQuery.isEmpty) return false;
    return !widget.items.any(
      (item) =>
          widget.itemToString(item).toLowerCase() == _searchQuery.toLowerCase(),
    );
  }

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items.where((item) {
      final itemStr = widget.itemToString(item).toLowerCase();
      return itemStr.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleItem(T item) {
    final newSelection = List<T>.from(widget.selectedItems);
    if (newSelection.contains(item)) {
      newSelection.remove(item);
    } else {
      newSelection.add(item);
    }
    widget.onChanged(newSelection);
  }

  void _handleCreateNew() {
    widget.onCreateNew?.call();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuAnchor(
      controller: _controller,
      consumeOutsideTap: true,
      menuChildren: [
        // Search field
        SizedBox(
          width: widget.menuWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: widget.searchPlaceholder,
                prefixIcon: const Icon(Icons.search, size: 16),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
        if (_filteredItems.isNotEmpty) ...[
          const Divider(height: 1),
          // Checkbox items
          ..._filteredItems.map(
            (item) {
              final isSelected = widget.selectedItems.contains(item);
              return SizedBox(
                width: widget.menuWidth,
                child: widget.itemBuilder != null
                    ? widget.itemBuilder!(item, isSelected)
                    : CheckboxListTile(
                        value: isSelected,
                        title: Text(
                          widget.itemToString(item),
                          style: theme.textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        onChanged: (_) => _toggleItem(item),
                      ),
              );
            },
          ),
        ],
        // Footer with create option
        if (widget.footerBuilder != null && _showCreateOption) ...[
          const Divider(height: 1),
          widget.footerBuilder!(_searchQuery),
        ] else if (widget.createNewLabel != null && _showCreateOption) ...[
          const Divider(height: 1),
          SizedBox(
            width: widget.menuWidth,
            child: MenuItemButton(
              onPressed: _handleCreateNew,
              leadingIcon: const Icon(Icons.add, size: 16),
              child: Text(widget.createNewLabel!),
            ),
          ),
        ],
      ],
      builder: (context, controller, child) {
        return OutlinedButton.icon(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.add, size: 18),
          label: Text(widget.label),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      },
    );
  }
}
