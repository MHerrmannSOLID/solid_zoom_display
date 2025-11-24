import 'dart:math';

import 'package:solid_zoom_display/src/types/event/mouse_event.dart';

class TestMouseEvent implements MouseEvent {

  final Point<num> _global;
  final Point<num> _movement;
  final Point<num> _image;
  final Point<num> _client;
  final int _button;

  TestMouseEvent({
    Point<num>? global,
    Point<num>? client,
    Point<num>? image,
    Point<num>? movement,
    int? button,
  }):
        _global = global??Point<num>(-1, -1),
        _movement = movement??Point<num>(-1, -1),
        _image = image??Point<num>(-1, -1),
        _client = client ?? Point<num>(-1, -1),
        _button = button??0;

  @override
  int get button => _button;

  @override
  Point<num> get client => _client;

  @override
  bool get ctrlKey => false;

  @override
  int get deltaX => 0;

  @override
  int get deltaY => 0;

  @override
  Point<num> get movement => _movement;

  @override
  Point<num> get global => _global;

  @override
  Point<num> get image => _image;
}