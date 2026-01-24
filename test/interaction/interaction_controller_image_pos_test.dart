import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import '../test_helpers/test_selection_overlay_projector.dart';
import '../test_helpers/test_zoom_controller.dart';
import 'fake_events/fake_pointer_enter_event.dart';
import 'fake_events/fake_pointer_hover_event.dart';
import 'fake_events/fake_pointer_move_event.dart';
import 'fake_events/fake_pointer_scroll_event.dart';
import 'fake_events/fake_pointer_up_event.dart';

Point<num> rndPoint() =>
    Point<num>(Random().nextInt(100), Random().nextInt(100));

void _genericPointerEventImageTranslationTest<TEvent extends PointerEvent>(
    TEvent evt) {
  final testSelectionOverlayProjector = TestSelectionOverlayProjector();
  final testMouseInteraction = MouseInteractionMock();
  final testImgPos = rndPoint();
  final stubZoomCtrl = _getFixedImagePosZoomControllerFake(testImgPos);

  final interactionController = InteractionController(
    mouseInteraction: testMouseInteraction,
    mouseSelectionProjector: testSelectionOverlayProjector,
    zoomController: stubZoomCtrl,
  );

  interactionController
    ..handleMouseEnter(FakePointerEnterEvent())
    ..handleEvent(evt);

  expect(testMouseInteraction.recentMouseEvent?.image.x, testImgPos.x);
  expect(testMouseInteraction.recentMouseEvent?.image.y, testImgPos.y);
}

// creating a fake zoom controller which always return a fixed (random) coordinate
// when ask to transform a point from the display to the image
ZoomController _getFixedImagePosZoomControllerFake(Point<num> returnImgPos) {
  return TestZoomController()
    ..imagePosOffset =
        Offset(returnImgPos.x.toDouble(), returnImgPos.y.toDouble());
}

void main() {
  test(
      'Triggering a pointer hover event '
      '--> Should request the image transformation from the zoom controller',
      () => _genericPointerEventImageTranslationTest(FakePointerHoverEvent()));

  test(
      'Triggering a pointer move event '
      '--> Should request the image transformation from the zoom controller',
      () => _genericPointerEventImageTranslationTest(FakePointerMoveEvent()));

  // TODO: DoubleTapGestureRecognizer (in InteractionController:_handlePointerDown:76)
  //  causes problem for this paticular test
  // test('Triggering a pointer down event '
  //     '--> Should request the image transformation from the zoom controller',
  //         () => _genericPointerEventImageTranslationTest(PointerDownEvent()));

  test(
      'Triggering a pointer scroll event '
      '--> Should request the image transformation from the zoom controller',
      () => _genericPointerEventImageTranslationTest(FakePointerScrollEvent()));

  test(
      'Triggering a pointer up event '
      '--> Should request the image transformation from the zoom controller',
      () => _genericPointerEventImageTranslationTest(FakePointerUpEvent()));
}

class MouseInteractionMock implements DisplayMouseInteraction {
  MouseEvent? _recentMouseEvent;

  MouseEvent? get recentMouseEvent => _recentMouseEvent;

  @override
  set interactionController(InteractionController value) {}

  @override
  void onMouseDown(MouseEvent event) => _recentMouseEvent = event;

  @override
  void onMouseMove(MouseEvent event) => _recentMouseEvent = event;

  @override
  void onMouseScroll(MouseEvent event) => _recentMouseEvent = event;

  @override
  void onMouseUp(MouseEvent event) => _recentMouseEvent = event;

  @override
  void onLongClick(MouseEvent event) => _recentMouseEvent = event;

  @override
  void onDoubleClick(MouseEvent mouseEvent) => _recentMouseEvent = mouseEvent;
}
