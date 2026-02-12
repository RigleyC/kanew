import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:follow_the_leader/follow_the_leader.dart';
import 'package:super_editor/super_editor.dart';

import 'slash_menu_overlay.dart';
import 'slash_menu_plugin.dart';

class SlashMenuSuperEditorPlugin extends SuperEditorPlugin {
  SlashMenuSuperEditorPlugin({
    required SelectionLayerLinks selectionLayerLinks,
  }) : _selectionLayerLinks = selectionLayerLinks;

  final SelectionLayerLinks _selectionLayerLinks;

  SlashMenuPlugin? _controller;
  Editor? _attachedEditor;

  @override
  void attach(Editor editor) {
    if (_attachedEditor == editor && _controller != null) return;

    _controller?.dispose();
    _controller = SlashMenuPlugin(editor: editor);
    _attachedEditor = editor;
  }

  @override
  List<SuperEditorKeyboardAction> get keyboardActions {
    return [
      ({
        required SuperEditorContext editContext,
        required KeyEvent keyEvent,
      }) {
        final controller = _controller;
        if (controller == null) {
          return ExecutionInstruction.continueExecution;
        }
        return controller.onKeyEvent(editContext, keyEvent);
      },
    ];
  }

  @override
  List<SuperEditorLayerBuilder> get documentOverlayBuilders {
    return [
      FunctionalSuperEditorLayerBuilder((context, editContext) {
        final controller = _controller;
        if (controller == null) {
          return const EmptyContentLayer();
        }

        return ContentLayerProxyWidget(
          child: _SlashMenuFollowerLayer(
            controller: controller,
            selectionLayerLinks: _selectionLayerLinks,
            selectionListenable: editContext.composer.selectionNotifier,
          ),
        );
      }),
    ];
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _attachedEditor = null;
  }
}

class _SlashMenuFollowerLayer extends StatefulWidget {
  const _SlashMenuFollowerLayer({
    required this.controller,
    required this.selectionLayerLinks,
    required this.selectionListenable,
  });

  final SlashMenuPlugin controller;
  final SelectionLayerLinks selectionLayerLinks;
  final ValueListenable<DocumentSelection?> selectionListenable;

  @override
  State<_SlashMenuFollowerLayer> createState() =>
      _SlashMenuFollowerLayerState();
}

class _SlashMenuFollowerLayerState extends State<_SlashMenuFollowerLayer> {
  @override
  void initState() {
    super.initState();
    widget.selectionListenable.addListener(_onSelectionChange);
    _onSelectionChange();
  }

  @override
  void didUpdateWidget(_SlashMenuFollowerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionListenable != widget.selectionListenable) {
      oldWidget.selectionListenable.removeListener(_onSelectionChange);
      widget.selectionListenable.addListener(_onSelectionChange);
      _onSelectionChange();
    }
  }

  @override
  void dispose() {
    widget.selectionListenable.removeListener(_onSelectionChange);
    super.dispose();
  }

  void _onSelectionChange() {
    widget.controller.checkForTrigger(widget.selectionListenable.value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Follower.withOffset(
                link: widget.selectionLayerLinks.caretLink,
                leaderAnchor: Alignment.bottomLeft,
                followerAnchor: Alignment.topLeft,
                offset: const Offset(0, 8),
                showWhenUnlinked: false,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: 0,
                  minHeight: 0,
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: SlashMenuOverlay(plugin: controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
