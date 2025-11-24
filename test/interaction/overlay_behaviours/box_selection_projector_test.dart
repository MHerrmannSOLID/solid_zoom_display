import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/box_selection_projector.dart';
import 'slection_mock_canvas.dart';

void main(){



    test('Updating the selection box '
        '--> should draw adjusted box when calling drawSelectionOverlay',() {

      var boxSelection = BoxSelectionProjector();
      boxSelection.updateSelection(Rectangle<num>(10, 11, 20, 21));

      var fakeCanvas = SelectionMockCanvas();
      boxSelection.drawSelectionOverlay(fakeCanvas, Offset.zero);

      expect(fakeCanvas.drawingBounds.left, 10);
      expect(fakeCanvas.drawingBounds.top, 11);
      expect(fakeCanvas.drawingBounds.width, 20);
      expect(fakeCanvas.drawingBounds.height, 21);
      expect(fakeCanvas.isVergin, false);
    });

    test('Updating the selection box including offset'
        '--> should draw adjusted box  with including offset '
        'when calling drawSelectionOverlay',() {

      var boxSelection = BoxSelectionProjector();
      boxSelection.updateSelection(Rectangle<num>(10, 11, 20, 21));

      var fakeCanvas = SelectionMockCanvas();
      boxSelection.drawSelectionOverlay(fakeCanvas, const Offset(10,20));

      expect(fakeCanvas.drawingBounds.left, 20);
      expect(fakeCanvas.drawingBounds.top, 31);
      expect(fakeCanvas.drawingBounds.width, 20);
      expect(fakeCanvas.drawingBounds.height, 21);
      expect(fakeCanvas.isVergin, false);
    });


    test('Calling clear selection of previously updated selection box '
        '--> should not draw at all ',() {

      var boxSelection = BoxSelectionProjector();
      boxSelection.updateSelection(Rectangle<num>(10, 11, 20, 21));
      boxSelection.clearSelection();

      var fakeCanvas = SelectionMockCanvas();
      boxSelection.drawSelectionOverlay(fakeCanvas, Offset.zero);

      expect(fakeCanvas.isVergin, true);
    });

}