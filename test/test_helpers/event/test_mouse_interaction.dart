import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/interaction/display_mouse_interaction.dart';

class TestMouseInteraction implements DisplayMouseInteraction {
  final List<MouseEvent> onMouseDownEventData = <MouseEvent>[];
  final List<MouseEvent> onMouseMoveEventData = <MouseEvent>[];
  final List<MouseEvent> onMouseScrollEventData = <MouseEvent>[];
  final List<MouseEvent> onMouseUpEventData = <MouseEvent>[];
  final List<MouseEvent> onMouseLongClickEventData = <MouseEvent>[];

  InteractionController? _interactionController;

  @override
  void onMouseDown(MouseEvent event) => onMouseDownEventData.add(event);

  @override
  void onMouseMove(MouseEvent event) => onMouseMoveEventData.add(event);

  @override
  void onMouseScroll(MouseEvent event) => onMouseScrollEventData.add(event);

  @override
  void onMouseUp(MouseEvent event) => onMouseUpEventData.add(event);

  @override
  set interactionController(InteractionController? value) =>
      _interactionController = value;

  InteractionController? get interactionController => _interactionController;

  @override
  void onLongClick(MouseEvent event) => onMouseLongClickEventData.add(event);
}
