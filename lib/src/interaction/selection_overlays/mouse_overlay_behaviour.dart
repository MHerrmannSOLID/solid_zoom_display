import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:solid_zoom_display/src/interaction/selection_overlays/selection_overlay_projector.dart';

/// It might be necessary to draw a dynamic overlays for certain
/// types of mouse interactions. An example might be the zoom box.
/// Such an overlay moves according to the mouse interaction and disappears
/// when the interaction is over.
///
/// By implementing this class the user can define his own interaction overlay.
/// A simple overlay would look like this:
/// ```dart
/// class OverlayDemo implements MouseOverlayBehaviour{
///   CanvasRenderingContext2D _context;
///   var _selectionStart = Point(0,0);
///   int _selectionWidth=0;
///   int _selectionHeight=0;
///   int lineWidth = 1;
///   bool _isSelecting = false;
///
///   String _strokeColor = 'rgba(255,255,255,0.8)';
///   String _boxColor = 'rgba(0,60,170,0.6)';
///
///   @override
///   set context(CanvasRenderingContext2D value)=> _context = value;
///
///   void _clearSelection() =>
///       _context?.clearRect(_selectionStart.x-(lineWidth*_selectionWidth.sign), _selectionStart.y-(lineWidth*_selectionHeight.sign),
///           _selectionWidth+(2*lineWidth*_selectionWidth.sign), _selectionHeight+(2*lineWidth*_selectionHeight.sign));
///
///   @override
///   void onMouseMovedTo(Point point) {
///     if(_context == null || ! _isSelecting) return;
///
///     _clearSelection();
///
///     _selectionWidth =  point.x-_selectionStart.x;
///     _selectionHeight = point.y-_selectionStart.y;
///
///     _context.beginPath();
///     _context.rect(_selectionStart.x, _selectionStart.y,_selectionWidth, _selectionHeight);
///     _context.fillStyle = _boxColor;
///     _context.fill();
///     _context.strokeStyle = _strokeColor;
///     _context.lineWidth=lineWidth;
///     _context.stroke();
///     _context.closePath();
///
///   }
///
///   @override
///   void startSelectionAt(Point point) {
///     _context = context;
///     _selectionStart = point;
///     _isSelecting = true;
///   }
///
///   @override
///   Rectangle stopSelection() {
///     _isSelecting = false;
///     var selection = Rectangle(_selectionStart.x, _selectionStart.y,_selectionWidth, _selectionHeight);
///     _clearSelection();
///     _selectionStart = Point(0,0);
///     return selection;
///   }
/// }
/// ```
class MouseOverlayBehaviour extends ChangeNotifier{

  MouseOverlayBehaviour({SelectionOverlayProjector? overlayProjector})
      : _selectionOverlayProjector = overlayProjector ?? SelectionOverlayProjector() {
    if (_selectionOverlayProjector is ChangeNotifier)
      (_selectionOverlayProjector as ChangeNotifier).addListener(_onNeedRepaint);
  }


  Point<num> _selectionStart = Point(0, 0);
  Point<num> _selectionEnd = Point(0, 0);
  final SelectionOverlayProjector _selectionOverlayProjector;

  bool _isSelecting = false;

  SelectionOverlayProjector get selectionOverlayProjector => _selectionOverlayProjector;

  void _onNeedRepaint() => notifyListeners();

  /// Gets called whenever the selection starts
  ///
  /// Receives the [point] where the selection started, as well as the
  /// drawing [context], to which the user can paint the overlay.
  void startSelectionAt(Point point) {
    _isSelecting = true;
    _selectionStart = point;
  }

  /// This method is called to update the selection
  ///
  /// While the mouse moves, it might be necessary to update the selection.
  /// this will be done by this method. The only argument is the actual mouse
  /// position ([point]).
  bool onMouseMovedTo(Point point) {
    _selectionEnd = point;
    if (_isSelecting) _updateSelection();
    return _isSelecting;
  }

  void _updateSelection(){
    _selectionOverlayProjector.updateSelection(_getSelectionRect());
    notifyListeners();
  }

  /// Stops the selection
  ///
  /// This method stops the selection. After selection, the caller might
  /// need to know which area had been selected, therefore it is expected,
  /// this method returns the [Rectangle] containing the selected area.
  /// This [Rectangle] is expected to be within display coordinates,
  /// not in image coordinates.
  Rectangle stopSelection() {
    _selectionOverlayProjector.clearSelection();
    _isSelecting = false;
    return _getSelectionRect();
  }

  Rectangle<num> _getSelectionRect() {
    var left = min(_selectionStart.x, _selectionEnd.x);
    var top = min(_selectionStart.y, _selectionEnd.y);
    var width = max(_selectionStart.x, _selectionEnd.x) - left;
    var height = max(_selectionStart.y, _selectionEnd.y) - top;
    return Rectangle(left, top, width, height);
  }
}
