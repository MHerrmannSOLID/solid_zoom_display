import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';

import '../test_helpers/test_projector.dart';
import '../test_helpers/test_zoom_controller.dart';

void main() {
  test(
      'Creating a plain display projector '
      '--> should have the size 1,1', () {
    final displayProjector = DisplayProjector();
    expect(displayProjector.size.width, 1);
    expect(displayProjector.size.height, 1);
  });

  test(
      'Setting the zoom controller '
      '--> The DisplayProjector which is the base class of TestProjector '
      'should register the onZoom callback', () {
    final testProjector = TestProjector();
    final testZoomController = TestZoomController();
    testProjector.setZoomController(testZoomController);

    testZoomController.zoomCallback(234.123);
    expect(testProjector.recentZoom, 234.123);
  });
}
