import 'dart:math';

class InvalidPoint extends Point<num> {

  const InvalidPoint() : super(double.nan, double.nan);

  @override
  String toString() => 'InvalidPoint';
}