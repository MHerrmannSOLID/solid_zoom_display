import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/types/event/touch_event.dart';

/// This class is the touch interaction interface.
/// it defines all methods, on which the display will
/// call back in case of the according user interaction.
/// (e.g.: onTouchStart --> as the event handler for touch
/// start events)
///
/// All callbacks will receive actual event information
/// via the [TouchEvent] touch event.
/// This class contains all necessary information, regarding the
/// display status, as well as the original event information.
/// For further information please refer to [TouchEvent].
///
/// In order to implement a 'bahavioure' according to the
/// desired interaction, the users has access to the display
/// via the [interactionController] property. Please refer to [InteractionController]
/// for further explanations.
///
/// Here's a simple sample interaction:
///
///```dart
/// class SampleTouchInteraction implements DisplayTouchInteraction{
///
///   InteractionController _interactionController;
///   bool _isPanning = false;
///
///   @override
///   void set interactionController(InteractionController value) => _interactionController =  value;
///
///   @override
///   void onTouchStart(TouchEvent event) {
///     _isPanning = true;
///   }
///
///   @override
///   void onTouchMove(TouchEvent event) {
///     if(_isPanning && event.delta != null)
///       _interactionController.panImageAbout(event.delta!);
///   }
///
///   @override
///   void onTouchEnd(TouchEvent event) {
///     _isPanning = false;
///   }
///
///   @override
///   void onDoubleTap(TouchEvent event) {
///     _interactionController.scaleToFit();
///   }
///
///   @override
///   void onScaleUpdate(TouchEvent event) {
///     if(event.scale != null) {
///       _interactionController.scaleAbout(
///         delta: (event.scale! - 1.0) * 100,
///         mousePosition: event.focalPoint
///       );
///     }
///   }
///
///   @override
///   void onLongTap(TouchEvent event) {
///     print('Long tap at (${event.imagePosition.x}|${event.imagePosition.y})');
///   }
/// }
///```
class DisplayTouchInteraction {
  const DisplayTouchInteraction();

  /// Called whenever the user touches down on the component.
  void onTouchStart(TouchEvent event) {}

  /// Called whenever the user lifts their touch from the component.
  void onTouchEnd(TouchEvent event) {}

  /// Called whenever the user performs a long tap (touch and hold) on the component.
  void onLongTap(TouchEvent event) {}

  /// Called whenever a touch event is cancelled.
  void onTouchCancel(TouchEvent event) {}

  /// Called whenever the user moves their touch while interacting with the component.
  void onTouchMove(TouchEvent event) {}

  /// Called during a pinch-to-zoom gesture, providing scale updates.
  void onScaleUpdate(TouchEvent event) {}

  /// Called when a pinch-to-zoom gesture begins.
  void onScaleStart(TouchEvent event) {}

  /// Called when a pinch-to-zoom gesture ends.
  void onScaleEnd(TouchEvent event) {}

  /// Called whenever the user performs a double tap on the component.
  void onDoubleTap(TouchEvent event) {}

  /// provides access to the zoom panel [DisplayController] to perform panning or zooming interactions.
  set interactionController(InteractionController value) {}
}
