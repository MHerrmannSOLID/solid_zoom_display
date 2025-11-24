import 'package:flutter/material.dart';
import 'package:solid_zoom_display/src/display_canvas/zoom_controller.dart';

class DisplayProjector extends ChangeNotifier{

  ZoomController? _zoomController;

  void copyToContext(Canvas context){}

  Size get size => Size(1,1);

  void onZoom(num zoom){}

  void scaleToFit()=> _zoomController?.scaleToFit();

  void setZoomController(ZoomController zoomController) {
    _zoomController = zoomController;
    _zoomController?.zoomHandler = onZoom;
  }
}