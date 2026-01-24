import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/mouse_overlay_behaviour.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';
import 'package:solid_zoom_display/src/types/context_menu_interaction.dart';
import 'package:solid_zoom_display/src/types/event/mouse_event.dart';
import 'package:solid_zoom_display/src/types/point_extensions.dart';

class InteractionController extends ChangeNotifier {
  final ScaleGestureRecognizer _scaleGestureRecognizer;

  final DoubleTapGestureRecognizer _dblTapRecognizer;
  bool _hasMouseEvents = false;
  MouseOverlayBehaviour _mouseOverlayBehaviour;

  final DisplayMouseInteraction _displayMouseInteraction;
  final DisplayTouchInteraction _displayTouchInteraction;
  final ZoomController zoomController;
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
  }

  Point _getImgPos(PointerEvent event) =>
      zoomController.asImagePosition(event.localPosition);

  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) _handlePointerDown(event);
    if (event is PointerMoveEvent) {
      _onPointerMove(MouseEvent.fromPointerEvent(event, _getImgPos(event)));
    }
    if (event is PointerSignalEvent) _handlePointerSignal(event);
    if (event is PointerUpEvent) _handleMouseUp(event);
    if (event is PointerHoverEvent) {
      _handleMouseHover(MouseEvent.fromPointerEvent(event, _getImgPos(event)));
    }
    if (event is PointerPanZoomStartEvent) _handlePointerPanZoomStart(event);
  }

  void _handlePointerDown(PointerDownEvent event) {
    _dblTapRecognizer.addPointer(event);
    _scaleGestureRecognizer.addPointer(event);
    final imgPos = _getImgPos(event);
    _handleMouseDown(MouseEvent.fromPointerEvent(event, imgPos));
    _displayTouchInteraction
        .onTouchStart(TouchEvent.fromPointerEvent(event, imgPos));
  }

  void _handleMouseDown(MouseEvent event) {
    if (!_hasMouseEvents) return;
    _displayMouseInteraction.onMouseDown(event);
  }

  void _handlePointerPanZoomStart(PointerPanZoomStartEvent event) {
    _dblTapRecognizer.addPointerPanZoom(event); // do we need this  ????
    _scaleGestureRecognizer.addPointerPanZoom(event);
  }

  void _onPointerMove(MouseEvent event) {
    _handleMouseMove(event);
  }

  void _handleMouseMove(MouseEvent event) {
    _displayMouseInteraction.onMouseMove(event);
    if (_mouseOverlayBehaviour.onMouseMovedTo(event.client)) notifyListeners();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!_hasMouseEvents || event is! PointerScrollEvent) return;
    _displayMouseInteraction
        .onMouseScroll(MouseEvent.fromScrollEvent(event, _getImgPos(event)));
  }

  void _handleMouseUp(PointerUpEvent event) {
    //if (!_hasMouseEvents) return;
    var imagePos = _getImgPos(event);
    _displayMouseInteraction
        .onMouseUp(MouseEvent.fromPointerEvent(event, imagePos));
    _displayTouchInteraction
        .onTouchEnd(TouchEvent.fromPointerEvent(event, imagePos));
  }

  void _handleMouseHover(MouseEvent event) {
    if (!_hasMouseEvents) return;
    _recentMouseEvent = event;
    _handleMouseMove(event);
  }

  void handleScaleStart(ScaleStartDetails details) {
    if (_hasMouseEvents) return;
    _displayTouchInteraction.onScaleStart(TouchEvent.fromScaleStart(details));
    // _displayTouchInteraction.onTouchStart(TouchEvent.fromScaleStart(details));
  }

  void handleScaleStop(ScaleEndDetails details) {
    if (_hasMouseEvents) return;
    _displayTouchInteraction.onScaleEnd(TouchEvent.fromScaleStop(details));
    //_displayTouchInteraction.onTouchEnd(TouchEvent.fromScaleStop(details));
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    if (_hasMouseEvents) return;
    _displayTouchInteraction.onScaleUpdate(TouchEvent.fromScaleUpdate(details));
    _displayTouchInteraction.onTouchMove(TouchEvent.fromScaleUpdate(details));
  }

  void handleDoubleTapDown(TapDownDetails details) {
    if (_hasMouseEvents) return;
    _displayTouchInteraction.onDoubleTap(TouchEvent.fromTapDown(details));
  }

  void handleMouseEnter(PointerEnterEvent event) {
    _hasMouseEvents = true;
  }

  void handleMouseExit(PointerExitEvent event) {
    if (!_hasMouseEvents) return;
  }
}
