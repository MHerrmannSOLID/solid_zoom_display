import 'package:solid_zoom_display/solid_zoom_display.dart';
import 'package:solid_zoom_display/src/types/event/mouse_event.dart';

/// This class is the mouse interaction interface.
/// it defines all methods, on which the display will
/// call back in case of the according user interaction.
/// (e.g.: onMouseDown --> as the event handler for mouse
/// down events)
///
/// All callbacks will receive actual event information
/// via the [DisplayEvent] display event.
/// This class contains all necessary information, regarding the
/// display status, as well as the original event information.
/// For further information please refer to [DisplayEvent].
///
/// In order to implement a 'bahavioure' according to the
/// desired interaction, the users has access to the display
/// via the [interactionController] property. Please refer to [ZoomPanel]
/// for further explanations.
///
/// Here's a simple sample interaction:
///
///```dart
/// class SampleMouseInteraction implements DisplayMouseInteraction{
///
///   static final int LeftMouseButton = 0;
///   static final int RightMouseButton = 2;
///
///   ZoomPanel _zoomPanel;
///   bool _isPanning = false;
///
///   @override
///   void set zoomPanel(ZoomPanel value) => _zoomPanel =  value;
///
///   @override
///   void onMouseDown(DisplayEvent event) {
///     var mouseEvt = event.originalEvent as MouseEvent;
///     if(mouseEvt== null)return;
///     _isPanning = mouseEvt.button == LeftMouseButton;
///     if(mouseEvt.button == RightMouseButton) _zoomPanel.scaleToFit();
///   }
///
///   @override
///   void onMouseMove(DisplayEvent event) {
///     if(_isPanning && event.originalEvent is MouseEvent)
///       _zoomPanel.panImageAbout((event.originalEvent as MouseEvent).movement);
///     _updateMouseStatus(event);
///   }
///
///   @override
///   void onMouseScroll(DisplayEvent event) {
///     var wheelEvt = event.originalEvent as WheelEvent;
///     if(wheelEvt == null) return;
///
///     _zoomPanel.scaleAbout(delta: wheelEvt.deltaY, mousePosition: wheelEvt.offset);
///     _updateMouseStatus(event);
///   }
///
///   @override
///   void onMouseUp(DisplayEvent event) =>_isPanning = false;
///
///   void _updateMouseStatus(DisplayEvent event) {
///     var componentPos  =(event.originalEvent as MouseEvent).offset;
///     print('Image (${event.imagePosition.x}|${event.imagePosition.y}) ...'+
///           'Component (${componentPos.x}|${componentPos.y}) '+
///           'is inside image --> ${event.isInsideImage} '+
///           'zoom : ${event.zoomFactor.toStringAsFixed(2)}');
///   }
/// }
///```
class DisplayMouseInteraction {
  const DisplayMouseInteraction();

  /// Called whenever the user pushes one mouse button down while hovering over the component.
  void onMouseDown(MouseEvent event) {}

  /// Called whenever the mouse changes position while hovering over the component.
  void onMouseMove(MouseEvent event) {}

  /// Called whenever the user releases one mouse button down while hovering over the component.
  void onMouseUp(MouseEvent event) {}

  /// Called whenever the user uses the scroll wheel while hovering over the component.
  void onMouseScroll(MouseEvent event) {}

  /// Called whenever the user performs a long click (press and hold) while hovering over the component.
  void onLongClick(MouseEvent event) {}

  /// provides access to the zoom panel [DisplayController] to perform panning or zooming interactions.
  set interactionController(InteractionController value) {}
}
