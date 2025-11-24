import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'fake_pointer_event.dart';

class FakePointerHoverEvent extends FakePointerEvent implements PointerHoverEvent{

  FakePointerHoverEvent({super.delta,super.localPosition, super.position, super.buttons});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakePointerHoverEvent';
}

