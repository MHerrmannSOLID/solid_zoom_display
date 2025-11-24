import 'dart:math';
import 'dart:ui';

extension Pointextensions on Point{

  Offset toOffset() => Offset(x.toDouble(),y.toDouble());

}