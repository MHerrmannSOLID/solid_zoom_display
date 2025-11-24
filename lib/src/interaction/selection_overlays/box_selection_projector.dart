import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

class BoxSelectionProjector implements SelectionOverlayProjector{
  Rect _actSelection = Rect.fromLTWH(0, 0, 0, 0);

  void updateSelection(Rectangle actSelection) {
    _actSelection = Rect.fromLTWH(
        actSelection.left.toDouble(), actSelection.top.toDouble(),
        actSelection.width.toDouble(), actSelection.height.toDouble());
  }

  void drawSelectionOverlay(Canvas context, Offset ofs) {
    if(_actSelection.longestSide == 0) return;
    context.drawRect(_actSelection.translate(ofs.dx, ofs.dy), Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill);
    context.drawRect(_actSelection.translate(ofs.dx, ofs.dy), Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke);
  }

  void clearSelection() {
    _actSelection = Rect.fromLTWH(0, 0, 0, 0);
  }
}
