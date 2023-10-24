import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';

void main() {
  const palette = [
    0xFF0000,
    0x000000,
    0xAB5500,
    0x000000,
    //
    0xABAB00,
    0x000000,
    0x00FF00,
    0x000000,
    //
    0x00AB55,
    0x000000,
    0x0000FF,
    0x000000,
    //
    0x5500AB,
    0x000000,
    0xAB0055,
    0x000000,
  ];

  group('FastLedColors', () {
    group('colorFromPalette', () {
      test('throws AssertionError when pallette has wrong length', () async {
        expect(
          () => FastLedColors.colorFromPalette(
            palette: [1, 2, 3],
            index: 0,
            brightness: 255,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals('palette have to contain 16 entries'),
            ),
          ),
        );
      });

      group('returns right colors', () {
        test('for test palette', () {
          expect(
            FastLedColors.colorFromPalette(
              palette: palette,
              index: 0,
              brightness: 255,
            ),
            equals(0xFFFF0000),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: palette,
              index: 128,
              brightness: 255,
            ),
            equals(0xFF00AB55),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: palette,
              index: 255,
              brightness: 255,
            ),
            equals(0xFFF00000),
          );
        });

        test('for ocean palette', () {
          const oceanPalette = [
            FastLedColors.midnightBlue,
            FastLedColors.darkBlue,
            FastLedColors.midnightBlue,
            FastLedColors.navy,
            //
            FastLedColors.darkBlue,
            FastLedColors.mediumBlue,
            FastLedColors.seaGreen,
            FastLedColors.teal,
            //
            FastLedColors.cadetBlue,
            FastLedColors.blue,
            FastLedColors.darkCyan,
            FastLedColors.cornflowerBlue,
            //
            FastLedColors.aquamarine,
            FastLedColors.seaGreen,
            FastLedColors.aqua,
            FastLedColors.lightSkyBlue,
          ];

          expect(
            FastLedColors.colorFromPalette(
              palette: oceanPalette,
              index: 0,
              brightness: 255,
            ),
            equals(0xFF191970),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: oceanPalette,
              index: 128,
              brightness: 255,
            ),
            equals(0xFF5F9EA0),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: oceanPalette,
              index: 255,
              brightness: 255,
            ),
            equals(0xFF1F2378),
          );
        });

        test('for lava palette', () {
          const lavaPalette = [
            FastLedColors.black,
            FastLedColors.maroon,
            FastLedColors.black,
            FastLedColors.maroon,
            //
            FastLedColors.darkRed,
            FastLedColors.darkRed,
            FastLedColors.maroon,
            FastLedColors.darkRed,
            //
            FastLedColors.darkRed,
            FastLedColors.darkRed,
            FastLedColors.red,
            FastLedColors.orange,
            //
            FastLedColors.white,
            FastLedColors.orange,
            FastLedColors.red,
            FastLedColors.darkRed,
          ];

          expect(
            FastLedColors.colorFromPalette(
              palette: lavaPalette,
              index: 0,
              brightness: 255,
            ),
            equals(0xFF000000),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: lavaPalette,
              index: 33,
              brightness: 255,
            ),
            equals(0xFF080000),
          );

          expect(
            FastLedColors.colorFromPalette(
              palette: lavaPalette,
              index: 235,
              brightness: 255,
            ),
            equals(0xFFAF0000),
          );
        });
      });

      test('cycles index to be in range [0, 255]', () async {
        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 0,
            brightness: 255,
          ),
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 256,
            brightness: 255,
          ),
        );
      });

      test('respects brightness', () async {
        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 111,
            brightness: 0,
          ),
          equals(0xFF000000),
        );

        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 111,
            brightness: 128,
          ),
          equals(0xFF000700),
        );

        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 111,
            brightness: 255,
          ),
          equals(0xFF000F00),
        );

        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 233,
            brightness: 0,
          ),
          equals(0xFF000000),
        );

        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 233,
            brightness: 128,
          ),
          equals(0xFF250012),
        );

        expect(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: 233,
            brightness: 255,
          ),
          equals(0xFF4A0025),
        );
      });
    });
  });
}
