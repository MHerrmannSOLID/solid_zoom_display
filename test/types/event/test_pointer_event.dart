import 'dart:ui';
import 'package:flutter/material.dart';

class TestPointerEvent extends PointerEvent{

  const TestPointerEvent({required super.timeStamp,
    required super.pointer,
    required super.position,
    required super.delta, required super.buttons});


  @override
  PointerEvent transformed(Matrix4? transform) {
    // TODO: implement transformed
    throw UnimplementedError();
  }

  @override
  PointerEvent copyWith({int? viewId,
    Duration? timeStamp,
    int? pointer,
    PointerDeviceKind? kind,
    int? device,
    Offset? position,
    Offset? delta,
    int? buttons,
    bool? obscured,
    double? pressure,
    double? pressureMin,
    double? pressureMax,
    double? distance,
    double? distanceMax,
    double? size,
    double? radiusMajor,
    double? radiusMinor,
    double? radiusMin,
    double? radiusMax,
    double? orientation,
    double? tilt,
    bool? synthesized,
    int? embedderId}) {
    return TestPointerEvent(
      timeStamp: timeStamp ?? this.timeStamp,
      pointer: pointer ?? this.pointer,
      position: position ?? this.position,
      delta: delta ?? this.delta,
      buttons: buttons ?? this.buttons,
    );
  }

}