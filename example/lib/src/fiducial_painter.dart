import 'dart:ui';

class FiducialPainter{

  double size=50.0;
  double relInnerRectSize = 0.6;
  double relCornerRadius = 0.2;
  final Paint markedColor = Paint()..style=PaintingStyle.fill..strokeWidth=1 ..color = Color.fromRGBO(205, 255, 205, 1);
  final Paint notMarkedColor = Paint()..style=PaintingStyle.fill..strokeWidth=1 ..color = Color.fromRGBO(255, 155, 155, 1);
  final Paint borderPaint = Paint()..style=PaintingStyle.stroke..strokeWidth=1 ..color = Color.fromRGBO(0, 0, 0, 1);
  final Paint orientationCirclePaint = Paint()..style=PaintingStyle.fill..strokeWidth=1 ..color = Color.fromRGBO(0, 0, 0, 1);


  void drawFiducial(Canvas canvas, Offset pos, {bool drawInnerDesign= false,bool isMarked=true}){
    var top = pos.dx-size/2.0;
    var left = pos.dy-size/2.0;
    var fiduacialRect = Rect.fromLTWH(top, left, size, size);
    var cornerRadius = size*relCornerRadius;
    var rRect = RRect.fromRectAndRadius(fiduacialRect, Radius.circular(cornerRadius));
    canvas.drawRRect(rRect , borderPaint);
    canvas.drawRRect(rRect , isMarked?markedColor:notMarkedColor);

    var innerBorderSize =size * (1-relInnerRectSize)/2.0;
    var radius = innerBorderSize*0.6;

    if(drawInnerDesign) _drawInnerDesign(pos, canvas);


    canvas.drawCircle(Offset(top+innerBorderSize,left+innerBorderSize), radius, orientationCirclePaint);
  }

  void _drawInnerDesign(Offset pos, Canvas canvas) {
    var innerRectSize = (size*relInnerRectSize);
    var innerRect = Rect.fromLTWH(pos.dx-innerRectSize/2, pos.dy-innerRectSize/2.0, innerRectSize, innerRectSize);
    canvas.drawRect(innerRect ,borderPaint);


    var c1Rect = Rect.fromLTWH(pos.dx-innerRectSize/2, pos.dy-innerRectSize/2.0+innerRectSize/2.0, innerRectSize/2, innerRectSize/2);
    canvas.drawRect(c1Rect ,orientationCirclePaint);
    var c2Rect = Rect.fromLTWH(pos.dx-innerRectSize/2+innerRectSize/2.0, pos.dy-innerRectSize/2.0, innerRectSize/2, innerRectSize/2);
    canvas.drawRect(c2Rect , orientationCirclePaint);
  }

}
