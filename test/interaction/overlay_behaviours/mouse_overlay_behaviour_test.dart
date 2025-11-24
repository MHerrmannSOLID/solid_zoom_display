import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/mouse_overlay_behaviour.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

void main() {

    test(
        'Creation of a mouse overlay behaviour with non change notifying projector'
        '--> Can be constructed without problem', () {
      MouseOverlayBehaviour(overlayProjector: SimpleSelectionOverlayProjector());

      // if we reach this point the test is successful due to
      // no exception within the constructor
      expect(true, true);
    });

    test(
        'Creation of a mouse overlay behaviour with change notifying projector'
        '--> should connect the notify change event correctly in the constructor', () {
      var _isRepaintTriggered = false;

      final testProjector = TestSelectionOverlayProjector();
      var testBehaviour = MouseOverlayBehaviour(overlayProjector: testProjector);

      testBehaviour.addListener(() => _isRepaintTriggered = true);

      testProjector.triggerRepaint();

      expect(_isRepaintTriggered, true);
    });

    test(
        'Trigger move notification, without having selection started '
        '--> should not call the update selection on the projector', () {
      var testProjector = TestSelectionOverlayProjector();
      MouseOverlayBehaviour(overlayProjector: testProjector)..onMouseMovedTo(const Point(100, 100));

      expect(testProjector.selectionUpdateCalls, 0);
    });

    test(
        'Trigger move notification and having selection started '
        '--> should call the update selection on the projector', () {
      var testProjector = TestSelectionOverlayProjector();
      MouseOverlayBehaviour(overlayProjector: testProjector)
        ..startSelectionAt(const Point(100, 100))
        ..onMouseMovedTo(const Point(110, 110));

      expect(testProjector.selectionUpdateCalls, 1);
    });

    test(
        'Trigger move notification twice '
        '--> should recognize twice calls on selection update', () {
      var testProjector = TestSelectionOverlayProjector();
      MouseOverlayBehaviour(overlayProjector: testProjector)
        ..startSelectionAt(const Point(100, 100))
        ..onMouseMovedTo(const Point(110, 110))
        ..onMouseMovedTo(const Point(130, 130));

      expect(testProjector.selectionUpdateCalls, 2);
    });

    test(
        'Trigger move notification before and after selection stopped'
        '--> should only record one trigger (before stopped)', () {
      var testProjector = TestSelectionOverlayProjector();
      MouseOverlayBehaviour(overlayProjector: testProjector)
        ..startSelectionAt(const Point(100, 100))
        ..onMouseMovedTo(const Point(110, 110))
        ..stopSelection()
        ..onMouseMovedTo(const Point(120, 120));

      expect(testProjector.selectionUpdateCalls, 1);
    });

    test(
        'Trigger selection stopped after mouse move '
        '--> should extract the corresponding selection rect', () {
      var testProjector = TestSelectionOverlayProjector();
      var testBehaviour = MouseOverlayBehaviour(overlayProjector: testProjector)
        ..startSelectionAt(const Point(100, 200))
        ..onMouseMovedTo(const Point(110, 210))
        ..onMouseMovedTo(const Point(120, 230));
      var selection = testBehaviour.stopSelection();

      expect(selection.left, 100);
      expect(selection.top, 200);
      expect(selection.width, 20);
      expect(selection.height, 30);
    });

}

class SimpleSelectionOverlayProjector extends Fake implements SelectionOverlayProjector {}

class TestSelectionOverlayProjector extends ChangeNotifier implements SelectionOverlayProjector {
  int selectionUpdateCalls = 0;

  @override
  void clearSelection() {
    // TODO: implement clearSelection
  }

  @override
  void drawSelectionOverlay(Canvas context, Offset ofs) {
    // TODO: implement drawSelectionOverlay
  }

  @override
  void updateSelection(Rectangle<num> actSelection) => selectionUpdateCalls++;

  void triggerRepaint() => notifyListeners();
}
