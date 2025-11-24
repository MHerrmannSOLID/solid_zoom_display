import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

class TestSelectionOverlayProjector implements SelectionOverlayProjector {
  final selectionUpdates = <Rectangle<num>>[];
  int clearSelectionCalled = 0;
  bool drawSelectionOverlayCalled = false;

  @override
  void clearSelection() => clearSelectionCalled++;

  @override
  void drawSelectionOverlay(Canvas context, Offset ofs) {
    drawSelectionOverlayCalled = true;
  }

  @override
  void updateSelection(Rectangle<num> actSelection) => selectionUpdates.add(actSelection);
}

