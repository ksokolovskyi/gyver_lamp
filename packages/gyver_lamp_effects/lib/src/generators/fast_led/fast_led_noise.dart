// ignore_for_file: non_constant_identifier_names

import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';

/// FastLED 8-bit noise functions.
///
/// Those functions are ported from a FastLED C++ source code:
/// https://github.com/FastLED/FastLED/blob/master/src/noise.cpp
abstract class FastLedNoise {
  /// Generates 8-bit Perlin noise at a specified point in 3D space.
  static int inoise8(int x, int y, int z) {
    final ux = x.toUnsigned(16);
    final uy = y.toUnsigned(16);
    final uz = z.toUnsigned(16);

    var n = _inoise8_raw(ux, uy, uz); // -64..+64
    n += 64; //   0..128

    return FastLedMath.qadd8(n, n); // 0..255
  }

  static int _inoise8_raw(int x, int y, int z) {
    // Find the unit cube containing the point
    final X = x.toUnsigned(16) >> 8;
    final Y = y.toUnsigned(16) >> 8;
    final Z = z.toUnsigned(16) >> 8;

    // Hash cube corner coordinates
    final A = (_p[X] + Y).toUnsigned(8);
    final AA = (_p[A] + Z).toUnsigned(8);
    final AB = (_p[A + 1] + Z).toUnsigned(8);
    final B = (_p[X + 1] + Y).toUnsigned(8);
    final BA = (_p[B] + Z).toUnsigned(8);
    final BB = (_p[B + 1] + Z).toUnsigned(8);

    // Get the relative position of the point in the cube
    var u = x.toUnsigned(8);
    var v = y.toUnsigned(8);
    var w = z.toUnsigned(8);

    // Get a signed version of the above for the grad function
    final xx = ((x.toUnsigned(8) >> 1) & 0x7F).toSigned(8);
    final yy = ((y.toUnsigned(8) >> 1) & 0x7F).toSigned(8);
    final zz = ((z.toUnsigned(8) >> 1) & 0x7F).toSigned(8);
    const N = 0x80;

    u = FastLedMath.ease8InOutQuad(u);
    v = FastLedMath.ease8InOutQuad(v);
    w = FastLedMath.ease8InOutQuad(w);

    final X1 = FastLedMath.lerp7by8(
      FastLedMath.grad8(_p[AA], xx, yy, zz),
      FastLedMath.grad8(_p[BA], xx - N, yy, zz),
      u,
    );
    final X2 = FastLedMath.lerp7by8(
      FastLedMath.grad8(_p[AB], xx, yy - N, zz),
      FastLedMath.grad8(_p[BB], xx - N, yy - N, zz),
      u,
    );
    final X3 = FastLedMath.lerp7by8(
      FastLedMath.grad8(_p[AA + 1], xx, yy, zz - N),
      FastLedMath.grad8(_p[BA + 1], xx - N, yy, zz - N),
      u,
    );
    final X4 = FastLedMath.lerp7by8(
      FastLedMath.grad8(_p[AB + 1], xx, yy - N, zz - N),
      FastLedMath.grad8(_p[BB + 1], xx - N, yy - N, zz - N),
      u,
    );

    final Y1 = FastLedMath.lerp7by8(X1, X2, v);
    final Y2 = FastLedMath.lerp7by8(X3, X4, v);

    return FastLedMath.lerp7by8(Y1, Y2, w);
  }

  static const _p = [
    151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, //
    140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
    247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
    57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
    74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
    60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
    65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
    200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
    52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
    207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
    119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
    129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
    218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
    81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
    184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
    222,
    114,
    67,
    29,
    24,
    72,
    243,
    141,
    128,
    195,
    78,
    66,
    215,
    61,
    156,
    180,
    151,
    // ignore: require_trailing_commas
  ];
}
