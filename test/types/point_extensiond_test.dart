import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_zoom_display/src/types/point_extensions.dart';

void main() {
  test(
      'Conversion from random offset to point '
      '--> the offset should have the same coordinates as the point', () {
    final rnd = Random();
    final rndPoint = Point((rnd.nextDouble() - 0.5) * 1000, (rnd.nextDouble() - 0.5) * 1000);

    final offset = rndPoint.toOffset();
    expect(offset.dx, rndPoint.x);
    expect(offset.dy, rndPoint.y);
  });
}
