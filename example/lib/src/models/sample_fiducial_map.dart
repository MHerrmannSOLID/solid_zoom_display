import 'dart:ui';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import '../projectors/fiducial_painter.dart';

class SampleFiducialMap extends DisplayProjector {
  @override
  void copyToContext(Canvas canvas) {
    var fPainter = FiducialPainter();
    for (int x = 0; x < 70; x++) {
      for (int y = 0; y < 30; y++) {
        var circleCenter = Offset(x.toDouble() * 100, y.toDouble() * 100);
        fPainter.drawFiducial(canvas, circleCenter);
        // var angle = rnd.nextDouble()*2*pi;
        // var color = Color.fromRGBO(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255), 1,);
        // canvas.drawArc(Rect.fromCenter(center: circleCenter, width: 20, height: 20), angle, angle+pi/2,true,  Paint()..color = color);
      }
    }
  }

  @override
  Size get size => Size(7000, 3000);
}
