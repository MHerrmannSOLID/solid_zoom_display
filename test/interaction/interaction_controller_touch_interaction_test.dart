import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import '../test_helpers/test_selection_overlay_projector.dart';
import '../test_helpers/test_zoom_controller.dart';
import 'fake_events/fake_pointer_enter_event.dart';
import 'test_touch_interaction.dart';

void main() {
  test(
      'Performing "handleScaleStart" with mouse events enabled (moue entered) '
      '--> Should ignore interaction since mouse is enabled', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleScaleStart(ScaleStartDetails());

    expect(testTouchInteraction.onScaleStartEventData.length, 0);
    expect(testTouchInteraction.onTouchStartEventData.length, 0);
  });

  test(
      'Performing "handleScaleStart" event '
      '--> Should trigger onScaleStartEven', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleScaleStart(ScaleStartDetails(kind: PointerDeviceKind.touch));

    expect(testTouchInteraction.onScaleStartEventData.length, 1);
  });

  test(
      'Performing "handleScaleStop" with mouse events enabled (moue entered) '
      '--> Should ignore interaction since mouse is enabled', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleScaleStop(ScaleEndDetails());

    expect(testTouchInteraction.onScaleEndEventData.length, 0);
    expect(testTouchInteraction.onScaleEndEventData.length, 0);
  });

  test(
      'Performing touch scaling '
      '--> Should trigger both onScaleStartEven and onTouchStartEven', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController..handleScaleStop(ScaleEndDetails());

    expect(testTouchInteraction.onScaleEndEventData.length, 1);
    expect(testTouchInteraction.onScaleEndEventData.length, 1);
  });

  test(
      'Performing "handleScaleUpdate" with mouse events enabled (moue entered) '
      '--> Should ignore interaction since mouse is enabled', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleMouseEnter(FakePointerEnterEvent())
      ..handleScaleUpdate(ScaleUpdateDetails());

    expect(testTouchInteraction.onScaleUpdateEventData.length, 0);
    expect(testTouchInteraction.onTouchMoveEventData.length, 0);
  });

  test(
      'Performing "handleScaleUpdate" event '
      '--> Should trigger both onScaleUpdateEvent and onTouchMoveEvent', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController..handleScaleUpdate(ScaleUpdateDetails());

    expect(testTouchInteraction.onScaleUpdateEventData.length, 1);
    expect(testTouchInteraction.onTouchMoveEventData.length, 1);
  });

  test(
      'Performing "handleDoubleTapDown" event '
      '--> Should trigger onDoubleTapEvent', () {
    final testSelectionOverlayProjector = TestSelectionOverlayProjector();
    final testTouchInteraction = TestTouchInteraction();
    final interactionController = InteractionController(
      touchInteraction: testTouchInteraction,
      mouseSelectionProjector: testSelectionOverlayProjector,
      zoomController: TestZoomController(),
    );

    interactionController
      ..handleDoubleTapDown(TapDownDetails(kind: PointerDeviceKind.touch));

    expect(testTouchInteraction.onDoubleTapEventData.length, 1);
  });
}
