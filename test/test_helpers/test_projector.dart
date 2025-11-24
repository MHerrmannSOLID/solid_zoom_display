import 'dart:ui';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'testable_change_notifier.dart';

class TestProjector extends DisplayProjector with TestableChangeNotifier{

  int _copyToContextCalls= 0;

  num recentZoom=double.nan;

  ZoomController? recentZoomController;

  void triggerNotification()=> notifyListeners();

  @override
  void copyToContext(Canvas context) {
    super.copyToContext(context);
    _copyToContextCalls++;
  }

 @override
  int get copyToContextCalls => _copyToContextCalls;

  @override
  void onZoom(num zoom) {
    super.onZoom(zoom);
    recentZoom = zoom;
  }

  @override
  void setZoomController(ZoomController zoomController) {
    super.setZoomController(zoomController);
    recentZoomController = zoomController;
  }

}