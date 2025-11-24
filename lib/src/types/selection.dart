import 'dart:math';

class Selection{

  Selection({required Rectangle<num> display, required Rectangle<num> image})
    : _display = display, _image = image;

  final Rectangle<num> _display;
  final Rectangle<num> _image;

  Rectangle<num> get display => _display;
  Rectangle<num> get image => _image;
}