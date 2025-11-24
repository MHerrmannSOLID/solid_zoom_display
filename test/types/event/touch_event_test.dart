import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/types/event/touch_event.dart';

void main() {
  test(
      'Creation from fromScaleUpdate '
      '--> Converts ScaleUpdateDetails correctly', () {
    var scaleUpdateDetail = ScaleUpdateDetails(
        focalPoint: Offset(1, 2),
        localFocalPoint: Offset(3, 4),
        horizontalScale: 5,
        verticalScale: 6,
        scale: 7);

    var touchEvent = TouchEvent.fromScaleUpdate(scaleUpdateDetail);

    expect(touchEvent.client.x, 3);
    expect(touchEvent.client.y, 4);
    expect(touchEvent.delta.x, 5);
    expect(touchEvent.delta.y, 6);
    expect(touchEvent.global.x, 1);
    expect(touchEvent.global.y, 2);
    expect(touchEvent.scale, 7);
  });

  test(
      'Creation from fromTapDown '
      '--> Converts TapDownDetails correctly', () {
    var details = TapDownDetails(globalPosition: Offset(1, 2), localPosition: Offset(3, 4));

    var touchEvent = TouchEvent.fromTapDown(details);

    expect(touchEvent.client.x, 3);
    expect(touchEvent.client.y, 4);
    expect(touchEvent.delta.x, 0);
    expect(touchEvent.delta.y, 0);
    expect(touchEvent.global.x, 1);
    expect(touchEvent.global.y, 2);
    expect(touchEvent.scale, isNaN);
  });

  test(
      'Creation from fromScaleStart '
      '--> Converts ScaleStartDetails correctly', () {
    var details = ScaleStartDetails(focalPoint: Offset(1, 2), localFocalPoint: Offset(3, 4));

    var touchEvent = TouchEvent.fromScaleStart(details);

    expect(touchEvent.client.x, 3);
    expect(touchEvent.client.y, 4);
    expect(touchEvent.delta.x, 0);
    expect(touchEvent.delta.y, 0);
    expect(touchEvent.global.x, 1);
    expect(touchEvent.global.y, 2);
    expect(touchEvent.scale, isNaN);
  });

  test(
      'Creation from fromScaleStop '
      '--> Converts ScaleEndDetails correctly', () {
    var details = ScaleEndDetails();

    var touchEvent = TouchEvent.fromScaleStop(details);

    expect(touchEvent.client.x, 0);
    expect(touchEvent.client.y, 0);
    expect(touchEvent.delta.x, 0);
    expect(touchEvent.delta.y, 0);
    expect(touchEvent.global.x, 0);
    expect(touchEvent.global.y, 0);
    expect(touchEvent.scale, isNaN);
  });
}
