import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import '../test_helpers/helpers.dart';
import '../test_helpers/test_interaction_controller.dart';
import '../test_helpers/test_projector.dart';
import '../test_helpers/test_zoom_controller.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

void main() {

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Should register as listener on the supplied projector', (WidgetTester tester) async {
      final testProjector = TestProjector();
      await tester.pumpWidget(createCanvasWidget(projector: testProjector));

      // the test project should have one listener now
      expect(testProjector.Listeners.length, 1);
    });

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Should execute the projector during construction', (WidgetTester tester) async {
      final testProjector = TestProjector();
      await tester.pumpWidget(createCanvasWidget(projector: testProjector));

      // the test project should have one listener now
      expect(testProjector.copyToContextCalls, 1);
    });

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Should execute the projector during construction', (WidgetTester tester) async {
      final testProjector = TestProjector();
      await tester.pumpWidget(createCanvasWidget(projector: testProjector));

      // the test project should have one listener now
      expect(testProjector.copyToContextCalls, 1);
    });

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Should register as listener on the ZoomController', (WidgetTester tester) async {
      final testProjector = TestProjector();
      final testZoomController = TestZoomController();
      await tester.pumpWidget(
          createCanvasWidget(projector: testProjector, zoomController: testZoomController));

      // the test project should have one listener now
      expect(testZoomController.Listeners.length, 1);
    });

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Should supply a overlay repaint callback on creation', (WidgetTester tester) async {
      final testInteractionController = TestInteractionController();
      await tester.pumpWidget(createCanvasWidget(interactionController: testInteractionController));
      expect(testInteractionController.setSelectionOverlayRepaintCallbackCalled, true);
    });

    testWidgets(
        'Pumping a CanvasWidget '
        '--> Expecting that the onZoom callback gets connected correctly',
        (WidgetTester tester) async {
      final testProjector = TestProjector();
      final testZoomController = TestZoomController();
      await tester.pumpWidget(createCanvasWidget(
        projector: testProjector,
        zoomController: testZoomController,
      ));

      expect(testProjector.recentZoomController, testZoomController);
    });

    testWidgets(
        'Reassigning the projector '
        '--> Expecting that the onZoom callback gets connected correctly',
        (WidgetTester tester) async {
      final testProjector = TestProjector();
      final testZoomController = TestZoomController();
      var canvasWidget = createCanvasWidget(
        zoomController: testZoomController,
      );
      StateSetter setter = (fn) {};
      await tester.pumpWidget(StatefulBuilder(builder: (context, setState) {
        setter = setState;
        return canvasWidget;
      }));
      canvasWidget = createCanvasWidget(
        projector: testProjector,
        zoomController: testZoomController,
      );
      await tester.pumpAndSettle(); // here we trigger "updateRenderObject" on the widget
      setter(() {});

      await tester.pumpAndSettle();
      expect(testProjector.recentZoomController, testZoomController);
    });

    testWidgets(
        'Reassigning the projector '
        '--> listener should be removed from the old projector', (WidgetTester tester) async {
      final firstProjector = TestProjector();
      final secondProjector = TestProjector();
      final testZoomController = TestZoomController();
      var canvasWidget = createCanvasWidget(
        zoomController: testZoomController,
        projector: firstProjector,
      );
      StateSetter setter = (fn) {};
      await tester.pumpWidget(StatefulBuilder(builder: (context, setState) {
        setter = setState;
        return canvasWidget;
      }));

      //first call comes on widget creation
      expect(firstProjector.copyToContextCalls, 1);

      firstProjector.triggerNotification();

      //second call comes on notification
      expect(firstProjector.copyToContextCalls, 2);

      // for the second projector we had no call, yet.
      expect(secondProjector.copyToContextCalls, 0);

      // here we create a new widget with a new projector
      canvasWidget = createCanvasWidget(
        projector: secondProjector,
        zoomController: testZoomController,
      );
      await tester.pumpAndSettle(); // here we trigger "updateRenderObject" on the widget
      //this will trigger the setState and therefore a rebuild of the widget tree.
      // Flutter will exchange the canvas widget with the new one and the
      // 'updateRenderObject' will be called on the widget
      setter(() {});

      await tester.pumpAndSettle();

      // since we assigned the second projector, we expect that the copy to context
      // was called once on assignment
      expect(secondProjector.copyToContextCalls, 1);
      // for the first projector it should remain as is (2 calls)
      expect(firstProjector.copyToContextCalls, 2);

      // a trigger on one should not change anything
      firstProjector.triggerNotification();
      expect(secondProjector.copyToContextCalls, 1);
      expect(firstProjector.copyToContextCalls, 2);

      // a trigger on the second projector should raise the calls on the second projector
      // an one remains unchanged
      secondProjector.triggerNotification();
      expect(secondProjector.copyToContextCalls, 2);
      expect(firstProjector.copyToContextCalls, 2);
    });

    testWidgets(
        'Triggering a notification from the projector '
        '--> should trigger a relayout on the zoom controller', (WidgetTester tester) async {
      final testProjector = TestProjector();
      final testZoomController = TestZoomController();
      await tester.pumpWidget(
        createCanvasWidget(
          projector: testProjector,
          zoomController: testZoomController,
        ),
      );

      // calls relayout on creation of the widget
      expect(testZoomController.reLayoutCallCount, 1);

      testProjector.triggerNotification();
      await tester.pump();

      expect(testZoomController.reLayoutCallCount, 2);
    });

    testWidgets(
        'Submitting a external overlay projector though the constructor '
        '--> The projector should be called on simulated selection', (WidgetTester tester) async {
      final testProjector = TestProjector();

      final dummyOverlayProjector = DummyOverlayProjector();
      await tester.pumpWidget(
        createCanvasWidget(
          projector: testProjector,
          mouseInteraction: DummyMouseInteraction(),
          selectionProjector: dummyOverlayProjector,
        ),
      );

      expect(dummyOverlayProjector.repaintCalled, true);

    });
}

class DummyMouseInteraction extends DisplayMouseInteraction {
  @override
  set interactionController(InteractionController value) {
    value.startSelection(const Point(100, 100));
  }
}

class DummyOverlayProjector extends SelectionOverlayProjector {

  bool repaintCalled = false;

  @override
  void drawSelectionOverlay(Canvas context, Offset ofs) {
    repaintCalled = true;
  }
}
