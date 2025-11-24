import 'package:flutter/material.dart';
import 'dart:math';
import 'package:solid_zoom_display/src/types/invalid_point.dart';

class ZoomController extends ChangeNotifier {
  double screenFitMargin;
  final num _maxZoom = 50;
  final double _zoomSpeed = 0.001;
  Point imgPosition = Point(0, 0);
  num _zoomFactor = 1;
  Size _widgetScreenSize = Size(1, 1);
  final AnimationController animationController;
  void Function(num zoom) _onZoom =  ((_) {});

  ZoomController({
    this.screenFitMargin = 0.02,
    required this.animationController,
  });

  set zoomHandler(void Function(num zoom) value) =>
      _onZoom = value;

  Size canvasSize = Size(1, 1);

  num get zoomFactor => _zoomFactor;

  set widgetScreenSize(Size value) {
    _widgetScreenSize = value;
  }

  bool get _isHeightDominant {
    var canvasAspectRatio = _widgetScreenSize.width / _widgetScreenSize.height;
    var imgAspectRatio = canvasSize.width / canvasSize.height;
    return canvasAspectRatio > imgAspectRatio;
  }

  num get _canvasImageRatio => _isHeightDominant
      ? (_widgetScreenSize.height * (1 - screenFitMargin)) / (canvasSize.height)
      : (_widgetScreenSize.width * (1 - screenFitMargin)) / (canvasSize.width);

  Point<num> _getInitialPosition() {
    var imgHeight = canvasSize.height * _canvasImageRatio;
    var imgWidth = canvasSize.width * _canvasImageRatio;
    return Point(
        (_widgetScreenSize.width - imgWidth) / 2.0, (_widgetScreenSize.height - imgHeight) / 2.0);
  }

  void repLayout() {
    _zoomFactor = _canvasImageRatio;
    imgPosition = _getInitialPosition();
    _onZoom(_zoomFactor);
    notifyListeners();
  }

  void _doZoomAnimation(
      Point<num> actImgPosition, num actZoomFactor, Point<num> newImgPosition, num newZoomFactor) {
    var deltaZoom = newZoomFactor - actZoomFactor;
    var deltaX = newImgPosition.x - actImgPosition.x;
    var deltaY = newImgPosition.y - actImgPosition.y;
    animationController.addListener(() {
      _zoomFactor = animationController.value * deltaZoom + actZoomFactor;
      _onZoom(_zoomFactor);
      imgPosition = Point<num>(animationController.value * deltaX + actImgPosition.x,
          animationController.value * deltaY + actImgPosition.y);
      notifyListeners();
    });
    animationController.forward(from: 0).whenComplete(
        animationController.clearListeners,);
  }

  void scaleToFit() =>
    _doZoomAnimation(imgPosition, _zoomFactor, _getInitialPosition(), _canvasImageRatio);


  void panImageAbout(Point<num> relativeMovement) {
    var deltaX = relativeMovement.x;
    var deltaY = relativeMovement.y;

    imgPosition = Point(imgPosition.x + deltaX, imgPosition.y + deltaY);
    notifyListeners();
  }

  Point<num> asImagePosition(Offset offset) {
    if (imgPosition.x.isNaN || imgPosition.y.isNaN) return Point(0, 0);
    var cursorXPosInImg = (offset.dx - imgPosition.x) / _zoomFactor;
    var cursorYPosInImg = (offset.dy - imgPosition.y) / _zoomFactor;
    return Point(cursorXPosInImg.floor(), cursorYPosInImg.floor());
  }

  void scaleAbout({required int delta, required Point mousePosition}) {
    if (mousePosition is InvalidPoint) return;

    var oldZoomFactor = _zoomFactor;

    _zoomFactor *= (1 + (delta * -_zoomSpeed));
    _zoomFactor =
        _zoomFactor.clamp(min(_canvasImageRatio, _maxZoom).toDouble(), _maxZoom.toDouble());

    var cursorXPosInImg = mousePosition.x - imgPosition.x;
    var cursorYPosInImg = mousePosition.y - imgPosition.y;
    var deltaX = ((cursorXPosInImg / oldZoomFactor * _zoomFactor) - cursorXPosInImg);
    var deltaY = ((cursorYPosInImg / oldZoomFactor * _zoomFactor) - cursorYPosInImg);
    imgPosition = Point(imgPosition.x - deltaX, imgPosition.y - deltaY);

    _onZoom(_zoomFactor);
    notifyListeners();
  }

  Offset _toOffset(Point<num> point) => Offset(point.x.toDouble(), point.y.toDouble());

  void boxZoomTo(Rectangle<num> selection) {
    var canvasAspectRatio = _widgetScreenSize.width / _widgetScreenSize.height;
    var selectionAspectRatio = selection.width / selection.height;
    var imgTopLeft = asImagePosition(_toOffset(selection.topLeft));
    var imgBottomRight = asImagePosition(_toOffset(selection.bottomRight));
    var isWidthDominant = (canvasAspectRatio < selectionAspectRatio);

    var newZoomFactor = isWidthDominant
        ? _widgetScreenSize.width / (imgBottomRight.x - imgTopLeft.x)
        : _widgetScreenSize.height / (imgBottomRight.y - imgTopLeft.y);
    newZoomFactor = newZoomFactor
        .clamp(min(_canvasImageRatio, _maxZoom).toDouble(), _maxZoom.toDouble())
        .toDouble();
    var newImgPosition = _calculateBoxPosition(selection, newZoomFactor, isWidthDominant);

    _doZoomAnimation(imgPosition, _zoomFactor, newImgPosition, newZoomFactor);
  }

  Point<num> _calculateBoxPosition(
      Rectangle<num> selection, num newZoomFactor, bool isWidthDominant) {
    var clientZoomFactor = isWidthDominant
        ? _widgetScreenSize.width / selection.width
        : _widgetScreenSize.height / selection.height;
    var leftSpacing =
        (_widgetScreenSize.width - selection.width * clientZoomFactor) * 0.5 / clientZoomFactor;
    var topSpacing =
        (_widgetScreenSize.height - selection.height * clientZoomFactor) * 0.5 / clientZoomFactor;

    var topLeftPosition = Point<num>(selection.left - leftSpacing, selection.top - topSpacing);

    var imgTopLeft = asImagePosition(_toOffset(topLeftPosition));
    ;
    return Point(-imgTopLeft.x * newZoomFactor, -imgTopLeft.y * newZoomFactor);
  }

  void reLayout(Size widgetSize, Size projectorSize) {
    if(widgetSize == _widgetScreenSize && projectorSize == canvasSize) return;
    widgetScreenSize = widgetSize;
    canvasSize = projectorSize;
    repLayout();
  }

  Offset get zoomOffset => Offset(imgPosition.x.toDouble(), imgPosition.y.toDouble());
}
