import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

    final backgroundRectCall =
        mockPaintingContext.mockCanvas.drawRectCalls.first;
    expect(backgroundRectCall.rect.size.width, screenSize.width);
    expect(backgroundRectCall.rect.size.height, screenSize.height);
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

    final backgroundRectCall =
        mockPaintingContext.mockCanvas.drawRectCalls.first;

    expect(backgroundRectCall.rect.topLeft, offset);
  });

  testWidgets(
      'Create a render object from a canvas widget and require it to paint '
      '--> Should draw a background with the given background painter',
      (WidgetTester tester) async {
    var rnd = Random();
    final backgroundPaint = Paint()..color = Colors.red;
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

    final backgroundRectCall =
        mockPaintingContext.mockCanvas.drawRectCalls.first;

    expect(backgroundRectCall.paint, backgroundPaint);
  });

  testWidgets(
      'Canvas with additional projector layers '
      '--> Should draw Picture for each layer on paint',
      (WidgetTester tester) async {
    final mainProjector = TestProjector();
    final layer1 = TestProjector();
    final layer2 = TestProjector();

    var canvasWidget = createCanvasWidget(
      projector: mainProjector,
      additionalProjectors: [layer1, layer2],
      zoomController: TestZoomController(),
    );

    await tester.pumpWidget(canvasWidget);

    final renderObject = tester.renderObject(find.byType(CanvasWidget));
    final mockPaintingContext = MockPaintingContext();
    renderObject.paint(mockPaintingContext, Offset.zero);

    // Should have called drawPicture 3 times (main + 2 layers)
    expect(mockPaintingContext.mockCanvas.drawPictureCalls, 3);
  });

  testWidgets(
      'Canvas with additional projector that updates '
      '--> Should trigger markNeedsPaint and schedule a frame',
      (WidgetTester tester) async {
    final mainProjector = TestProjector();
    final spriteLayer = TestProjector();

    var canvasWidget = createCanvasWidget(
      projector: mainProjector,
      additionalProjectors: [spriteLayer],
      zoomController: TestZoomController(),
    );

    await tester.pumpWidget(canvasWidget);
    await tester.pumpAndSettle(); // Let everything settle

    // Verify no pending frames
    expect(tester.binding.hasScheduledFrame, false);

    // Update sprite - this should call markNeedsPaint via onNeedsPaint callback
    spriteLayer.triggerNotification();

    // Now there SHOULD be a scheduled frame (if onNeedsPaint was called)
    expect(tester.binding.hasScheduledFrame, true,
        reason:
            'markNeedsPaint() should have been called via onNeedsPaint callback');

    // Complete the frame
    await tester.pump();

    // Verify the sprite was re-recorded
    expect(spriteLayer.copyToContextCalls, 2); // initial + update
    expect(mainProjector.copyToContextCalls, 1); // unchanged
  });
}

class MockPaintingContext extends Fake implements PaintingContext {
  final mockCanvas = MockCanvas();

  @override
  Canvas get canvas => mockCanvas;

  @override
  void clipRectAndPaint(
      Rect rect, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    painter(); // Execute the painter callback
  }

  @override
  TransformLayer? pushTransform(
    bool needsCompositing,
    Offset offset,
    Matrix4 transform,
    void Function(PaintingContext, Offset) painter, {
    TransformLayer? oldLayer,
  }) {
    painter(this, offset); // Execute nested painting
    return null;
  }
}

class DrawRectData {
  final Rect rect;
  final Paint paint;

  DrawRectData(this.rect, this.paint);
}

class MockCanvas extends Fake implements Canvas {
  List<DrawRectData> drawRectCalls = [];
  int drawPictureCalls = 0;

  @override
  void drawRect(Rect rect, Paint paint) =>
      drawRectCalls.add(DrawRectData(rect, paint));

  @override
  void drawPicture(Picture picture) {
    drawPictureCalls++;
  }
}
