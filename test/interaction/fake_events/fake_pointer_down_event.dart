import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_pointer_event.dart';

class FakePointerDownEvent extends FakePointerEvent implements PointerDownEvent {

  FakePointerDownEvent({super.delta,super.localPosition, super.position, super.buttons});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => 'FakePointerDownEvent';

}
