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

class _SlashMenuOverlayState extends State<SlashMenuOverlay>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  String _lastQuery = '';
  bool _lastIsOpen = false;
  int _lastSelectedIndex = 0;
  bool _didJustOpen = false;
  bool _didQueryChange = false;
  bool _shouldRender = false;
  List<SlashMenuItem> _displayItems = const [];
  int _displaySelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    // Keep local snapshot in sync so that the first navigation update doesn't
    // look like a fresh "open" and restart the animation.
    _lastIsOpen = widget.plugin.isOpen;
    _lastQuery = widget.plugin.query;
    _lastSelectedIndex = widget.plugin.selectedIndex;
    _displayItems = widget.plugin.filteredItems;
    _displaySelectedIndex = widget.plugin.selectedIndex;

    widget.plugin.addListener(_onPluginChange);

    // Iniciar animação se já estiver aberto (caso raro no init, mas possível)
    if (widget.plugin.isOpen) {
      _animationController.forward(from: 0.0);
      _shouldRender = true;
    }

    _animationController.addStatusListener(_onAnimationStatusChanged);
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
    _animationController.removeStatusListener(_onAnimationStatusChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (!mounted) return;

    if (status == AnimationStatus.dismissed && !widget.plugin.isOpen) {
      setState(() {
        _shouldRender = false;
      });
    }
  }

  void _onPluginChange() {
    if (!mounted) return;

    final plugin = widget.plugin;

    final wasOpen = _lastIsOpen;
    final wasQuery = _lastQuery;
    final wasSelectedIndex = _lastSelectedIndex;

    _lastIsOpen = plugin.isOpen;
    _lastQuery = plugin.query;
    _lastSelectedIndex = plugin.selectedIndex;

    final isOpening = plugin.isOpen && !wasOpen;
    final isClosing = !plugin.isOpen && wasOpen;
    _didJustOpen = isOpening;
    _didQueryChange = plugin.query != wasQuery;

    if (isOpening) {
      _shouldRender = true;
      _animationController.forward(from: 0.0);
    } else if (isClosing) {
      _animationController.reverse();
    }

    if (plugin.isOpen) {
      _displayItems = plugin.filteredItems;
      _displaySelectedIndex = plugin.selectedIndex;
    }

    final needsRebuild =
        isOpening ||
        isClosing ||
        plugin.query != wasQuery ||
        plugin.selectedIndex != wasSelectedIndex;

    if (needsRebuild) {
      setState(() {});
    }

    if (plugin.isOpen) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _ensureSelectedVisible(
          didJustOpen: _didJustOpen,
          didQueryChange: _didQueryChange,
        ),
      );
    }
  }

  void _ensureSelectedVisible({
    required bool didJustOpen,
    required bool didQueryChange,
  }) {
    if (!mounted || !_scrollController.hasClients) return;

    final plugin = widget.plugin;
    final items = plugin.filteredItems;
    if (!plugin.isOpen || items.isEmpty) return;

    final selectedIndex = plugin.selectedIndex.clamp(0, items.length - 1);
    const itemHeight = 32.0;

    if (didJustOpen || didQueryChange) {
      _scrollController.jumpTo(0);
      return;
    }

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
    if (!_shouldRender) {
      return const SizedBox.shrink();
    }

    final plugin = widget.plugin;
    final items = plugin.isOpen ? plugin.filteredItems : _displayItems;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child,
          ),
        );
      },
      child: items.isEmpty
          ? Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).highlightColor),
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
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
            )
          : _buildMenuList(context, items, isInteractive: plugin.isOpen),
    );
  }

  Widget _buildMenuList(
    BuildContext context,
    List<SlashMenuItem> items, {
    required bool isInteractive,
  }) {
    final selectedIndex =
        (isInteractive ? widget.plugin.selectedIndex : _displaySelectedIndex)
            .clamp(
              0,
              items.length - 1,
            );

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 384,
        maxWidth: 200,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),

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
        itemExtent: 32,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return InkWell(
            onTap: isInteractive
                ? () => widget.plugin.executeSelected(item)
                : null,
            hoverColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).highlightColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    item.icon,
                    size: 14,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.labelMedium,
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
