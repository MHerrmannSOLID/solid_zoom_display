// Sprite projector - Small number of primitives (frequently changes)
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solid_zoom_display/solid_zoom_display.dart';

class SpriteProjector extends DisplayProjector {
  Offset _position;
  Offset _velocity;
  final TickerProvider vsync;
  late final Ticker _ticker;
  final Size _boundsSize;
  final double _spriteRadius = 20.0;
  Duration? _lastElapsed;

  SpriteProjector({
    required Offset position,
    required this.vsync,
    Size boundsSize = const Size(5000, 5000),
  })  : _position = position,
        _velocity = Offset(200, 150), // pixels per second
        _boundsSize = boundsSize {
    _ticker = vsync.createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    if (_lastElapsed == null) {
      _lastElapsed = elapsed;
      return;
    }

    // Calculate delta time in seconds
    final deltaTime = (elapsed - _lastElapsed!).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    // Update position
    _position += _velocity * deltaTime;

    // Bounce off walls
    if (_position.dx - _spriteRadius <= 0 ||
        _position.dx + _spriteRadius >= _boundsSize.width) {
      _velocity = Offset(-_velocity.dx, _velocity.dy);
      _position = Offset(
        _position.dx.clamp(_spriteRadius, _boundsSize.width - _spriteRadius),
        _position.dy,
      );
    }

    if (_position.dy - _spriteRadius <= 0 ||
        _position.dy + _spriteRadius >= _boundsSize.height) {
      _velocity = Offset(_velocity.dx, -_velocity.dy);
      _position = Offset(
        _position.dx,
        _position.dy.clamp(_spriteRadius, _boundsSize.height - _spriteRadius),
      );
    }

    notifyListeners(); // Triggers only THIS layer to re-record
  }

  void updatePosition(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  @override
  void copyToContext(Canvas canvas) {
    // Draw sprite at current position
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(_position, _spriteRadius, paint);

    // Add a white border for visibility
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(_position, _spriteRadius, borderPaint);
  }

  @override
  Size get size => _boundsSize;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
