import 'dart:math';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

class SelectionMockCanvas extends Fake implements Canvas{
  Rect get drawingBounds => Rect.fromLTRB(_minX, _minY, _maxX, _maxY);

  double _minX=double.maxFinite;
  double _minY=double.maxFinite;
  double _maxX=0.0;
  double _maxY=0.0;

  bool _isVergin = true;
  bool get isVergin => _isVergin;

  @override
  void drawRect(Rect rect, Paint paint) {
    _isVergin = false;
    _minX = min(rect.left, _minX);
    _minY = min(rect.top, _minY);

    _maxY = max(rect.bottom, _maxY);
    _maxX = max(rect.right, _maxX);
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint){
    _isVergin = false;
    _minX = [p1.dx, p2.dx,_minX].reduce(min);
    _minY = [p1.dy, p2.dy,_minY].reduce(min);
    _maxY = [p1.dy, p2.dy,_maxY].reduce(max);
    _maxX = [p1.dx, p2.dx,_maxX].reduce(max);
  }
}
