import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/context_menu_region.dart';
import 'package:solid_zoom_display/src/zoom_display.dart';
import 'test_helpers/test_projector.dart';
import 'test_helpers/test_ticker_provider.dart';

void main() {
  testWidgets(
      'Pumping the zoom panel display widget with no color specification '
      '--> Should have the canvas widget wrapped in a ContextMenuRegion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      SizedBox(
        width: 500,
        height: 500,
        child: ZoomDisplay(
          projector: TestProjector(),
          vsync: TestTickerProvider(),
        ),
      ),
    );
    expect(find.byType(ContextMenuRegion), findsOneWidget);
  });
}
