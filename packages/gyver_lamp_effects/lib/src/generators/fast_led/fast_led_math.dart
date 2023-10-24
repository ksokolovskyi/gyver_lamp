// ignore_for_file: non_constant_identifier_names

/// FastLED 8-bit math functions.
///
/// Those functions are ported from a FastLED C++ source code:
/// https://github.com/FastLED/FastLED/tree/master/src/lib8tion
abstract class FastLedMath {
  /// Add `a` to `b`, saturating at `0xFF`.
  /// Also known as eight-bit saturating addition.
  static int qadd8(int a, int b) {
    return (a.toUnsigned(8) + b.toUnsigned(8)).clamp(0, 255);
  }

  /// Subtracting `b` from `a`, saturating at `0x00`.
  /// Also known as eight-bit saturating subtraction.
  static int qsub8(int a, int b) {
    return (a.toUnsigned(8) - b.toUnsigned(8)).clamp(0, 255);
  }

  /// Calculate an average of 7-bit signed `a` and `b`.
  ///
  /// If the first argument is even, result is rounded down.
  /// If the first argument is odd, result is rounded up.
  static int avg7(int a, int b) {
    final sa = a.toSigned(8);
    final sb = b.toSigned(8);

    final result = ((sa + sb) >> 1) + (sa & 0x1);

    return result.toSigned(8);
  }

  /// Scales `i` by a `scale`, which is treated as the numerator of a fraction
  /// whose denominator is `256`.
  ///
  /// In other words, it computes `i * (scale / 256)`.
  static int scale8(int i, int scale) {
    final ui = i.toUnsigned(8);
    final us = scale.toUnsigned(8);

    final result = (ui * (1 + us)) >> 8;

    return result.toUnsigned(8);
  }

  /// Adjusts a scaling value for dimming.
  static int dim8_raw(int x) {
    return scale8(x, x);
  }

  /// Linearly interpolates between two signed 8-bit integers `a` and `b` with
  /// a fractional factor `frac`.
  static int lerp7by8(int a, int b, int frac) {
    final int result;

    if (b > a) {
      final delta = (b - a).toUnsigned(8);
      final scaled = scale8(delta, frac);
      result = a + scaled;
    } else {
      final delta = (a - b).toUnsigned(8);
      final scaled = scale8(delta, frac);
      result = a - scaled;
    }

    return result.toSigned(8);
  }

  /// Applies a quadratic ease-in-out function to an 8-bit `i`.
  static int ease8InOutQuad(int i) {
    var j = i.toUnsigned(8);

    if ((j & 0x80) != 0) {
      j = 255 - j;
    }

    final jj = scale8(j, j);
    var jj2 = jj << 1;

    if ((i.toUnsigned(8) & 0x80) != 0) {
      jj2 = 255 - jj2;
    }

    return jj2.toUnsigned(8);
  }

  /// Divides number by 16.
  static int lsrX4(int x) {
    return x.toUnsigned(8) >> 4;
  }

  /// Generates a 3D gradient noise value based on a given hash `h` and
  /// coordinates `x`, `y`, `z`.
  static int grad8(int h, int x, int y, int z) {
    final hash = h.toUnsigned(8) & 0xF;
    final sx = x.toSigned(8);
    final sy = y.toSigned(8);
    final sz = z.toSigned(8);

    var u = selectBasedOnHashBit(hash, 3, sy, sx);
    var v = hash < 4 ? sy : (hash == 12 || hash == 14 ? sx : sz);

    if ((hash & 1) != 0) {
      u = -u;
    }

    if ((hash & 2) != 0) {
      v = -v;
    }

    return avg7(u, v);
  }

  /// Selects a value based on a specific `bit` of a hash value `h`.
  ///
  /// This function selects one of two values, `a` and `b`, based on the value
  /// of a specific `bit` within a hash value `h` (an unsigned 8-bit integer).
  /// If the selected bit is 0, `b` is returned; otherwise `a` is returned.
  static int selectBasedOnHashBit(int hash, int bit, int a, int b) {
    final result = hash.toUnsigned(8) & (1 << bit.toUnsigned(8));
    return result != 0 ? a.toSigned(8) : b.toSigned(8);
  }
}
