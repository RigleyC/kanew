import 'package:flutter/material.dart';

/// Provider that manages sidebar state globally
class SidebarProvider extends InheritedWidget {
  /// Whether the sidebar is open (expanded)
  final bool isOpen;

  /// Whether the current viewport is mobile
  final bool isMobile;

  /// Callback to set the sidebar open state
  final void Function(bool) setOpen;

  /// Toggle the sidebar state
  final VoidCallback toggleSidebar;

  const SidebarProvider({
    super.key,
    required this.isOpen,
    required this.isMobile,
    required this.setOpen,
    required this.toggleSidebar,
    required super.child,
  });

  static SidebarProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SidebarProvider>();
  }

  static SidebarProvider of(BuildContext context) {
    final provider = maybeOf(context);
    if (provider == null) {
      throw Exception('No SidebarProvider found in context');
    }
    return provider;
  }

  /// Whether the sidebar is collapsed (closed and not mobile)
  bool get isCollapsed => !isOpen && !isMobile;

  @override
  bool updateShouldNotify(SidebarProvider oldWidget) {
    return isOpen != oldWidget.isOpen || isMobile != oldWidget.isMobile;
  }
}

// ============================================================================
// SIDEBAR STATE WIDGET - Wrapper that provides state
// ============================================================================

/// Widget that manages sidebar state and provides it to descendants
class SidebarStateWidget extends StatefulWidget {
  final Widget child;
  final bool defaultOpen;
  final double mobileBreakpoint;

  const SidebarStateWidget({
    super.key,
    required this.child,
    this.defaultOpen = true,
    this.mobileBreakpoint = 768,
  });

  @override
  State<SidebarStateWidget> createState() => _SidebarStateWidgetState();
}

class _SidebarStateWidgetState extends State<SidebarStateWidget> {
  late bool _isOpen;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.defaultOpen;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final wasMobile = _isMobile;
    _isMobile = MediaQuery.of(context).size.width < widget.mobileBreakpoint;

    // Auto-close when switching to mobile
    if (_isMobile && !wasMobile && _isOpen) {
      _isOpen = false;
    }
  }

  void _setOpen(bool value) {
    setState(() {
      _isOpen = value;
    });
  }

  void _toggleSidebar() {
    _setOpen(!_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return SidebarProvider(
      isOpen: _isOpen,
      isMobile: _isMobile,
      setOpen: _setOpen,
      toggleSidebar: _toggleSidebar,
      child: widget.child,
    );
  }
}
