import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/context_menu_region.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/box_selection_projector.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

class ZoomDisplay extends StatelessWidget {
  ZoomDisplay({
    required this.projector,
    required this.vsync,
    super.key,
    Paint? backgroundPaint,
    this.zoomMargin = 0.01,
    this.mouseInteraction,
    this.touchInteraction,
    SelectionOverlayProjector? selectionProjector,
    this.contextMenuBuilder,
  })  : _selectionProjector = selectionProjector ?? BoxSelectionProjector(),
        _backgroundPaint = backgroundPaint ??( Paint()..color = Colors.white);

  final Paint _backgroundPaint;
  DisplayProjector projector;
  double zoomMargin;
  final DisplayMouseInteraction? mouseInteraction;
  final DisplayTouchInteraction? touchInteraction;
  final TickerProvider vsync;
  final SelectionOverlayProjector _selectionProjector;
  final ContextMenuBuilder? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenuBuilder: contextMenuBuilder,
      child: CanvasWidget(
        backgroundPaint: _backgroundPaint,
        selectionProjector: _selectionProjector,
        projector: projector,
        mouseInteraction: mouseInteraction,
        touchInteraction: touchInteraction,

        vsync: vsync,
      ),
    );
  }
}
