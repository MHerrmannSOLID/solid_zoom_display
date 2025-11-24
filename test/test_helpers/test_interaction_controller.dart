import 'dart:ui';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';
import 'test_selection_overlay_projector.dart';
import 'test_ticker_provider.dart';
import 'test_zoom_controller.dart';

class TestInteractionController extends InteractionController {

  bool _setSelectionOverlayRepaintCallbackCalled = false;
  bool get setSelectionOverlayRepaintCallbackCalled => _setSelectionOverlayRepaintCallbackCalled;

  TestInteractionController ({SelectionOverlayProjector? selectionOverlayProjector,
      DisplayMouseInteraction? mouseInteraction,
      DisplayTouchInteraction? touchInteraction}) :
      super(mouseSelectionProjector:  selectionOverlayProjector ??TestSelectionOverlayProjector(),
          mouseInteraction:  mouseInteraction ?? DisplayMouseInteraction(),
          touchInteraction:  touchInteraction ?? DisplayTouchInteraction(),
          zoomController: TestZoomController( )
      );


  @override
  void setSelectionOverlayRepaintCallback(VoidCallback repaintCallback) {
    super.setSelectionOverlayRepaintCallback(repaintCallback);
    _setSelectionOverlayRepaintCallbackCalled = true;
  }
}