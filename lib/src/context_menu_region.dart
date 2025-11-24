import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';
import 'package:solid_zoom_display/src/interaction/interaction_controller.dart';
import 'package:solid_zoom_display/src/types/context_menu_interaction.dart';


class ContextMenuRegion extends StatefulWidget {

  static Widget _defaultContextMenuBuilder(BuildContext context, Offset offset) =>
      const Placeholder();

  const ContextMenuRegion({required this.child,
    super.key, ContextMenuBuilder? contextMenuBuilder})
      : contextMenuBuilder = contextMenuBuilder ?? _defaultContextMenuBuilder;

  final ContextMenuBuilder contextMenuBuilder;
  final CanvasWidget child;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> implements ContextMenuInteraction {
  final ContextMenuController _contextMenuController = ContextMenuController();

  @override
  get isOpen => _contextMenuController.isShown;

  @override
  initState() {
    widget.child.contextMenuInteraction = this;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void show(InteractionController? zoomPanel, Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void hide() {
    _contextMenuController.remove();
  }
}
