import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';

void main() {
  group('CanvasWidgetRenderer layout mutation bug tests', () {
    testWidgets(
      'Projector that notifies listeners during zoom controller reLayout '
      '--> Should NOT throw "mutated in its own performLayout" exception',
      (WidgetTester tester) async {
        // Arrange: Create a projector that notifies when onZoom is called
        final projector = ProjectorThatNotifiesOnZoom();

        // Act: Build the widget - this will trigger performLayout -> reLayout -> onZoom -> notifyListeners
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasWidget(
                projector: projector,
                vsync: tester,
                backgroundPaint: Paint()..color = Colors.white,
              ),
            ),
          ),
        );

        // This pump should NOT throw the "mutated in its own performLayout" exception
        await tester.pump();

        // Assert: If we get here without exception, the test passes
        expect(find.byType(CanvasWidget), findsOneWidget);
        expect(projector.onZoomCalled, isTrue);
      },
    );

    testWidgets(
      'Multiple layout passes with notifying projector '
      '--> Should handle all layouts without exception',
      (WidgetTester tester) async {
        final projector = ProjectorThatNotifiesOnZoom();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasWidget(
                projector: projector,
                vsync: tester,
                backgroundPaint: Paint()..color = Colors.white,
              ),
            ),
          ),
        );

        // Multiple pumps to ensure stability
        await tester.pump();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(CanvasWidget), findsOneWidget);
        expect(projector.onZoomCalled, isTrue);
      },
    );

    testWidgets(
      'Resizing canvas with notifying projector '
      '--> Should trigger new layout without mutation exception',
      (WidgetTester tester) async {
        final projector = ProjectorThatNotifiesOnZoom();

        // Initial size
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 300,
                child: CanvasWidget(
                  projector: projector,
                  vsync: tester,
                  backgroundPaint: Paint()..color = Colors.white,
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Change size - this triggers new layout
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800,
                height: 600,
                child: CanvasWidget(
                  projector: projector,
                  vsync: tester,
                  backgroundPaint: Paint()..color = Colors.white,
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(CanvasWidget), findsOneWidget);

        final renderObject = tester.renderObject<RenderBox>(
          find.byType(CanvasWidget),
        );
        expect(renderObject.size.width, equals(800));
        expect(renderObject.size.height, equals(600));
      },
    );
  });
}

/// Mock projector that mimics SiteLayoutProjector behavior:
/// - Implements onZoom callback
/// - Notifies listeners when onZoom is called (simulating what happens during reLayout)
class ProjectorThatNotifiesOnZoom extends ChangeNotifier
    implements DisplayProjector {
  Size _size = const Size(1000, 800);
  bool onZoomCalled = false;
  ZoomController? _zoomController;

  @override
  Size get size => _size;

  @override
  void copyToContext(Canvas canvas) {
    // Simple drawing
    canvas.drawRect(
      Rect.fromLTWH(0, 0, _size.width, _size.height),
      Paint()..color = Colors.blue,
    );
  }

  @override
  void setZoomController(ZoomController controller) {
    _zoomController = controller;
    // Add listener to zoom controller like SiteLayoutProjector does
    _zoomController?.addListener(onZoom_x);
  }

  /// This mimics SiteLayoutProjector.onZoom() which calls notifyListeners()
  void onZoom_x() {
    onZoomCalled = true;
    // This is what causes the bug: notifying during layout
    notifyListeners();
  }

  @override
  void scaleToFit() {
    // TODO: implement scaleToFit
  }

  @override
  void onZoom(num zoom) {
    // TODO: implement onZoom
  }
}
