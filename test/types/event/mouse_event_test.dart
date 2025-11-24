import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/types/event/mouse_event.dart';

import 'test_pointer_event.dart';
import 'test_scroll_event.dart';

void main() {
  test(
      'Creation from fromPointerEvent '
      '--> Converts PointerEvent correctly', () {
    var pointerData = const TestPointerEvent(
        timeStamp: Duration.zero,
        pointer: 1,
        position: Offset(1, 2),
        delta: Offset(3, 4),
        buttons: 5);

    final mouseEvent = MouseEvent.fromPointerEvent(pointerData, const Point(1, 2));

    expect(mouseEvent.client.x, 1);
    expect(mouseEvent.client.y, 2);
    expect(mouseEvent.movement.x, 3);
    expect(mouseEvent.movement.y, 4);
    expect(mouseEvent.global.x, 1);
    expect(mouseEvent.global.y, 2);
    expect(mouseEvent.deltaX, 0);
    expect(mouseEvent.deltaY, 0);
    expect(mouseEvent.button, 5);
  });

  test(
      'Creation from fromScrollEvent '
      '--> Converts ScaleUpdateDetails correctly', () {
    var pointerData = TestScrollEvent(
        buttons: 2,
        delta: Offset(2, 3),
        position: Offset(1, 5),
        localPosition: Offset(1, 5),
        scrollDelta: Offset(33, 2));

    final mouseEvent = MouseEvent.fromScrollEvent(pointerData, const Point(1, 2));

    expect(mouseEvent.client.x, 1);
    expect(mouseEvent.client.y, 5);
    expect(mouseEvent.movement.x, 2);
    expect(mouseEvent.movement.y, 3);
    expect(mouseEvent.global.x, 1);
    expect(mouseEvent.global.y, 5);
    expect(mouseEvent.deltaX, 33);
    expect(mouseEvent.deltaY, 2);
  });
}
