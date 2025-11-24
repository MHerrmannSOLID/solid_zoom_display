import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_helpers/event/test_mouse_interaction.dart';
import '../test_helpers/helpers.dart';
import '../test_helpers/test_interaction_controller.dart';

void main(){

    testWidgets(
        'Simulating the mouse enter event  '
            '--> Should trigger a mouse move event in the DisplayMouseInteraction',
            (WidgetTester tester) async {
          var testMouseInteraction = TestMouseInteraction();
          var testInteraction = TestInteractionController(mouseInteraction: testMouseInteraction);
          await tester.pumpWidget(
            createCanvasWidget(interactionController: testInteraction),
          );

          final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
          addTearDown(gesture.removePointer);
          await gesture.addPointer(location: Offset.zero);
          await tester.pump();
          await gesture.moveTo(tester.canvasWidgetCenter());
          await tester.pumpAndSettle();

          expect(testMouseInteraction.onMouseMoveEventData.length, 1);
        });

    testWidgets(
        'Simulating a (touch) tap event  '
            '--> Should not trigger a mouse down event in the DisplayMouseInteraction',
            (WidgetTester tester) async {
          var testMouseInteraction = TestMouseInteraction();
          var testInteraction = TestInteractionController(mouseInteraction: testMouseInteraction);
          await tester.pumpWidget(
            createCanvasWidget(interactionController: testInteraction),
          );

          final gesture = await tester.createGesture(kind: PointerDeviceKind.touch);
          addTearDown(gesture.removePointer);
          await gesture.addPointer(location: Offset.zero);
          await gesture.down(tester.canvasWidgetCenter());
          await tester.pumpAndSettle();
          expect(testMouseInteraction.onMouseDownEventData.length, 0);
        });

    testWidgets(
        'Simulating the mouse down event  '
            '--> Should trigger a mouse down event in the DisplayMouseInteraction',
            (WidgetTester tester) async {
          var testMouseInteraction = TestMouseInteraction();
          var testInteraction = TestInteractionController(mouseInteraction: testMouseInteraction);
          await tester.pumpWidget(createCanvasWidget(interactionController: testInteraction));

          final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
          addTearDown(gesture.removePointer);
          await gesture.addPointer(location: Offset.zero);
          await gesture.down(tester.canvasWidgetCenter());
          await tester.pumpAndSettle();
          expect(testMouseInteraction.onMouseDownEventData.length, 1);
        });

    testWidgets(
        'Simulating (touch) tap down/up event  '
            '--> Should not trigger any event in DisplayMouseInteraction', (WidgetTester tester) async {
      var testMouseInteraction = TestMouseInteraction();
      var testInteraction = TestInteractionController(mouseInteraction: testMouseInteraction);
      await tester.pumpWidget(
        createCanvasWidget(interactionController:  testInteraction),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.touch);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await gesture.down(tester.canvasWidgetCenter());
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      expect(testMouseInteraction.onMouseDownEventData.length, 0);
      expect(testMouseInteraction.onMouseUpEventData.length, 0);
    });

    testWidgets(
        'Simulating the mouse scroll event  '
            '--> Should trigger onMouseScroll in the DisplayMouseInteraction ', (WidgetTester tester) async {
      var testMouseInteraction = TestMouseInteraction();
      var testInteraction =TestInteractionController(mouseInteraction: testMouseInteraction);
      await tester.pumpWidget(
        createCanvasWidget(interactionController: testInteraction),
      );

      // We have to enter with the mouse first, otherwise the controller will run as touch!
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer(location: Offset.zero);
      await tester.pumpAndSettle();

      var testPointer = TestPointer(1, PointerDeviceKind.mouse);
      testPointer.hover(tester.canvasWidgetCenter());
      await tester.sendEventToBinding(testPointer.scroll(Offset(0, 10)));
      await tester.pumpAndSettle();

      expect(testMouseInteraction.onMouseScrollEventData.length, 1);
    });
}