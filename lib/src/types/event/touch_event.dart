import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/scale.dart';

class TouchEvent {
  factory TouchEvent.fromPointerEvent(PointerEvent event) {
    final clientPos = Point(event.localPosition.dx, event.localPosition.dy);
    final applicationPos = Point(event.position.dx, event.position.dy);
    return TouchEvent._(
        clientPos, applicationPos, const Point(0, 0), double.nan);
  }

  factory TouchEvent.fromScaleUpdate(ScaleUpdateDetails details) {
    final clientPos =
        Point(details.localFocalPoint.dx, details.localFocalPoint.dy);
    final applicationPos = Point(details.focalPoint.dx, details.focalPoint.dy);
    final offset = Point(details.horizontalScale, details.verticalScale);
    return TouchEvent._(clientPos, applicationPos, offset, details.scale);
  }

  factory TouchEvent.fromTapDown(TapDownDetails details) {
    final clientPos = Point(details.localPosition.dx, details.localPosition.dy);
    final applicationPos =
        Point(details.globalPosition.dx, details.globalPosition.dy);
    return TouchEvent._(
        clientPos, applicationPos, const Point(0, 0), double.nan);
  }

  factory TouchEvent.fromScaleStart(ScaleStartDetails details) {
    final clientPos =
        Point(details.localFocalPoint.dx, details.localFocalPoint.dy);
    final applicationPos = Point(details.focalPoint.dx, details.focalPoint.dy);
    return TouchEvent._(
        clientPos, applicationPos, const Point(0, 0), double.nan);
  }

  factory TouchEvent.fromScaleStop(ScaleEndDetails details) {
    const zeroPt = Point(0, 0);
    return TouchEvent._(zeroPt, zeroPt, zeroPt, double.nan);
  }

  final Point<num> _client;
  final Point<num> _global;
  final Point<num> _offset;
  final double _scale;

  TouchEvent._(this._client, this._global, this._offset, this._scale);

  Point<num> get client => _client;

  Point<num> get delta => _offset;

  Point<num> get global => _global;

  double get scale => _scale;
}
