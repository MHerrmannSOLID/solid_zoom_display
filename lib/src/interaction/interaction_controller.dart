import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/mouse_overlay_behaviour.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';
import 'package:solid_zoom_display/src/types/context_menu_interaction.dart';
import 'package:solid_zoom_display/src/types/point_extensions.dart';

class InteractionController extends ChangeNotifier {
  final ScaleGestureRecognizer _scaleGestureRecognizer;
  final DoubleTapGestureRecognizer _dblClickRecognizer;
  final DoubleTapGestureRecognizer _dblTapRecognizer;
  final LongPressGestureRecognizer _longPressTapGestureRecognizer;
  final LongPressGestureRecognizer _longPressClickGestureRecognizer;
  final DisplayMouseInteraction _displayMouseInteraction;
  final DisplayTouchInteraction _displayTouchInteraction;
  final ZoomController zoomController;

  bool _isMouseOnTopOfThisWidget = false;
  final MouseOverlayBehaviour _mouseOverlayBehaviour;
  ContextMenuInteraction _contextMenuInteraction = ContextMenuInteraction();
  MouseEvent _recentMouseEvent = MouseEvent.empty();

  InteractionController(
      {required this.zoomController,
      DeviceGestureSettings? gestureSettings,
      SelectionOverlayProjector? mouseSelectionProjector,
      DisplayMouseInteraction? mouseInteraction,
      DisplayTouchInteraction? touchInteraction})
      : _scaleGestureRecognizer = ScaleGestureRecognizer()
          ..trackpadScrollCausesScale = false
          ..gestureSettings = gestureSettings
          ..dragStartBehavior = DragStartBehavior.start,
        _dblTapRecognizer = DoubleTapGestureRecognizer()
          ..gestureSettings = gestureSettings,
        _dblClickRecognizer = DoubleTapGestureRecognizer()
          ..gestureSettings = gestureSettings,
        _longPressTapGestureRecognizer = LongPressGestureRecognizer()
          ..gestureSettings = gestureSettings,
        _longPressClickGestureRecognizer = LongPressGestureRecognizer()
          ..gestureSettings = gestureSettings,
        _mouseOverlayBehaviour =
            MouseOverlayBehaviour(overlayProjector: mouseSelectionProjector),
        _displayTouchInteraction =
            touchInteraction ?? DisplayTouchInteraction(),
        _displayMouseInteraction =
            mouseInteraction ?? DisplayMouseInteraction() {
    _displayMouseInteraction.interactionController = this;
    _wireGestureEvents();
  }

  set contextMenuInteraction(ContextMenuInteraction? contextMenuInteraction) =>
      _contextMenuInteraction =
          contextMenuInteraction ?? ContextMenuInteraction();

  void showContextMenu() =>
      _contextMenuInteraction.show(this, _recentMouseEvent.global.toOffset());

  void hideContextMenu() => _contextMenuInteraction.hide();

  bool get isContextMenuShown => _contextMenuInteraction.isOpen;

  void startSelection(Point<num> startPosition) =>
      _mouseOverlayBehaviour.startSelectionAt(
          Point<int>(startPosition.x.toInt(), startPosition.y.toInt()));

  Selection stopSelecting(Point<num> position) {
    final displaySelection = _mouseOverlayBehaviour.stopSelection();
    var topLeft = zoomController.asImagePosition(Offset(
        displaySelection.left.toDouble(), displaySelection.top.toDouble()));
    var bottomRight = zoomController.asImagePosition(Offset(
        displaySelection.right.toDouble(), displaySelection.bottom.toDouble()));
    var imgSelection = Rectangle.fromPoints(topLeft, bottomRight);
    return Selection(display: displaySelection, image: imgSelection);
  }

  void setSelectionOverlayRepaintCallback(
      VoidCallback onSelectionOverlayChanged) {
    _mouseOverlayBehaviour.addListener(onSelectionOverlayChanged);
  }

  void drawMouseBehaviourOverlay(Canvas canvas, Offset offset) =>
      _mouseOverlayBehaviour.selectionOverlayProjector
          .drawSelectionOverlay(canvas, offset);

  void _wireGestureEvents() {
    _scaleGestureRecognizer.onStart = (event) => handleScaleStart(event);
    _scaleGestureRecognizer.onEnd = (event) => handleScaleStop(event);
    _scaleGestureRecognizer.onUpdate = (event) => handleScaleUpdate(event);
    _dblTapRecognizer.onDoubleTapDown = (event) => handleDoubleTapDown(event);
    _dblClickRecognizer.onDoubleTapDown =
        (event) => handleDoubleClickDown(event);
    _longPressClickGestureRecognizer.onLongPressStart =
        (event) => _handleLongPointerDown(event);
    _longPressTapGestureRecognizer.onLongPressStart =
        (event) => _handleLongTapDown(event);
  }

  Point _getImgPos(Offset localPosition) =>
      zoomController.asImagePosition(localPosition);

  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) _handlePointerDown(event);
    if (event is PointerMoveEvent) {
      _onPointerMove(
          MouseEvent.fromPointerEvent(event, _getImgPos(event.localPosition)));
    }
    if (event is PointerSignalEvent) _handlePointerSignal(event);
    if (event is PointerUpEvent) _handlePointerUp(event);
    if (event is PointerHoverEvent) {
      _handleMouseHover(
          MouseEvent.fromPointerEvent(event, _getImgPos(event.localPosition)));
    }
    if (event is PointerPanZoomStartEvent) _handlePointerPanZoomStart(event);
  }

  void _handlePointerDown(PointerDownEvent event) {
    _scaleGestureRecognizer.addPointer(event);
    final imgPos = _getImgPos(event.localPosition);

    _handleOnMouseDown(event, imgPos);
    _handleOnTouchStart(event, imgPos);
  }

  void _handleOnMouseDown(PointerDownEvent event, Point<num> imgPos) {
    if (!_isMouseEvent(event)) return;
    _dblClickRecognizer.addPointer(event);
    _longPressClickGestureRecognizer.addPointer(event);
    _handleMouseDown(MouseEvent.fromPointerEvent(event, imgPos));
  }

  void _handleOnTouchStart(PointerDownEvent event, Point<num> imgPos) {
    if (!_isTouchEvent(event)) return;
    _dblTapRecognizer.addPointer(event);
    _longPressTapGestureRecognizer.addPointer(event);
    _displayTouchInteraction
        .onTouchStart(TouchEvent.fromPointerEvent(event, imgPos));
  }

  void _handleMouseDown(MouseEvent event) {
    if (!_isMouseOnTopOfThisWidget) return;
    _displayMouseInteraction.onMouseDown(event);
  }

  void _handlePointerPanZoomStart(PointerPanZoomStartEvent event) {
    _dblTapRecognizer.addPointerPanZoom(event);
    _dblClickRecognizer.addPointerPanZoom(event);
    _scaleGestureRecognizer.addPointerPanZoom(event);
    _longPressClickGestureRecognizer.addPointerPanZoom(event);
    _longPressTapGestureRecognizer.addPointerPanZoom(event);
  }

  void _handleLongPointerDown(LongPressStartDetails event) {
    final imgPos = _getImgPos(event.localPosition);
    _displayMouseInteraction
        .onLongClick(MouseEvent.fromTapEvent(event, imgPos));
  }

  void _handleLongTapDown(LongPressStartDetails event) {
    final imgPos = _getImgPos(event.localPosition);
    _displayTouchInteraction.onLongTap(TouchEvent.fromTapEvent(event, imgPos));
  }

  void _onPointerMove(MouseEvent event) {
    _handleMouseMove(event);
  }

  void _handleMouseMove(MouseEvent event) {
    _displayMouseInteraction.onMouseMove(event);
    if (_mouseOverlayBehaviour.onMouseMovedTo(event.client)) notifyListeners();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!_isMouseOnTopOfThisWidget || event is! PointerScrollEvent) return;
    _displayMouseInteraction.onMouseScroll(
        MouseEvent.fromScrollEvent(event, _getImgPos(event.localPosition)));
  }

  void _handlePointerUp(PointerUpEvent event) {
    var imagePos = _getImgPos(event.localPosition);
    _handleMouseUp(event, imagePos);
    _handleTouchUp(event, imagePos);
  }

  void _handleTouchUp(PointerUpEvent event, Point<num> imagePos) {
    if (!_isTouchEvent(event)) return;
    _displayTouchInteraction
        .onTouchEnd(TouchEvent.fromPointerEvent(event, imagePos));
  }

  void _handleMouseUp(PointerUpEvent event, Point<num> imagePos) {
    if (!_isMouseEvent(event)) return;
    _displayMouseInteraction
        .onMouseUp(MouseEvent.fromPointerEvent(event, imagePos));
  }

  void _handleMouseHover(MouseEvent event) {
    if (!_isMouseOnTopOfThisWidget) return;
    _recentMouseEvent = event;
    _handleMouseMove(event);
  }

  void handleScaleStart(ScaleStartDetails details) {
    if (_isMouseOnTopOfThisWidget) return;
    _displayTouchInteraction.onScaleStart(TouchEvent.fromScaleStart(details));
  }

  void handleScaleStop(ScaleEndDetails details) {
    if (_isMouseOnTopOfThisWidget) return;
    _displayTouchInteraction.onScaleEnd(TouchEvent.fromScaleStop(details));
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isMouseOnTopOfThisWidget) return;
    var imagePos = _getImgPos(details.localFocalPoint);
    _displayTouchInteraction
        .onScaleUpdate(TouchEvent.fromScaleUpdate(details, imagePos));
    _displayTouchInteraction
        .onTouchMove(TouchEvent.fromScaleUpdate(details, imagePos));
  }

  void handleDoubleTapDown(TapDownDetails details) {
    var imagePos = _getImgPos(details.localPosition);
    _displayTouchInteraction
        .onDoubleTap(TouchEvent.fromTapEvent(details, imagePos));
  }

  void handleDoubleClickDown(TapDownDetails details) {
    var imagePos = _getImgPos(details.localPosition);
    _displayMouseInteraction
        .onDoubleClick(MouseEvent.fromTapEvent(details, imagePos));
  }

  bool _isMouseEvent(PointerEvent event) =>
      event.kind == PointerDeviceKind.mouse && _isMouseOnTopOfThisWidget;
  bool _isTouchEvent(PointerEvent event) =>
      event.kind == PointerDeviceKind.touch;

  void handleMouseEnter(PointerEnterEvent event) {
    _isMouseOnTopOfThisWidget = true;
  }

  void handleMouseExit(PointerExitEvent event) {
    if (!_isMouseOnTopOfThisWidget) return;
  }

  @override
  void dispose() {
    _scaleGestureRecognizer.dispose();
    _dblClickRecognizer.dispose();
    _dblTapRecognizer.dispose();
    _longPressTapGestureRecognizer.dispose();
    _longPressClickGestureRecognizer.dispose();
    super.dispose();
  }
}
