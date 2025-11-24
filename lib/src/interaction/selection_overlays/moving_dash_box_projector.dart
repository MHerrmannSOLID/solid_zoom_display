import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

class MovingDashBoxProjector extends ChangeNotifier implements SelectionOverlayProjector{

  final TickerProvider vsync;
  final AnimationController _animationController;
  Rect _selection = Rect.fromLTWH(0, 0, 0, 0);
  double _dashOffset = 0;
  int _dashSize = 5;


  MovingDashBoxProjector({required this.vsync}):
        _animationController = AnimationController(vsync: vsync, duration: Duration(milliseconds: 500), ){
    _animationController.addListener(_updateProjection);
  }

  @override
  void clearSelection() {
    _animationController.stop();
    _selection = Rect.fromLTWH(0, 0, 0, 0);
  }

  @override
  void drawSelectionOverlay(Canvas canvas, Offset ofs) {
    if(_selection.longestSide == 0) return;
    var selectionWithOffset = _selection.translate(ofs.dx, ofs.dy);
    canvas.drawRect(selectionWithOffset,
        Paint()..color = const Color(0x78787832)..style = PaintingStyle.fill);
        //RenderStyle(strokeStyle: StrokeStyle.none, fillStyle: FillStyle(color: ColorStyle.fromRgbA8888(120, 120, 120, 50))));
    _drawDashedLine(canvas, selectionWithOffset.topLeft, selectionWithOffset.width.toInt(),dashSize: _dashSize, offset: _dashOffset.toInt(), isHorizontal: true);
    var dashOffset =(_dashSize*2)-(selectionWithOffset.width.toInt()%(_dashSize*2))+_dashOffset;
    _drawDashedLine(canvas, selectionWithOffset.topRight, selectionWithOffset.height.toInt() ,dashSize: _dashSize, offset: dashOffset.toInt(), isHorizontal: false);

    dashOffset = (( (  selectionWithOffset.height.toInt() - (2*dashOffset))  %(_dashSize*2)) )+_dashSize+_dashOffset;

    _drawDashedLine(canvas, selectionWithOffset.bottomLeft, selectionWithOffset.width.toInt() ,dashSize:_dashSize, offset: dashOffset.toInt(), isHorizontal: true);

    dashOffset =   selectionWithOffset.height.toInt() %(_dashSize*2)+_dashOffset;
    _drawDashedLine(canvas, selectionWithOffset.topLeft, selectionWithOffset.height.toInt() ,dashSize:_dashSize, offset: dashOffset.toInt(), isHorizontal: false);
  }

  void _drawDashedLine(Canvas canvas,Offset topLeft, int length,
      {int dashSize = 5, int offset = 0, bool isHorizontal = true}) {
    var styles = <Paint>[
      (Paint()..strokeWidth= 1..color = Colors.black..style = PaintingStyle.stroke),
      (Paint()..strokeWidth= 1..color = Colors.white..style = PaintingStyle.stroke),
    ];
    offset = offset%(dashSize*2);
    offset = offset<0?(dashSize*2)-offset:offset;
    var styleIdx = (offset/dashSize).toInt();
    offset %= dashSize;

    int linePos = 0;
    var segSize = min(length, offset);

    while (linePos < length) {

      var stripEnd = isHorizontal
          ? Offset(topLeft.dx + segSize, topLeft.dy)
          : Offset(topLeft.dx, topLeft.dy + segSize);

      var activeStyle = styles[styleIdx%styles.length];

      canvas.drawLine(topLeft, stripEnd, activeStyle);
      topLeft = stripEnd;
      linePos += segSize;
      segSize = linePos+dashSize > length? length-linePos: dashSize;
      styleIdx++;
    }
    //_changeNotifier?.notifyListeners();
  }

  @override
  void updateSelection(Rectangle<num> value) {
    if(!_animationController.isAnimating)_animationController.repeat();
    _selection = Rect.fromLTWH(value.topLeft.x.toDouble(),
        value.topLeft.y.toDouble(),
        value.width.toDouble(),
        value.height.toDouble());
  }



  void _updateProjection() {
    final delta = (1/(_animationController.velocity))*3.4;
    _dashOffset= (_dashOffset+delta)%(_dashSize*2);
    notifyListeners();
  }
}