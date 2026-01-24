import 'dart:math';
import 'package:flutter/gestures.dart';

class MouseEvent {
  const MouseEvent._({
    this.button = 0,
    this.client = const Point<num>(0, 0),
    this.ctrlKey = false,
    this.deltaX = 0,
    this.deltaY = 0,
    this.image = const Point<num>(0, 0),
    this.movement = const Point<num>(0, 0),
    this.global = const Point<num>(0, 0),
  });

  factory MouseEvent.empty() => const MouseEvent._();

  static MouseEvent fromPointerEvent(PointerEvent event, Point imagePos) =>
      MouseEvent._(
        button: event.buttons,
        client: Point<num>(event.localPosition.dx, event.localPosition.dy),
        movement: Point<num>(event.delta.dx, event.delta.dy),
        image: imagePos,
        global: Point<num>(event.position.dx, event.position.dy),
      );

  factory MouseEvent.fromTapEvent(
      PositionedGestureDetails details, Point<num> imagePos) {
    // Gestures are fixed on the primary button (left button)
    // https://api.flutter.dev/flutter/gestures/kPrimaryButton-constant.html
    return MouseEvent._(
      button: kPrimaryButton,
      client: Point<num>(details.localPosition.dx, details.localPosition.dy),
      movement: Point<num>(0, 0),
      image: imagePos,
      global: Point<num>(details.globalPosition.dx, details.globalPosition.dy),
    );
  }

  static MouseEvent fromScrollEvent(PointerScrollEvent event, Point imagePos) =>
      MouseEvent._(
          button: event.buttons,
          client: Point<num>(event.localPosition.dx, event.localPosition.dy),
          movement: Point<num>(event.delta.dx, event.delta.dy),
          global: Point<num>(event.position.dx, event.position.dy),
          image: imagePos,
          deltaX: event.scrollDelta.dx.toInt(),
          deltaY: event.scrollDelta.dy.toInt());

  final int button;

  final Point<num> client;

  final bool ctrlKey;

  final int deltaX;

  final int deltaY;

  final Point<num> movement;

  final Point<num> global;
  final Point<num> image;
}
