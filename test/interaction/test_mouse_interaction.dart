import 'package:solid_zoom_display/solid_zoom_display.dart';

class TestMouseInteraction implements DisplayMouseInteraction {
  MouseEvent? lastMouseMoveCallArgument;
  MouseEvent? lastMouseDownCallArgument;
  MouseEvent? lastMouseScrollCallArgument;
  MouseEvent? lastMouseUpCallArgument;
  MouseEvent? lastMouseLongClickCallArgument;
  MouseEvent? lastDblClickCallArgument;

  @override
  void onMouseMove(MouseEvent event) => lastMouseMoveCallArgument = event;

  @override
  set interactionController(InteractionController value) {
    // TODO: implement interactionController
  }

  @override
  void onMouseDown(MouseEvent event) => lastMouseDownCallArgument = event;

  @override
  void onMouseScroll(MouseEvent event) => lastMouseScrollCallArgument = event;

  @override
  void onMouseUp(MouseEvent event) => lastMouseUpCallArgument = event;

  @override
  void onLongClick(MouseEvent event) => lastMouseLongClickCallArgument = event;

  @override
  void onDoubleClick(MouseEvent mouseEvent) =>
      lastDblClickCallArgument = mouseEvent;
}
