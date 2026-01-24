import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/types/event/touch_event.dart';

class DisplayTouchInteraction {
  const DisplayTouchInteraction();

  void onTouchStart(TouchEvent event) {}
  void onTouchEnd(TouchEvent event) {}
  void onTouchCancel(TouchEvent event) {}
  void onTouchMove(TouchEvent event) {}
  void onScaleUpdate(TouchEvent event) {}
  void onScaleStart(TouchEvent event) {}
  void onScaleEnd(TouchEvent event) {}
  void onDoubleTap(TouchEvent event) {}

  /// provides access to the zoom panel [DisplayController] to perform panning or zooming interactions.
  set interactionController(InteractionController value) {}
}
