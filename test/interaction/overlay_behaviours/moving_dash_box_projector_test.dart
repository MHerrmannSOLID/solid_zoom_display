import 'dart:math';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'slection_mock_canvas.dart';

void main() {

    test(
        'Creation of a moving dash box projector '
        '---> Ticker provider will be requested by the animation controller', () {
      final mockTickerProvider = MockTickerProvider();
      MovingDashBoxProjector(
        vsync: mockTickerProvider,
      );

      expect(mockTickerProvider.tickerWasRequested, true);
    });

    test('Updating the selection box '
            '---> Listeners get notified of change', () {
      final mockTickerProvider = MockTickerProvider();
      var updatedCalled = false;
      final movingDashBoxProjector = MovingDashBoxProjector(
        vsync: mockTickerProvider,
      );
      movingDashBoxProjector.addListener(() => updatedCalled = true);

      movingDashBoxProjector.updateSelection(Rectangle<num>(10, 10, 20, 20));
      mockTickerProvider.trigger();

      expect(updatedCalled, true);
    });

    test('Calling clear selection of previously updated selection box '
        '--> should not draw at all ',() {

      final mockTickerProvider = MockTickerProvider();
      var movingDashBoxProjector = MovingDashBoxProjector(
        vsync: mockTickerProvider,
      );
      movingDashBoxProjector.updateSelection(Rectangle<num>(10, 11, 20, 21));
      movingDashBoxProjector.clearSelection();

      var fakeCanvas = SelectionMockCanvas();
      movingDashBoxProjector.drawSelectionOverlay(fakeCanvas, Offset.zero);

      expect(fakeCanvas.isVergin, true);
    });

    test('Updating the selection box '
        '--> the rect of the selection is updated to the new coordinates',(){
      final mockTickerProvider = MockTickerProvider();
      var movingDashBoxProjector = MovingDashBoxProjector(
        vsync: mockTickerProvider,
      );

      movingDashBoxProjector.updateSelection(Rectangle<num>(11, 12, 21, 22));

      var fakeCanvas = SelectionMockCanvas();
      movingDashBoxProjector.drawSelectionOverlay(fakeCanvas, Offset.zero);

      expect(fakeCanvas.drawingBounds.left, 11);
      expect(fakeCanvas.drawingBounds.top, 12);
      expect(fakeCanvas.drawingBounds.width, 21);
      expect(fakeCanvas.drawingBounds.height, 22);
    });


    test('Updating the selection box with offset'
        '--> the rect of the selection is updated to the '
        'new coordinates including the offset',(){
      final mockTickerProvider = MockTickerProvider();
      var movingDashBoxProjector = MovingDashBoxProjector(
        vsync: mockTickerProvider,
      );

      movingDashBoxProjector.updateSelection(Rectangle<num>(11, 12, 21, 22));

      var fakeCanvas = SelectionMockCanvas();
      movingDashBoxProjector.drawSelectionOverlay(fakeCanvas, const Offset(10,20));

      expect(fakeCanvas.drawingBounds.left, 21);
      expect(fakeCanvas.drawingBounds.top, 32);
      expect(fakeCanvas.drawingBounds.width, 21);
      expect(fakeCanvas.drawingBounds.height, 22);
    });

}


class MockTickerProvider extends TickerProvider {

  MockTickerProvider();

  TickerCallback _tickerCallback = (elapsed) {};
  bool _tickerWasRequested = false;
  final Ticker _ticker = MockTicker();
  bool get tickerWasRequested => _tickerWasRequested;

  void trigger()=>_tickerCallback(Duration(milliseconds: 10));

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickerWasRequested = true;

    _tickerCallback = onTick;
    return _ticker;
  }

}

class MockTicker  extends Fake implements Ticker{

  @override
  bool  isActive = false;

  @override
  void stop({ bool canceled = false }){
    isActive = false;
  }

  @override
  TickerFuture start(){
    isActive = true;
    return TickerFuture.complete();
  }

  @override
  String toString({ bool debugIncludeStack = false }) =>'Mock ticker';

}