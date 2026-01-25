import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_helpers/event/test_mouse_interaction.dart';
import '../test_helpers/helpers.dart';
import '../test_helpers/test_interaction_controller.dart';
import 'test_touch_interaction.dart';

void main() {
  testWidgets(
      'Simulating the mouse enter event  '
      '--> Should trigger a mouse move event in the DisplayMouseInteraction',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testInteraction =
        TestInteractionController(mouseInteraction: testMouseInteraction);
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(gesture.removePointer);
    await gesture.addPointer(location: tester.canvasWidgetCenter());
    await tester.pump(); // Process the enter event
    await gesture.moveTo(tester.canvasWidgetCenter());
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseMoveEventData.length, 1);
  });

  testWidgets(
      'Simulating a  tap event  '
      '--> Should not trigger a mouse down event in the DisplayMouseInteraction',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testInteraction =
        TestInteractionController(mouseInteraction: testMouseInteraction);
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.touch);
    addTearDown(gesture.removePointer);
    await gesture.addPointer(location: tester.canvasWidgetCenter());
    await gesture.down(tester.canvasWidgetCenter());
    await tester.pumpAndSettle();
    expect(testMouseInteraction.onMouseDownEventData.length, 0);
  });

  testWidgets(
      'Simulating the mouse down event  '
      '--> Should trigger a mouse down event in the DisplayMouseInteraction',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testInteraction =
        TestInteractionController(mouseInteraction: testMouseInteraction);
    await tester
        .pumpWidget(createCanvasWidget(interactionController: testInteraction));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(gesture.removePointer);
    await gesture.addPointer(location: tester.canvasWidgetCenter());
    await tester.pump(); // Process the enter event
    await gesture.down(tester.canvasWidgetCenter());
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseDownEventData.length, 1);
  });

  testWidgets(
      'Simulating (touch) tap down/up event  '
      '--> Should not trigger any event in DisplayMouseInteraction',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testInteraction =
        TestInteractionController(mouseInteraction: testMouseInteraction);
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.touch);
    addTearDown(gesture.removePointer);
    await gesture.addPointer(location: tester.canvasWidgetCenter());
    await gesture.down(tester.canvasWidgetCenter());
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(testMouseInteraction.onMouseDownEventData.length, 0);
    expect(testMouseInteraction.onMouseUpEventData.length, 0);
  });

  testWidgets(
      'Simulating the mouse scroll event  '
      '--> Should trigger onMouseScroll in the DisplayMouseInteraction ',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testInteraction =
        TestInteractionController(mouseInteraction: testMouseInteraction);
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    var testPointer = TestPointer(1, PointerDeviceKind.mouse);
    await tester
        .sendEventToBinding(testPointer.hover(tester.canvasWidgetCenter()));
    await tester.pumpAndSettle();
    await tester.sendEventToBinding(testPointer.scroll(Offset(0, 10)));
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseScrollEventData.length, 1);
  });

  testWidgets(
      'Simulating the long (selection) click event '
      '--> Should trigger onLongClick only for mouse not for touch ',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testTouchInteraction = TestTouchInteraction();
    var testInteraction = TestInteractionController(
      mouseInteraction: testMouseInteraction,
      touchInteraction: testTouchInteraction,
    );
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    var testPointer = TestPointer(1, PointerDeviceKind.mouse);
    await tester
        .sendEventToBinding(testPointer.hover(tester.canvasWidgetCenter()));
    await _simmulateLongTapEvent(tester, testPointer);
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseLongClickEventData.length, 1);
    expect(testTouchInteraction.onLongTapEventData.length, 0);
  });

  testWidgets(
      'Simulating the double click event '
      '--> Should trigger onMouseDblClick only for mouse not for touch ',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testTouchInteraction = TestTouchInteraction();
    var testInteraction = TestInteractionController(
      mouseInteraction: testMouseInteraction,
      touchInteraction: testTouchInteraction,
    );
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    var testPointer = TestPointer(1, PointerDeviceKind.mouse);
    await tester
        .sendEventToBinding(testPointer.hover(tester.canvasWidgetCenter()));
    await _simmulateDoublePointerEvent(tester, testPointer);
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseDblClickEventData.length, 1);
    expect(testTouchInteraction.onDoubleTapEventData.length, 0);
  });

  testWidgets(
      'Simulating the double tap event '
      '--> Should trigger onDoubleTap only for touch not for mouse ',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testTouchInteraction = TestTouchInteraction();
    var testInteraction = TestInteractionController(
      mouseInteraction: testMouseInteraction,
      touchInteraction: testTouchInteraction,
    );
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    var testPointer = TestPointer(1, PointerDeviceKind.touch);
    await _simmulateDoublePointerEvent(tester, testPointer);
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseDblClickEventData.length, 0);
    expect(testTouchInteraction.onDoubleTapEventData.length, 1);
  });

  testWidgets(
      'Simulating the long tap event '
      '--> Should trigger onLongTap only for touch not for mouse ',
      (WidgetTester tester) async {
    var testMouseInteraction = TestMouseInteraction();
    var testTouchInteraction = TestTouchInteraction();
    var testInteraction = TestInteractionController(
      mouseInteraction: testMouseInteraction,
      touchInteraction: testTouchInteraction,
    );
    await tester.pumpWidget(
      createCanvasWidget(interactionController: testInteraction),
    );

    var testPointer = TestPointer(1, PointerDeviceKind.touch);
    await _simmulateLongTapEvent(tester, testPointer);
    await tester.pumpAndSettle();

    expect(testMouseInteraction.onMouseLongClickEventData.length, 0);
    expect(testTouchInteraction.onLongTapEventData.length, 1);
  });
}

// Helper methods to simmulate a double tap and long tap events
// having this is to keep the test code clean and readable
// ----------------------------------------------------------------

Future<void> _simmulateDoublePointerEvent(
    WidgetTester tester, TestPointer testPointer) async {
  await tester
      .sendEventToBinding(testPointer.down(tester.canvasWidgetCenter()));
  await tester.pumpAndSettle();
  await tester.sendEventToBinding(testPointer.up());
  await tester.pump(const Duration(milliseconds: 100));
  await tester
      .sendEventToBinding(testPointer.down(tester.canvasWidgetCenter()));
  await tester.pumpAndSettle();
  await tester.sendEventToBinding(testPointer.up());
  await tester.pumpAndSettle();
}

Future<void> _simmulateLongTapEvent(
    WidgetTester tester, TestPointer testPointer) async {
  await tester
      .sendEventToBinding(testPointer.down(tester.canvasWidgetCenter()));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.sendEventToBinding(testPointer.up());
  await tester.pumpAndSettle();
}
