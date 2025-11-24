import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'test_animation_controller.dart';
import 'testable_change_notifier.dart';

class TestZoomController extends ZoomController with TestableChangeNotifier {
  void Function(num zoom) zoomCallback = (_) {};
  int reLayoutCallCount = 0;
  Offset imagePosOffset = Offset(0, 0);
  Offset imageScaleOffset = Offset(1, 1);

  TestZoomController() : super(animationController: TestAnimationController());

  @override
  Point<num> asImagePosition(Offset offset) => Point(
      offset.dx * imageScaleOffset.dx + imagePosOffset.dx,
      offset.dy * imageScaleOffset.dy + imagePosOffset.dy);

  @override
  set zoomHandler(void Function(num zoom) callback) {
    zoomCallback = callback;
  }

  @override
  void reLayout(Size widgetSize, Size projectorSize) {
    super.reLayout(widgetSize, projectorSize);
    reLayoutCallCount++;
  }
}
