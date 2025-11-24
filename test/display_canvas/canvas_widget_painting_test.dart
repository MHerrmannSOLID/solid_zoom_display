import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';

import '../test_helpers/helpers.dart';
import '../test_helpers/test_projector.dart';
import '../test_helpers/test_zoom_controller.dart';

void main() {
  testWidgets(
      'Create a render object from a canvas widget and require it to paint '
      '--> Should draw a background rect with same size as the widget',
      (WidgetTester tester) async {
    var rnd = Random();
    var canvasWidget = createCanvasWidget(
      projector: TestProjector(),
      zoomController: TestZoomController(),
    );

    await tester.pumpWidget(canvasWidget);

    final renderObject = tester.renderObject(find.byType(CanvasWidget));
    final screenSize = renderObject.paintBounds.size;

    final mockPaintingContext = MockPaintingContext();
    final offset = Offset(rnd.nextInt(1000) - 500, rnd.nextInt(1000) - 500);
    renderObject.paint(mockPaintingContext, offset);


    final backgroundRectCall = mockPaintingContext.mockCanvas.drawRectCalls.first;
    expect(backgroundRectCall.rect.size.width,screenSize.width);
    expect(backgroundRectCall.rect.size.height,screenSize.height);
  });

  testWidgets(
      'Create a render object from a canvas widget and require it to paint '
          '--> Should draw a background rect with the given screen offset',
          (WidgetTester tester) async {
        var rnd = Random();
        var canvasWidget = createCanvasWidget(
          projector: TestProjector(),
          zoomController: TestZoomController(),
        );

        await tester.pumpWidget(canvasWidget);

        final renderObject = tester.renderObject(find.byType(CanvasWidget));

        final mockPaintingContext = MockPaintingContext();
        final offset = Offset(rnd.nextInt(1000) - 500, rnd.nextInt(1000) - 500);
        renderObject.paint(mockPaintingContext, offset);


        final backgroundRectCall = mockPaintingContext.mockCanvas.drawRectCalls.first;

        expect(backgroundRectCall.rect.topLeft,offset);
      });

  testWidgets(
      'Create a render object from a canvas widget and require it to paint '
          '--> Should draw a background with the given background painter',
          (WidgetTester tester) async {
        var rnd = Random();
        final backgroundPaint = Paint()..color=Colors.red;
        var canvasWidget = createCanvasWidget(
          projector: TestProjector(),
          zoomController: TestZoomController(),
          backgroundPaint: backgroundPaint,
        );

        await tester.pumpWidget(canvasWidget);

        final renderObject = tester.renderObject(find.byType(CanvasWidget));

        final mockPaintingContext = MockPaintingContext();
        final offset = Offset(rnd.nextInt(1000) - 500, rnd.nextInt(1000) - 500);
        renderObject.paint(mockPaintingContext, offset);


        final backgroundRectCall = mockPaintingContext.mockCanvas.drawRectCalls.first;

        expect(backgroundRectCall.paint,backgroundPaint);
      });
}


class MockPaintingContext extends Fake implements PaintingContext {
  final mockCanvas = MockCanvas();

  @override
  Canvas get canvas => mockCanvas;

  @override
  void clipRectAndPaint(Rect rect, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    // Noting happening here since this is not part of the test
  }
}

class DrawRectData {
  final Rect rect;
  final Paint paint;


  DrawRectData(this.rect, this.paint);
}

class MockCanvas extends Fake implements Canvas {
  List<DrawRectData> drawRectCalls = [];

  @override
  void drawRect(Rect rect, Paint paint) => drawRectCalls.add(DrawRectData(rect, paint));
}
