import 'package:flutter/material.dart';
import 'slash_menu_plugin.dart';

class SlashMenuOverlay extends StatefulWidget {
  final SlashMenuPlugin plugin;

  const SlashMenuOverlay({
    super.key,
    required this.plugin,
  });

  @override
  State<SlashMenuOverlay> createState() => _SlashMenuOverlayState();
}

class _SlashMenuOverlayState extends State<SlashMenuOverlay> {
  static const double _kItemExtent = 56;

  late final ScrollController _scrollController;
  String _lastQuery = '';
  bool _lastIsOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget.plugin.addListener(_onPluginChange);
  }

  @override
  void didUpdateWidget(SlashMenuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plugin != widget.plugin) {
      oldWidget.plugin.removeListener(_onPluginChange);
      widget.plugin.addListener(_onPluginChange);
    }
  }

  @override
  void dispose() {
    widget.plugin.removeListener(_onPluginChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _onPluginChange() {
    if (!mounted) return;
    setState(() {});

    // Ensure the selected item stays visible when the user navigates with arrow keys.
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSelectedVisible());
  }

  void _ensureSelectedVisible() {
    if (!mounted || !_scrollController.hasClients) return;

    final plugin = widget.plugin;
    final items = plugin.filteredItems;
    if (!plugin.isOpen || items.isEmpty) return;

    final selectedIndex = plugin.selectedIndex.clamp(0, items.length - 1);

    // When opening or changing query, reset to the top to avoid confusing scroll positions.
    if (!_lastIsOpen && plugin.isOpen) {
      _scrollController.jumpTo(0);
    } else if (_lastQuery != plugin.query) {
      _scrollController.jumpTo(0);
    } else {
      final position = _scrollController.position;
      final viewport = position.viewportDimension;
      final currentOffset = position.pixels;

      final itemTop = selectedIndex * _kItemExtent;
      final itemBottom = itemTop + _kItemExtent;
      final viewTop = currentOffset;
      final viewBottom = currentOffset + viewport;

      if (itemTop < viewTop) {
        _scrollController.animateTo(
          itemTop.clamp(position.minScrollExtent, position.maxScrollExtent),
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      } else if (itemBottom > viewBottom) {
        _scrollController.animateTo(
          (itemBottom - viewport)
              .clamp(position.minScrollExtent, position.maxScrollExtent),
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      }
    }

    _lastQuery = plugin.query;
    _lastIsOpen = plugin.isOpen;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.plugin.isOpen) {
      return const SizedBox.shrink();
    }

    final items = widget.plugin.filteredItems;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Ensure selected index is valid
    final selectedIndex = widget.plugin.selectedIndex.clamp(
      0,
      items.length - 1,
    );

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
        maxWidth: 250,
      ),
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: _kItemExtent,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;
          final colorScheme = Theme.of(context).colorScheme;

          return InkWell(
            onTap: () => widget.plugin.executeSelected(item),
            hoverColor: Colors.transparent,
            child: Container(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 14,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (item.subtitle.isNotEmpty)
                          Text(
                            item.subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
