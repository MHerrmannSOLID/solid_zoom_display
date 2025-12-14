import 'package:solid_zoom_display/solid_zoom_display.dart';

class SampleMouseInteraction implements DisplayMouseInteraction {
  static const int rightMouseButton = 2;
  static const int leftMouseButton = 1;
  static const int middleMouseButton = 4;
  InteractionController? _zoomPanel;
  bool _isPanning = false;
  bool _isSelecting = false;

  SampleMouseInteraction();

  @override
  set interactionController(InteractionController value) => _zoomPanel = value;

  @override
  void onMouseDown(MouseEvent event) {
    var mouseEvt = event;
    if (mouseEvt.button == rightMouseButton)
      _zoomPanel?.zoomController.scaleToFit();
    if (mouseEvt.button == leftMouseButton)
      _isPanning = _canStartPanning(mouseEvt);
    if (_canStartSelection(mouseEvt)) _startSelection(mouseEvt);
  }

  void _startSelection(MouseEvent mouseEvt) {
    _isSelecting = true;
    _zoomPanel?.startSelection(mouseEvt.global);
  }

  bool _canStartSelection(MouseEvent event) =>
      event.button == middleMouseButton && !_isPanning && !_isSelecting;

  bool _canStartPanning(MouseEvent event) =>
      event.button == leftMouseButton && !_isPanning && !_isSelecting;

  @override
  void onMouseMove(MouseEvent event) {
    var mouseEvt = event;

    _tryHandlePanning(mouseEvt);
  }

  @override
  void onMouseScroll(MouseEvent event) {
    var delta = event.ctrlKey ? (event.deltaY * 20).toInt() : event.deltaY;
    _zoomPanel?.zoomController
        .scaleAbout(delta: delta, mousePosition: event.client);
  }

  void _stopAnyInteraction(MouseEvent event) {
    _isPanning = false;
    if (_isSelecting) _stopSelecting(event);
  }

  bool _hasActiveInteraction() => _isPanning || _isSelecting;

  @override
  void onMouseUp(MouseEvent event) {
    if (!_hasActiveInteraction()) return;
    _stopAnyInteraction(event);
  }

  bool _tryHandlePanning(MouseEvent mouseEvt) {
    if (!_isPanning) return false;
    _zoomPanel?.zoomController.panImageAbout(mouseEvt.movement);
    return true;
  }

  void _stopSelecting(MouseEvent mouseEvt) {
    _isSelecting = false;
    var selection = _zoomPanel?.stopSelecting(mouseEvt.global);
    if (selection == null) return;
    if (selection.display.width > 0 && selection.display.height > 0)
      _zoomPanel?.zoomController.boxZoomTo(selection.display);
  }
}
