import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/display_canvas/canvas_widget.dart';

import '../test_helpers/helpers.dart';
import '../test_helpers/test_projector.dart';
import '../test_helpers/test_zoom_controller.dart';

void main() {
  group('CanvasWidget with additional projector layers', () {
    testWidgets(
        'Creating a CanvasWidget with additionalProjectors '
        '--> Should register as listener on all additional projectors',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();
      final layer2 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1, layer2],
      ));

      // Main projector should have one listener
      expect(mainProjector.Listeners.length, 1);
      // Each additional layer should have one listener
      expect(layer1.Listeners.length, 1);
      expect(layer2.Listeners.length, 1);
    });

    testWidgets(
        'Creating a CanvasWidget with additionalProjectors '
        '--> Should execute copyToContext on all projectors during construction',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();
      final layer2 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1, layer2],
      ));

      // All projectors should be called once
      expect(mainProjector.copyToContextCalls, 1);
      expect(layer1.copyToContextCalls, 1);
      expect(layer2.copyToContextCalls, 1);
    });

    testWidgets(
        'Triggering notification on additional projector '
        '--> Should trigger a repaint of the canvas',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1],
      ));

      // Initial state - layer1 called once during construction
      expect(layer1.copyToContextCalls, 1);

      // Trigger notification on layer1
      layer1.triggerNotification();

      // Pump to process the repaint request
      await tester.pump();

      // Layer should have been re-recorded (called again)
      expect(layer1.copyToContextCalls, 2);

      // Trigger another notification
      layer1.triggerNotification();
      await tester.pump();

      // Should be called a third time
      expect(layer1.copyToContextCalls, 3);
    });

    testWidgets(
        'Triggering notification on additional projector '
        '--> Should only re-record that layer, not main projector',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();
      final layer2 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1, layer2],
      ));

      // Initial calls: all projectors called once
      expect(mainProjector.copyToContextCalls, 1);
      expect(layer1.copyToContextCalls, 1);
      expect(layer2.copyToContextCalls, 1);

      // Trigger notification on layer1
      layer1.triggerNotification();
      await tester.pump();

      // Only layer1 should be re-recorded
      expect(mainProjector.copyToContextCalls, 1); // unchanged
      expect(layer1.copyToContextCalls, 2); // incremented
      expect(layer2.copyToContextCalls, 1); // unchanged
    });

    testWidgets(
        'Triggering notification on main projector '
        '--> Should only re-record main projector, not additional layers',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();
      final layer2 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1, layer2],
      ));

      // Initial calls
      expect(mainProjector.copyToContextCalls, 1);
      expect(layer1.copyToContextCalls, 1);
      expect(layer2.copyToContextCalls, 1);

      // Trigger notification on main projector
      mainProjector.triggerNotification();
      await tester.pump();

      // Only main projector should be re-recorded
      expect(mainProjector.copyToContextCalls, 2); // incremented
      expect(layer1.copyToContextCalls, 1); // unchanged
      expect(layer2.copyToContextCalls, 1); // unchanged
    });

    testWidgets(
        'Adding projector layers programmatically '
        '--> Should register listeners and trigger initial render',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
      ));

      final renderObject = tester.renderObject(find.byType(CanvasWidget))
          as CanvasWidgetRenderer;

      // Initial state
      expect(mainProjector.copyToContextCalls, 1);
      expect(layer1.copyToContextCalls, 0);

      // Add layer programmatically
      renderObject.addProjectorLayer(layer1);
      await tester.pump();

      // Layer should now be registered and rendered
      expect(layer1.Listeners.length, 1);
      expect(layer1.copyToContextCalls, 1);
    });

    testWidgets(
        'Removing projector layer '
        '--> Should remove listener and stop updates',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1],
      ));

      final renderObject = tester.renderObject(find.byType(CanvasWidget))
          as CanvasWidgetRenderer;

      // Initial state
      expect(layer1.Listeners.length, 1);
      expect(layer1.copyToContextCalls, 1);

      // Remove the layer
      renderObject.removeProjectorLayer(layer1);
      await tester.pump();

      // Listener should be removed
      expect(layer1.Listeners.length, 0);

      // Trigger notification - should not cause re-render
      layer1.triggerNotification();
      await tester.pump();
      expect(layer1.copyToContextCalls, 1); // unchanged
    });

    testWidgets(
        'Clearing all projector layers '
        '--> Should remove all listeners', (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final layer1 = TestProjector();
      final layer2 = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [layer1, layer2],
      ));

      final renderObject = tester.renderObject(find.byType(CanvasWidget))
          as CanvasWidgetRenderer;

      // Initial state
      expect(layer1.Listeners.length, 1);
      expect(layer2.Listeners.length, 1);

      // Clear all layers
      renderObject.clearProjectorLayers();
      await tester.pump();

      // All listeners should be removed
      expect(layer1.Listeners.length, 0);
      expect(layer2.Listeners.length, 0);
    });

    testWidgets(
        'Multiple layer updates in sequence '
        '--> Should handle independent updates correctly',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final spriteLayer = TestProjector();
      final overlayLayer = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [spriteLayer, overlayLayer],
      ));

      // Simulate sprite animation - frequent updates
      for (int i = 0; i < 5; i++) {
        spriteLayer.triggerNotification();
        await tester.pump();
      }

      // Sprite layer should be re-recorded 5 times (+ initial)
      expect(spriteLayer.copyToContextCalls, 6);
      // Main and overlay should remain unchanged
      expect(mainProjector.copyToContextCalls, 1);
      expect(overlayLayer.copyToContextCalls, 1);

      // Now update overlay
      overlayLayer.triggerNotification();
      await tester.pump();

      // Overlay incremented, others unchanged
      expect(spriteLayer.copyToContextCalls, 6);
      expect(mainProjector.copyToContextCalls, 1);
      expect(overlayLayer.copyToContextCalls, 2);
    });

    testWidgets(
        'Rapid updates on sprite layer '
        '--> Should continuously trigger repaints without affecting main layer',
        (WidgetTester tester) async {
      final mainProjector = TestProjector();
      final spriteProjector = TestProjector();

      await tester.pumpWidget(createCanvasWidget(
        projector: mainProjector,
        additionalProjectors: [spriteProjector],
      ));

      // Initial state
      expect(mainProjector.copyToContextCalls, 1);
      expect(spriteProjector.copyToContextCalls, 1);

      // Simulate rapid sprite updates (like 60fps animation)
      for (int frame = 0; frame < 60; frame++) {
        spriteProjector.triggerNotification();
        await tester.pump(const Duration(milliseconds: 16)); // ~60fps
      }

      // Sprite should be re-recorded 60 times (+ initial = 61)
      expect(spriteProjector.copyToContextCalls, 61);
      // Main projector should still be at 1 (efficiency!)
      expect(mainProjector.copyToContextCalls, 1);
    });
  });
}
