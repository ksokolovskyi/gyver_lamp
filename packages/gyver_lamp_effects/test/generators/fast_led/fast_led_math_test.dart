import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';

void main() {
  group('FastLedMath', () {
    group('qadd8', () {
      test('returns sum of the two integers', () {
        expect(FastLedMath.qadd8(3, 4), equals(7));
      });

      test('returns 255 if sum is greater than 255', () {
        expect(FastLedMath.qadd8(255, 1), equals(255));
      });
    });

    group('qsub8', () {
      test('returns subtraction result of the two integers', () {
        expect(FastLedMath.qsub8(4, 3), equals(1));
      });

      test('returns 0 if subtraction result is lower than 0', () {
        expect(FastLedMath.qsub8(1, 3), equals(0));
      });
    });

    group('avg7', () {
      test('returns average of the two integers', () {
        expect(FastLedMath.avg7(4, 2), equals(3));
      });

      test('rounds result up when first number is odd', () {
        expect(FastLedMath.avg7(3, 4), equals(4));
      });

      test('rounds result down when first number is even', () {
        expect(FastLedMath.avg7(4, 3), equals(3));
      });
    });

    group('scale8', () {
      test('scales number by scale', () {
        expect(FastLedMath.scale8(4, 0), equals(0));
        expect(FastLedMath.scale8(4, 64), equals(1));
        expect(FastLedMath.scale8(4, 128), equals(2));
        expect(FastLedMath.scale8(4, 255), equals(4));
      });
    });

    group('dim8_raw', () {
      test('scales number by itself', () {
        expect(FastLedMath.dim8_raw(0), equals(0));
        expect(FastLedMath.dim8_raw(64), equals(16));
        expect(FastLedMath.dim8_raw(128), equals(64));
        expect(FastLedMath.dim8_raw(255), equals(255));
      });
    });

    group('lerp7by8', () {
      test('interpolates between two integers when a > b', () {
        expect(FastLedMath.lerp7by8(0, 10, 0), equals(0));
        expect(FastLedMath.lerp7by8(0, 10, 128), equals(5));
        expect(FastLedMath.lerp7by8(0, 10, 255), equals(10));
      });

      test('interpolates between two integers when b > a', () {
        expect(FastLedMath.lerp7by8(10, 0, 0), equals(10));
        expect(FastLedMath.lerp7by8(10, 0, 128), equals(5));
        expect(FastLedMath.lerp7by8(10, 0, 255), equals(0));
      });
    });

    group('ease8InOutQuad', () {
      test('applies easeInOutQuad curve to the input', () {
        expect(FastLedMath.ease8InOutQuad(0), equals(0));
        expect(FastLedMath.ease8InOutQuad(64), equals(32));
        expect(FastLedMath.ease8InOutQuad(128), equals(129));
        expect(FastLedMath.ease8InOutQuad(192), equals(225));
        expect(FastLedMath.ease8InOutQuad(255), equals(255));
      });
    });

    group('lsrX4', () {
      test('divides number by 16', () {
        expect(FastLedMath.lsrX4(1), equals(0));
        expect(FastLedMath.lsrX4(16), equals(1));
        expect(FastLedMath.lsrX4(32), equals(2));
        expect(FastLedMath.lsrX4(64), equals(4));
        expect(FastLedMath.lsrX4(128), equals(8));
        expect(FastLedMath.lsrX4(133), equals(8));
        expect(FastLedMath.lsrX4(255), equals(15));
      });
    });

    group('grad8', () {
      test('generates noise', () {
        expect(FastLedMath.grad8(1, 33, 11, 77), equals(-10));
        expect(FastLedMath.grad8(12, 12, 6, 4), equals(9));
        expect(FastLedMath.grad8(32, 3, 90, 22), equals(47));
        expect(FastLedMath.grad8(64, 111, 23, 44), equals(68));
        expect(FastLedMath.grad8(128, 55, 21, 123), equals(39));
        expect(FastLedMath.grad8(255, 53, 33, 56), equals(-44));
      });
    });

    group('selectBasedOnHashBit', () {
      test('selects number based on hash bit', () {
        final number = int.parse('10101010', radix: 2);

        expect(FastLedMath.selectBasedOnHashBit(number, 0, 1, 2), equals(2));
        expect(FastLedMath.selectBasedOnHashBit(number, 1, 1, 2), equals(1));
        expect(FastLedMath.selectBasedOnHashBit(number, 2, 1, 2), equals(2));
        expect(FastLedMath.selectBasedOnHashBit(number, 3, 1, 2), equals(1));
        expect(FastLedMath.selectBasedOnHashBit(number, 4, 1, 2), equals(2));
        expect(FastLedMath.selectBasedOnHashBit(number, 5, 1, 2), equals(1));
        expect(FastLedMath.selectBasedOnHashBit(number, 6, 1, 2), equals(2));
        expect(FastLedMath.selectBasedOnHashBit(number, 7, 1, 2), equals(1));
      });
    });
  });
}
