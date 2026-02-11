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
  late final ScrollController _scrollController;
  String _lastQuery = '';
  bool _lastIsOpen = false;
  int _lastSelectedIndex = 0;

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
    
    // ✅ Só rebuildar se mudou algo visual
    final plugin = widget.plugin;
    final shouldRebuild = plugin.isOpen != _lastIsOpen ||
                         plugin.query != _lastQuery ||
                         plugin.selectedIndex != _lastSelectedIndex;
    
    if (shouldRebuild) {
      setState(() {});
      _lastQuery = plugin.query;
      _lastIsOpen = plugin.isOpen;
      _lastSelectedIndex = plugin.selectedIndex;
    }

    // Scroll após render
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ensureSelectedVisible(),
    );
  }

  void _ensureSelectedVisible() {
    if (!mounted || !_scrollController.hasClients) return;

    final plugin = widget.plugin;
    final items = plugin.filteredItems;
    if (!plugin.isOpen || items.isEmpty) return;

    final selectedIndex = plugin.selectedIndex.clamp(0, items.length - 1);
    final itemHeight = 56.0;

    // Reset scroll quando abre ou muda query
    if (!_lastIsOpen && plugin.isOpen || _lastQuery != plugin.query) {
      _scrollController.jumpTo(0);
      return;
    }

    // Auto-scroll para item selecionado
    final position = _scrollController.position;
    final viewport = position.viewportDimension;
    final currentOffset = position.pixels;

    final itemTop = selectedIndex * itemHeight;
    final itemBottom = itemTop + itemHeight;
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
        (itemBottom - viewport).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.plugin.isOpen) {
      return const SizedBox.shrink();
    }

    final items = widget.plugin.filteredItems;

    // Empty state
    if (items.isEmpty) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'No results found',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final selectedIndex = widget.plugin.selectedIndex.clamp(0, items.length - 1);

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 384, // Spec Tiptap
        maxWidth: 300,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: 56.0, // ✅ Perfeito para performance
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return InkWell(
            onTap: () => widget.plugin.executeSelected(item),
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200), // Spec Tiptap
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).highlightColor 
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(4), // Spec Tiptap
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12, // Spec: 12px
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20, // Spec: 20px (você tinha 14)
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 12), // Gap entre icon e texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (item.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12.8, // Spec Tiptap
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.6), // Spec: 60%
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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