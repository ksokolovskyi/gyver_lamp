import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';

void main() {
  group('NumRemap', () {
    test(
      'remaps positive number to the new range',
      () {
        expect(
          10.remap(0, 20, 0, 10),
          equals(5.0),
        );
      },
    );

    test(
      'remaps negative number to the new range',
      () {
        expect(
          -10.0.remap(-20, 0, -10, 0),
          equals(-5.0),
        );
      },
    );

    test(
      'lefts number unchanged if the ranges are the same',
      () {
        expect(
          10.0.remap(0, 20, 0, 20),
          equals(10.0),
        );
      },
    );
  });
}
