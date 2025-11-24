import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestScrollEvent extends Fake implements PointerScrollEvent{

  TestScrollEvent({
    required this.buttons,
    required this.localPosition,
    required this.position,
    required this.delta,
    required this.scrollDelta});

  int buttons;
  Offset localPosition;
  Offset position;
  Offset delta;
  Offset scrollDelta;

  @override
  String toString({DiagnosticLevel minLevel=DiagnosticLevel.fine}) {
    return 'TestScrollEvent';
  }
}