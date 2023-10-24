import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';

void main() {
  group('FastLedNoise', () {
    test('inoise8 generates correct value', () {
      expect(FastLedNoise.inoise8(0, 0, 0), equals(128));

      expect(FastLedNoise.inoise8(16, 0, 0), equals(136));
      expect(FastLedNoise.inoise8(0, 16, 0), equals(128));
      expect(FastLedNoise.inoise8(0, 0, 16), equals(136));
      expect(FastLedNoise.inoise8(16, 16, 16), equals(144));

      expect(FastLedNoise.inoise8(32, 0, 0), equals(140));
      expect(FastLedNoise.inoise8(0, 32, 0), equals(126));
      expect(FastLedNoise.inoise8(0, 0, 32), equals(146));
      expect(FastLedNoise.inoise8(32, 32, 32), equals(152));

      expect(FastLedNoise.inoise8(64, 0, 0), equals(144));
      expect(FastLedNoise.inoise8(0, 64, 0), equals(116));
      expect(FastLedNoise.inoise8(0, 0, 64), equals(168));
      expect(FastLedNoise.inoise8(64, 64, 64), equals(154));

      expect(FastLedNoise.inoise8(128, 0, 0), equals(128));
      expect(FastLedNoise.inoise8(0, 128, 0), equals(96));
      expect(FastLedNoise.inoise8(0, 0, 128), equals(192));
      expect(FastLedNoise.inoise8(128, 128, 128), equals(96));

      expect(FastLedNoise.inoise8(192, 0, 0), equals(112));
      expect(FastLedNoise.inoise8(0, 192, 0), equals(100));
      expect(FastLedNoise.inoise8(0, 0, 192), equals(168));
      expect(FastLedNoise.inoise8(192, 192, 192), equals(144));

      expect(FastLedNoise.inoise8(255, 0, 0), equals(128));
      expect(FastLedNoise.inoise8(0, 255, 0), equals(128));
      expect(FastLedNoise.inoise8(0, 0, 255), equals(128));
      expect(FastLedNoise.inoise8(255, 255, 255), equals(132));
    });
  });
}
