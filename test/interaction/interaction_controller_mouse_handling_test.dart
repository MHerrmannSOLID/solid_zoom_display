import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import '../test_helpers/event/test_mouse_interaction.dart';
import '../test_helpers/test_selection_overlay_projector.dart';
import '../test_helpers/test_zoom_controller.dart';
import 'fake_events/fake_pointer_enter_event.dart';
import 'fake_events/fake_pointer_hover_event.dart';
import 'fake_events/fake_pointer_move_event.dart';
import 'fake_events/fake_pointer_up_event.dart';

void main() {
  test(
      'Starting/Updating selection of interaction controller '
      '--> Should re-trigger "updateSelection" of mouse overlay behaviour', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..startSelection(Point(100, 110))
      ..handleEvent(FakePointerHoverEvent());

    expect(testSelectionOverlayProjector.selectionUpdates.length, 1);
  });

  test(
      'Starting/Updating selection of interaction controller '
      '--> Should update the overlay with correct size', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..startSelection(Point(100, 110))
      ..handleEvent(FakePointerHoverEvent(position: const Offset(110, 150)));

    expect(testSelectionOverlayProjector.selectionUpdates[0].width, 10);
    expect(testSelectionOverlayProjector.selectionUpdates[0].height, 40);
    expect(testSelectionOverlayProjector.selectionUpdates[0].left, 100);
    expect(testSelectionOverlayProjector.selectionUpdates[0].top, 110);
  });

  test(
      'Triggering selection events when mouse never entered '
      '--> Should not have any selection update since mouse needs to enter '
      'to activate mouse interaction', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..startSelection(Point(100, 110))
      ..handleEvent(FakePointerHoverEvent());

    expect(testSelectionOverlayProjector.selectionUpdates.length, 0);
  });

  test(
      'Sopping selection  of interaction controller '
      '--> Should re-trigger "startSelectionAt" of mouse overlay behaviour', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    )
      ..handleMouseEnter(FakePointerEnterEvent())
      ..startSelection(const Point(100, 110))
      ..handleEvent(FakePointerHoverEvent(position: const Offset(110, 130)))
      ..stopSelecting(Point(200, 220));

    expect(testSelectionOverlayProjector.clearSelectionCalled, 1);
  });

  test(
      'Sopping selection  of interaction controller '
      '--> Should return the last update display position as selection', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    )
      ..handleMouseEnter(FakePointerEnterEvent())
      ..startSelection(const Point(100, 110))
      //last update is here
      ..handleEvent(FakePointerHoverEvent(position: const Offset(110, 130)));

    var selRect = interactionController.stopSelecting(Point(200, 220));

    expect(selRect.display.width, 10);
    expect(selRect.display.height, 20);
    expect(selRect.display.top, 110);
    expect(selRect.display.left, 100);
  });

  test(
      'Sopping selection  of interaction controller '
      '--> Should return the last update image position as selection', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testZoomController = TestZoomController()
      ..imagePosOffset = Offset(10, 20)
      ..imageScaleOffset = Offset(2, 2);
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: testZoomController,
    )
      ..handleMouseEnter(FakePointerEnterEvent())
      ..startSelection(const Point(100, 110))
      //last update is here
      ..handleEvent(FakePointerHoverEvent(position: const Offset(110, 130)));

    var selRect = interactionController.stopSelecting(Point(200, 220));

    expect(selRect.image.width, 10 * 2);
    expect(selRect.image.height, 20 * 2);
    expect(selRect.image.top, 110 * 2 + 20);
    expect(selRect.image.left, 100 * 2 + 10);
  });

  test(
      'Triggering mouse behaviour overlay drawing '
      '--> Should re-trigger "drawSelectionOverlay" of mouse overlay behaviour', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final interactionController = InteractionController(
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController.drawMouseBehaviourOverlay(FakeCanvas(), Offset(10, 20));

    expect(testSelectionOverlayProjector.drawSelectionOverlayCalled, true);
  });

  test(
      'Triggering onPointerMove event '
      '--> Should re-trigger "onMouseMove" on the mouse interaction', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseInteraction: testMouseInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(FakePointerMoveEvent(position: const Offset(10, 20)));

    expect(testMouseInteraction.onMouseMoveEventData.length, 1);
  });

  test(
      'Triggering onPointerMove event '
      '--> Should re-trigger "onMouseMove" on the mouse interaction', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseInteraction: testMouseInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(FakePointerMoveEvent(position: const Offset(10, 20)));

    expect(testMouseInteraction.onMouseMoveEventData.length, 1);
  });

  test(
      'Triggering "handlePointerSignal" '
      '--> Will be redirected to "onMouseScroll" ', () {
    const scrollEvent = PointerScrollEvent(
      timeStamp: Duration(seconds: 1),
      scrollDelta: Offset(10, 20),
      embedderId: 1,
    );
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseSelectionProjector: TestSelectionOverlayProjector(),
      zoomController: TestZoomController(),
      mouseInteraction: testMouseInteraction,
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(scrollEvent);

    expect(testMouseInteraction.onMouseScrollEventData.length, 1);
  });

  test(
      'Triggering "handlePointerSignal" without mouse events active '
      '--> Will not be redirected to "onMouseScroll" ', () {
    const scrollEvent = PointerScrollEvent(
      timeStamp: Duration(seconds: 1),
      scrollDelta: Offset(10, 20),
      embedderId: 1,
    );
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseSelectionProjector: TestSelectionOverlayProjector(),
      zoomController: TestZoomController(),
      mouseInteraction: testMouseInteraction,
    );

    interactionController..handleEvent(scrollEvent);

    expect(testMouseInteraction.onMouseScrollEventData.length, 0);
  });

  test(
      'Triggering "handlePointerSignal" without "PointerScrollEvent" '
      '--> Will not be redirected to "onMouseScroll" ', () {
    const scrollEvent = PointerScaleEvent(
      timeStamp: Duration(seconds: 1),
      embedderId: 1,
    );
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseSelectionProjector: TestSelectionOverlayProjector(),
      zoomController: TestZoomController(),
      mouseInteraction: testMouseInteraction,
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(scrollEvent);

    expect(testMouseInteraction.onMouseScrollEventData.length, 0);
  });

  test(
      'Triggering "handleMouseUp" '
      '--> Should be forwarded to "onMouseUp"', () {
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseSelectionProjector: TestSelectionOverlayProjector(),
      zoomController: TestZoomController(),
      mouseInteraction: testMouseInteraction,
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(FakePointerUpEvent());

    expect(testMouseInteraction.onMouseUpEventData.length, 1);
  });

  test(
      'Triggering "handleMouseUp" with mouse events deactivate (no enter) '
      '--> Should not be forwarded to "onMouseUp"', () {
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseSelectionProjector: TestSelectionOverlayProjector(),
      zoomController: TestZoomController(),
      mouseInteraction: testMouseInteraction,
    );

    interactionController..handleEvent(FakePointerUpEvent());

    expect(testMouseInteraction.onMouseUpEventData.length, 0);
  });

  test(
      'Triggering handleMouseHover event '
      '--> Should re-trigger "onMouseMove" on the mouse interaction', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseInteraction: testMouseInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleEvent(FakePointerHoverEvent());

    expect(testMouseInteraction.onMouseMoveEventData.length, 1);
  });

  test(
      'Triggering handleMouseHover event without mouse events active (no enter) '
      '--> Should re-trigger "onMouseMove" on the mouse interaction', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testMouseInteraction = TestMouseInteraction();
    final interactionController = InteractionController(
      mouseInteraction: testMouseInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController..handleEvent(FakePointerHoverEvent());

    expect(testMouseInteraction.onMouseMoveEventData.length, 0);
  });
}

class FakeCanvas extends Fake implements Canvas {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakeCanvas';
}
