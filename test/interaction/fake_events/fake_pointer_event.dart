import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePointerEvent extends Fake implements PointerEvent {

  FakePointerEvent({
    Offset? position, Offset? localPosition, this.delta = Offset.zero,
    this.buttons = 0, this.kind = PointerDeviceKind.mouse,
  })
      : localPosition = localPosition ?? position ?? Offset.zero,
      position = position ?? localPosition ?? Offset.zero;

  @override
  final PointerDeviceKind kind;

  @override
  final int buttons;

  @override
  final Offset delta;

  @override
  final Offset localPosition;

  @override
  final Offset position;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakePointerEvent';
}
