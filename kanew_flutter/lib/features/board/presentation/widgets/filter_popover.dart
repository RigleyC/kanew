import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:kanew_client/kanew_client.dart';

import '../store/board_filter_store.dart';

/// Filter popover with cascading menu design.
/// Shows categories on first level, options on second level.
class FilterPopover extends StatefulWidget {
  final BoardFilterStore filterStore;

  const FilterPopover({
    super.key,
    required this.filterStore,
  });

  @override
  State<FilterPopover> createState() => _FilterPopoverState();
}

class _FilterPopoverState extends State<FilterPopover>
    with SingleTickerProviderStateMixin {
  late final FPopoverController _popoverController;
  _FilterView _currentView = _FilterView.categories;

  @override
  void initState() {
    super.initState();
    _popoverController = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  void _showCategories() {
    setState(() => _currentView = _FilterView.categories);
  }

  void _showPriorityOptions() {
    setState(() => _currentView = _FilterView.priority);
  }

  void _closePopover() {
    _popoverController.hide();
    // Reset view for next open
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _currentView = _FilterView.categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.filterStore,
      builder: (context, _) {
        final activeCount = widget.filterStore.activeCount;

        return FPopover(
          control: FPopoverControl.managed(controller: _popoverController),
          popoverBuilder: (context, _) => _buildPopoverContent(context),
          child: _FilterButton(
            activeCount: activeCount,
            onPressed: _popoverController.toggle,
          ),
        );
      },
    );
  }

  Widget _buildPopoverContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 240,
      constraints: const BoxConstraints(maxHeight: 320),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _currentView == _FilterView.categories
              ? _CategoriesView(
                  key: const ValueKey('categories'),
                  filterStore: widget.filterStore,
                  onPriorityTap: _showPriorityOptions,
                  onClose: _closePopover,
                )
              : _PriorityOptionsView(
                  key: const ValueKey('priority'),
                  filterStore: widget.filterStore,
                  onBack: _showCategories,
                ),
        ),
      ),
    );
  }
}

enum _FilterView { categories, priority }

// --- Filter Button ---

class _FilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.activeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list,
                size: 16,
                color: activeCount > 0
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: activeCount > 0
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              if (activeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$activeCount',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- Categories View ---

class _CategoriesView extends StatelessWidget {
  final BoardFilterStore filterStore;
  final VoidCallback onPriorityTap;
  final VoidCallback onClose;

  const _CategoriesView({
    super.key,
    required this.filterStore,
    required this.onPriorityTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Priority category
        _CategoryTile(
          icon: Icons.flag_outlined,
          label: 'Prioridade',
          count: filterStore.priorities.length,
          onTap: onPriorityTap,
        ),

        // Labels category (disabled for now)
        _CategoryTile(
          icon: Icons.label_outline,
          label: 'Etiquetas',
          count: filterStore.labelIds.length,
          onTap: () {}, // TODO: Implement labels
          enabled: false,
        ),

        // Clear all button
        if (filterStore.hasActiveFilters) ...[
          Divider(height: 1, color: colorScheme.outlineVariant),
          _ClearAllTile(
            onTap: () {
              filterStore.clearAll();
              onClose();
            },
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;
  final bool enabled;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final opacity = enabled ? 1.0 : 0.5;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (count > 0)
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClearAllTile extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearAllTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.clear, size: 16, color: colorScheme.error),
              const SizedBox(width: 10),
              Text(
                'Limpar filtros',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Priority Options View ---

class _PriorityOptionsView extends StatefulWidget {
  final BoardFilterStore filterStore;
  final VoidCallback onBack;

  const _PriorityOptionsView({
    super.key,
    required this.filterStore,
    required this.onBack,
  });

  @override
  State<_PriorityOptionsView> createState() => _PriorityOptionsViewState();
}

class _PriorityOptionsViewState extends State<_PriorityOptionsView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Filter priorities by search
    final allPriorities = CardPriority.values;
    final filteredPriorities = _searchQuery.isEmpty
        ? allPriorities
        : allPriorities
              .where(
                (p) => _getPriorityLabel(
                  p,
                ).toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with back button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 18),
                onPressed: widget.onBack,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              const SizedBox(width: 4),
              Text(
                'Prioridade',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        // Search field
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Buscar...',
              hintStyle: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            style: const TextStyle(fontSize: 13),
          ),
        ),

        // Options list
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: filteredPriorities.length,
            itemBuilder: (context, index) {
              final priority = filteredPriorities[index];
              final isSelected = widget.filterStore.isPrioritySelected(
                priority,
              );

              return _PriorityOptionTile(
                priority: priority,
                isSelected: isSelected,
                onTap: () => widget.filterStore.togglePriority(priority),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getPriorityLabel(CardPriority priority) {
    switch (priority) {
      case CardPriority.urgent:
        return 'Urgente';
      case CardPriority.high:
        return 'Alta';
      case CardPriority.medium:
        return 'Média';
      case CardPriority.low:
        return 'Baixa';
      case CardPriority.none:
        return 'Nenhuma';
    }
  }
}

class _PriorityOptionTile extends StatelessWidget {
  final CardPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityOptionTile({
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Priority color indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _getPriorityLabel(priority),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 16,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(CardPriority priority) {
    switch (priority) {
      case CardPriority.urgent:
        return 'Urgente';
      case CardPriority.high:
        return 'Alta';
      case CardPriority.medium:
        return 'Média';
      case CardPriority.low:
        return 'Baixa';
      case CardPriority.none:
        return 'Nenhuma';
    }
  }

  Color _getPriorityColor(CardPriority priority) {
    switch (priority) {
      case CardPriority.urgent:
        return const Color(0xFFB71C1C);
      case CardPriority.high:
        return const Color(0xFFE53935); // Red
      case CardPriority.medium:
        return const Color(0xFFFFC107); // Amber
      case CardPriority.low:
        return const Color(0xFF4CAF50); // Green
      case CardPriority.none:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}
