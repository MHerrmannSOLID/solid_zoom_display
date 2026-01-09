import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';

import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

import 'test_projector.dart';
import 'test_ticker_provider.dart';

extension NumberParsing on WidgetTester {
  Offset canvasWidgetCenter() => getCenter(find.byType(CanvasWidget));
}

SizedBox createCanvasWidget({
  Size size = const Size(300, 300),
  DisplayProjector? projector,
  ZoomController? zoomController,
  InteractionController? interactionController,
  DisplayMouseInteraction? mouseInteraction,
  SelectionOverlayProjector? selectionProjector,
  Paint? backgroundPaint,
  List<DisplayProjector>? additionalProjectors,
}) {
  return SizedBox(
    width: size.width,
    height: size.height,
    child: CanvasWidget(
      projector: projector ?? TestProjector(),
      interactionController: interactionController,
      mouseInteraction: mouseInteraction,
      zoomController: zoomController,
      selectionProjector: selectionProjector,
      backgroundPaint: backgroundPaint ?? Paint()
        ..color = Colors.white,
      additionalProjectors: additionalProjectors,
      vsync: TestTickerProvider(),
    ),
  );
}
