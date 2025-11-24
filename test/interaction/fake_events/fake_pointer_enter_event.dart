import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'fake_pointer_event.dart';

class FakePointerEnterEvent extends FakePointerEvent implements PointerEnterEvent {

  FakePointerEnterEvent({super.delta,super.localPosition, super.position, super.buttons});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakePointerEnterEvent';
}