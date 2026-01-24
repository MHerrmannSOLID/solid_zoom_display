import 'package:solid_zoom_display/solid_zoom_display.dart';

class TestTouchInteraction implements DisplayTouchInteraction {
  final List<TouchEvent> onDoubleTapEventData = <TouchEvent>[];
  final List<TouchEvent> onScaleEndEventData = <TouchEvent>[];
  final List<TouchEvent> onScaleStartEventData = <TouchEvent>[];
  final List<TouchEvent> onScaleUpdateEventData = <TouchEvent>[];
  final List<TouchEvent> onTouchCancelEventData = <TouchEvent>[];
  final List<TouchEvent> onTouchEndEventData = <TouchEvent>[];
  final List<TouchEvent> onTouchMoveEventData = <TouchEvent>[];
  final List<TouchEvent> onTouchStartEventData = <TouchEvent>[];
  final List<TouchEvent> onLongTapEventData = <TouchEvent>[];

  @override
  set interactionController(InteractionController value) {}

  @override
  void onDoubleTap(TouchEvent event) => onDoubleTapEventData.add(event);

  @override
  void onScaleEnd(TouchEvent event) => onScaleEndEventData.add(event);

  @override
  void onScaleStart(TouchEvent event) => onScaleStartEventData.add(event);

  @override
  void onScaleUpdate(TouchEvent event) => onScaleUpdateEventData.add(event);

  @override
  void onTouchCancel(TouchEvent event) => onTouchCancelEventData.add(event);

  @override
  void onTouchEnd(TouchEvent event) => onTouchEndEventData.add(event);

  @override
  void onTouchMove(TouchEvent event) => onTouchMoveEventData.add(event);

  @override
  void onTouchStart(TouchEvent event) => onTouchStartEventData.add(event);

  @override
  void onLongTap(TouchEvent event) => onLongTapEventData.add(event);
}
