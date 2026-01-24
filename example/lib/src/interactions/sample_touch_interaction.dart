import 'dart:async';
import 'dart:math';
import 'package:solid_zoom_display/solid_zoom_display.dart';

class SampleTouchInteraction extends DisplayTouchInteraction {
  static const double _zoomSpeed = 900.0;

  Point _recentPanPosition = const Point(double.nan, double.nan);
  bool get _isPanning =>
      _recentPanPosition.x.isNaN || _recentPanPosition.y.isNaN;
  Point<num> _recentPanDelta = const Point(0.0, 0.0);
  InteractionController? _zoomPanel;
  double _recentScale = double.nan;
  Timer _panFader = Timer(const Duration(), () {});

  SampleTouchInteraction();

  void _startPanFade(Point<num> speed) {
    double panFadeDuration = 60;
    int repetitions = 0;
    double dX = speed.x / panFadeDuration;
    double dY = speed.y / panFadeDuration;
    _panFader = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (repetitions > panFadeDuration - 1) timer.cancel();
      _zoomPanel?.zoomController.panImageAbout(
          speed - Point<double>(dX * repetitions, dY * repetitions));
      repetitions++;
    });
  }

  @override
  void onTouchStart(TouchEvent event) {
    if (_panFader.isActive) _panFader.cancel();
    _recentPanPosition = event.client;
  }

  @override
  void onTouchEnd(TouchEvent event) {
    _recentPanPosition = Point(double.nan, double.nan);
    _startPanFade(_recentPanDelta);
  }

  @override
  void onTouchCancel(TouchEvent event) {}

  @override
  void onTouchMove(TouchEvent event) {
    if (_isPanning) return;
    _recentPanDelta = event.client - _recentPanPosition;
    _recentPanPosition = event.client;
    _zoomPanel?.zoomController.panImageAbout(_recentPanDelta);
  }

  @override
  void onScaleUpdate(TouchEvent event) {
    var scaleDelta = (_recentScale - event.scale) * _zoomSpeed;
    _recentScale = event.scale;
    _zoomPanel?.zoomController
        .scaleAbout(delta: scaleDelta.toInt(), mousePosition: event.client);
  }

  @override
  void onScaleStart(TouchEvent event) {
    _recentScale = 1.0;
  }

  @override
  void onScaleEnd(TouchEvent event) {
    _recentScale = double.nan;
  }

  @override
  void onDoubleTap(TouchEvent event) {
    _zoomPanel?.zoomController.scaleToFit();
  }

  @override
  void onLongTap(TouchEvent event) {
    print('Long tap at (${event.image.x}|${event.image.y})');
  }

  /// provides access to the zoom panel [ZoomPanel] to perform panning or zooming interactions.
  @override
  set interactionController(InteractionController value) => _zoomPanel = value;
}
