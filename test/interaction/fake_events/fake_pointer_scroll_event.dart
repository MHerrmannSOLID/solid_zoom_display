import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'fake_pointer_event.dart';

class FakePointerScrollEvent extends FakePointerEvent implements PointerScrollEvent{

  FakePointerScrollEvent({super.delta,super.localPosition, super.position, super.buttons});

  @override
  final Offset scrollDelta = Offset.zero;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakePointerScrollEvent';
}