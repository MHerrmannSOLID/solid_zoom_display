import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/box_selection_projector.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';
import 'package:solid_zoom_display/src/types/context_menu_interaction.dart';

class CanvasWidget extends LeafRenderObjectWidget {
  CanvasWidget({
    required this.projector,
    required this.vsync,
    super.key,
    this.mouseInteraction,
    this.touchInteraction,
    this.interactionController,
    SelectionOverlayProjector? selectionProjector,
    ZoomController? zoomController,
    required this.backgroundPaint,
  })  : _selectionProjector = selectionProjector ?? BoxSelectionProjector(),
        _zoomController = zoomController ??
            ZoomController(
                animationController:
                    AnimationController(vsync: vsync, duration: const Duration(seconds: 2)),
                screenFitMargin: 0.01);

  final Paint backgroundPaint;
  final DisplayProjector projector;
  final DisplayMouseInteraction? mouseInteraction;
  final DisplayTouchInteraction? touchInteraction;
  final TickerProvider vsync;
  final ZoomController _zoomController;
  final InteractionController? interactionController;
  final SelectionOverlayProjector _selectionProjector;
  ContextMenuInteraction? _contextMenuInteraction;

  set contextMenuInteraction(ContextMenuInteraction value) => _contextMenuInteraction = value;

  @override
  RenderObject createRenderObject(BuildContext context) {
    var gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
    return CanvasWidgetRenderer(projector, gestureSettings, mouseInteraction, touchInteraction,
        _selectionProjector, _zoomController, backgroundPaint,
        interactionController: interactionController,
        contextMenuInteraction: _contextMenuInteraction);
  }

  @override
  void updateRenderObject(BuildContext context, covariant CanvasWidgetRenderer renderObject) {
    renderObject.projector = projector;
    renderObject.backgroundPaint = backgroundPaint;
  }
}

class CanvasWidgetRenderer extends RenderProxyBoxWithHitTestBehavior
    implements MouseTrackerAnnotation {
  CanvasWidgetRenderer(
    this._projector,
    DeviceGestureSettings? gestureSettings,
    DisplayMouseInteraction? mouseInteraction,
    DisplayTouchInteraction? touchInteraction,
    SelectionOverlayProjector selectionProjector,
    this._zoomController,
    Paint backgroundPaint, {
    InteractionController? interactionController,
    ContextMenuInteraction? contextMenuInteraction,
  })  : _cursor = MouseCursor.defer,
        _interactionController = interactionController ??
            InteractionController(
                gestureSettings: gestureSettings,
                mouseSelectionProjector: selectionProjector,
                mouseInteraction: mouseInteraction,
                touchInteraction: touchInteraction,
                zoomController: _zoomController) {
    _setNewProjector();
    _zoomController..addListener(markNeedsPaint);
    _interactionController.setSelectionOverlayRepaintCallback(_onSelectionOverlayChanged);
    _interactionController.contextMenuInteraction = contextMenuInteraction;
    super.behavior = HitTestBehavior.translucent;
    mouseInteraction?.interactionController = _interactionController;
    touchInteraction?.interactionController = _interactionController;

    this.backgroundPaint = backgroundPaint;
  }

  void _setNewProjector() {
    _projector.addListener(_updatePicture);
    _projector.setZoomController(_zoomController);
    _updatePicture();
  }

  late Picture _picture;
  late FragmentShader? _shader;
  late Paint _backgroundPaint;
  DisplayProjector _projector;

  set backgroundPaint(Paint value) {
    _backgroundPaint = value;
    _shader = (_backgroundPaint.shader is FragmentShader)?_backgroundPaint.shader as FragmentShader:null;
    markNeedsPaint();
  }

  set projector(DisplayProjector value) {
    if (_projector == value) return;
    _projector.removeListener(_updatePicture);
    _projector = value;
    _setNewProjector();
    _zoomController.scaleToFit();
  }

  void _updatePicture() {
    var pictureRecorder = PictureRecorder();
    var canvas = Canvas(pictureRecorder);
    _projector.copyToContext(canvas);
    _picture = pictureRecorder.endRecording();
    markNeedsLayout();
  }

  final InteractionController _interactionController;
  final ZoomController _zoomController;

  @override
  MouseCursor get cursor => _cursor;
  MouseCursor _cursor;

  set cursor(MouseCursor value) {
    if (_cursor != value) {
      _cursor = value;
      // A repaint is needed in order to trigger a device update of
      // [MouseTracker] so that this new value can be found.
      markNeedsPaint();
    }
  }

  @override
  void performResize() => size = constraints.biggest;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    _interactionController.handleEvent(event);
  }

  @override
  set size(Size value) {
    super.size = value;
  }

  @override
  void performLayout() {
    super.performLayout();
    _zoomController.reLayout(size, _projector.size);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    _zoomController.reLayout(constraints.biggest, _projector.size);
    return constraints.biggest;
  }

  void _onSelectionOverlayChanged() {
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    _paintZoomPanelContent(offset, context);
    _interactionController.drawMouseBehaviourOverlay(context.canvas, offset);
  }

  void _paintZoomPanelContent(Offset offset, PaintingContext context) {
    final trafosScale = Matrix4.identity();
    final zoomOffset = _zoomController.zoomOffset;
    final zoomFactor = _zoomController.zoomFactor;
    final totalOffset = zoomOffset + offset;
    _prepareShaderData(zoomOffset, zoomFactor);
    trafosScale.scale(
      zoomFactor.toDouble(),
      _zoomController.zoomFactor.toDouble(),
    );
    final trafoTranslate = Matrix4.identity()..translate(totalOffset.dx, totalOffset.dy);
    //_backgroundPaint.shader = _shader;
    context.canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, width, height),
        (_shader!=null)? (Paint()..shader = _shader):_backgroundPaint);
    context.clipRectAndPaint(
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height), Clip.hardEdge, paintBounds,
        () {
      context.pushTransform(
        false,
        Offset.zero,
        trafoTranslate,
        (context, offset) => context.pushTransform(
          false,
          Offset.zero,
          trafosScale,
          (context, offset) => context.canvas.drawPicture(_picture),
        ),
      );
    });
  }

  @override
  PointerEnterEventListener? get onEnter => _interactionController.handleMouseEnter;

  @override
  PointerExitEventListener? get onExit => _interactionController.handleMouseExit;

  @override
  bool get validForMouseTracker => true;

  double get height => size.height;

  double get width => size.width;

  void _prepareShaderData(Offset zoomOffset, num zoomFactor) {
    if (_shader == null) return;
    _shader!..setFloat(0, _zoomController.zoomOffset.dx  )
      ..setFloat(1, _zoomController.zoomOffset.dy )
      ..setFloat(2, _zoomController.zoomFactor.toDouble());
  }
}
