import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';

/// FastLED library predefined colors.
///
/// Those colors are copied from the list available at:
/// https://github.com/FastLED/FastLED/wiki/Pixel-reference#predefined-colors-list
///
/// Note that colors defined in the FastLED library has no alpha value and thus
/// can't be used directly to create Flutter [Color].
abstract class FastLedColors {
  /// Alice Blue color.
  static const aliceBlue = 0xF0F8FF;

  /// Amethyst color.
  static const amethyst = 0x9966CC;

  /// Antique White color.
  static const antiqueWhite = 0xFAEBD7;

  /// Aqua color.
  static const aqua = 0x00FFFF;

  /// Aquamarine color.
  static const aquamarine = 0x7FFFD4;

  /// Azure color.
  static const azure = 0xF0FFFF;

  /// Beige color.
  static const beige = 0xF5F5DC;

  /// Bisque color.
  static const bisque = 0xFFE4C4;

  /// Black color.
  static const black = 0x000000;

  /// Blanched Almond color.
  static const blanchedAlmond = 0xFFEBCD;

  /// Blue color.
  static const blue = 0x0000FF;

  /// Blue Violet color.
  static const blueViolet = 0x8A2BE2;

  /// Brown color.
  static const brown = 0xA52A2A;

  /// Burly Wood color.
  static const burlyWood = 0xDEB887;

  /// Cadet Blue color.
  static const cadetBlue = 0x5F9EA0;

  /// Chartreuse color.
  static const chartreuse = 0x7FFF00;

  /// Chocolate color.
  static const chocolate = 0xD2691E;

  /// Coral color.
  static const coral = 0xFF7F50;

  /// Cornflower Blue color.
  static const cornflowerBlue = 0x6495ED;

  /// Corn Silk color.
  static const cornSilk = 0xFFF8DC;

  /// Crimson color.
  static const crimson = 0xDC143C;

  /// Cyan color.
  static const cyan = 0x00FFFF;

  /// Dark Blue color.
  static const darkBlue = 0x00008B;

  /// Dark Cyan color.
  static const darkCyan = 0x008B8B;

  /// Dark Goldenrod color.
  static const darkGoldenrod = 0xB8860B;

  /// Dark Grey color.
  static const darkGrey = 0xA9A9A9;

  /// Dark Green color.
  static const darkGreen = 0x006400;

  /// Dark Khaki color.
  static const darkKhaki = 0xBDB76B;

  /// Dark Magenta color.
  static const darkMagenta = 0x8B008B;

  /// Dark Olive Green color.
  static const darkOliveGreen = 0x556B2F;

  /// Dark Orange color.
  static const darkOrange = 0xFF8C00;

  /// Dark Orchid color.
  static const darkOrchid = 0x9932CC;

  /// Dark Red color.
  static const darkRed = 0x8B0000;

  /// Dark Salmon color.
  static const darkSalmon = 0xE9967A;

  /// Dark Sea Green color.
  static const darkSeaGreen = 0x8FBC8F;

  /// Dark Slate Blue color.
  static const darkSlateBlue = 0x483D8B;

  /// Dark Slate Grey color.
  static const darkSlateGrey = 0x2F4F4F;

  /// Dark Turquoise color.
  static const darkTurquoise = 0x00CED1;

  /// Dark Violet color.
  static const darkViolet = 0x9400D3;

  /// Deep Pink color.
  static const deepPink = 0xFF1493;

  /// Deep Sky Blue color.
  static const deepSkyBlue = 0x00BFFF;

  /// Deem Grey color.
  static const dimGrey = 0x696969;

  /// Dodger Blue color.
  static const dodgerBlue = 0x1E90FF;

  /// Fire Black color.
  static const fireBrick = 0xB22222;

  /// Floral White color.
  static const floralWhite = 0xFFFAF0;

  /// Forest Green color.
  static const forestGreen = 0x228B22;

  /// Fuchsia color.
  static const fuchsia = 0xFF00FF;

  /// Gainsboro color.
  static const gainsboro = 0xDCDCDC;

  /// Ghost White color.
  static const ghostWhite = 0xF8F8FF;

  /// Gold color.
  static const gold = 0xFFD700;

  /// Goldenrod color.
  static const goldenrod = 0xDAA520;

  /// Grey color.
  static const grey = 0x808080;

  /// Green color.
  static const green = 0x008000;

  /// Green Yellow color.
  static const greenYellow = 0xADFF2F;

  /// Honeydew color.
  static const honeydew = 0xF0FFF0;

  /// Hot Pink color.
  static const hotPink = 0xFF69B4;

  /// Indian Red color.
  static const indianRed = 0xCD5C5C;

  /// Indigo color.
  static const indigo = 0x4B0082;

  /// Ivory color.
  static const ivory = 0xFFFFF0;

  /// Khaki color.
  static const khaki = 0xF0E68C;

  /// Lavender color.
  static const lavender = 0xE6E6FA;

  /// Lavender Blush color.
  static const lavenderBlush = 0xFFF0F5;

  /// Lawn Green color.
  static const lawnGreen = 0x7CFC00;

  /// Lemon Chiffon color.
  static const lemonChiffon = 0xFFFACD;

  /// Light Blue color.
  static const lightBlue = 0xADD8E6;

  /// Light Coral color.
  static const lightCoral = 0xF08080;

  /// Light Cyan color.
  static const lightCyan = 0xE0FFFF;

  /// Light Goldenrod Yellow color.
  static const lightGoldenrodYellow = 0xFAFAD2;

  /// Light Green color.
  static const lightGreen = 0x90EE90;

  /// Light Grey color.
  static const lightGrey = 0xD3D3D3;

  /// Light Pink color.
  static const lightPink = 0xFFB6C1;

  /// Light Salmon color.
  static const lightSalmon = 0xFFA07A;

  /// Light Sea Green color.
  static const lightSeaGreen = 0x20B2AA;

  /// Light Sky Blue color.
  static const lightSkyBlue = 0x87CEFA;

  /// Light Slate Grey color.
  static const lightSlateGrey = 0x778899;

  /// Light Steel Blue color.
  static const lightSteelBlue = 0xB0C4DE;

  /// Light Yellow color.
  static const lightYellow = 0xFFFFE0;

  /// Lime color.
  static const lime = 0x00FF00;

  /// Lime Green color.
  static const limeGreen = 0x32CD32;

  /// Linen color.
  static const linen = 0xFAF0E6;

  /// Magenta color.
  static const magenta = 0xFF00FF;

  /// Maroon color.
  static const maroon = 0x800000;

  /// Medium Aquamarine color.
  static const mediumAquamarine = 0x66CDAA;

  /// Medium Blue color.
  static const mediumBlue = 0x0000CD;

  /// Medium Orchid color.
  static const mediumOrchid = 0xBA55D3;

  /// Medium Purple color.
  static const mediumPurple = 0x9370DB;

  /// Medium Sea Green color.
  static const mediumSeaGreen = 0x3CB371;

  /// Medium Slate Blue color.
  static const mediumSlateBlue = 0x7B68EE;

  /// Medium Spring Green color.
  static const mediumSpringGreen = 0x00FA9A;

  /// Medium Turquoise color.
  static const mediumTurquoise = 0x48D1CC;

  /// Medium Violet Red color.
  static const mediumVioletRed = 0xC71585;

  /// Midnight Blue color.
  static const midnightBlue = 0x191970;

  /// Mint Cream color.
  static const mintCream = 0xF5FFFA;

  /// Misty Rose color.
  static const mistyRose = 0xFFE4E1;

  /// Moccasin color.
  static const moccasin = 0xFFE4B5;

  /// Navajo White color.
  static const navajoWhite = 0xFFDEAD;

  /// Navy color.
  static const navy = 0x000080;

  /// Old Lace color.
  static const oldLace = 0xFDF5E6;

  /// Olive color.
  static const olive = 0x808000;

  /// Olive Drab color.
  static const oliveDrab = 0x6B8E23;

  /// Orange color.
  static const orange = 0xFFA500;

  /// Orange Red color.
  static const orangeRed = 0xFF4500;

  /// Orchid color.
  static const orchid = 0xDA70D6;

  /// Pale Goldenrod color.
  static const paleGoldenrod = 0xEEE8AA;

  /// Pale Green color.
  static const paleGreen = 0x98FB98;

  /// Pale Turquoise color.
  static const paleTurquoise = 0xAFEEEE;

  /// Pale Violet Red color.
  static const paleVioletRed = 0xDB7093;

  /// Papaya Whip color.
  static const papayaWhip = 0xFFEFD5;

  /// Peach Puff color.
  static const peachPuff = 0xFFDAB9;

  /// Peru color.
  static const peru = 0xCD853F;

  /// Pink color.
  static const pink = 0xFFC0CB;

  /// Plaid color.
  static const plaid = 0xCC5533;

  /// Plum color.
  static const plum = 0xDDA0DD;

  /// Powder Blue color.
  static const powderBlue = 0xB0E0E6;

  /// Purple color.
  static const purple = 0x800080;

  /// Red color.
  static const red = 0xFF0000;

  /// Rosy Brown color.
  static const rosyBrown = 0xBC8F8F;

  /// Royal Blue color.
  static const royalBlue = 0x4169E1;

  /// Saddle Brown color.
  static const saddleBrown = 0x8B4513;

  /// Salmon color.
  static const salmon = 0xFA8072;

  /// Sandy Brown color.
  static const sandyBrown = 0xF4A460;

  /// Sea Green color.
  static const seaGreen = 0x2E8B57;

  /// Seashell color.
  static const seashell = 0xFFF5EE;

  /// Sienna color.
  static const sienna = 0xA0522D;

  /// Silver color.
  static const silver = 0xC0C0C0;

  /// Sky Blue color.
  static const skyBlue = 0x87CEEB;

  /// Slate Blue color.
  static const slateBlue = 0x6A5ACD;

  /// Slate Grey color.
  static const slateGrey = 0x708090;

  /// Snow color.
  static const snow = 0xFFFAFA;

  /// Spring Green color.
  static const springGreen = 0x00FF7F;

  /// Steel Blue color.
  static const steelBlue = 0x4682B4;

  /// Tan color.
  static const tan = 0xD2B48C;

  /// Teal color.
  static const teal = 0x008080;

  /// Thistle color.
  static const thistle = 0xD8BFD8;

  /// Tomato color.
  static const tomato = 0xFF6347;

  /// Turquoise color.
  static const turquoise = 0x40E0D0;

  /// Violet color.
  static const violet = 0xEE82EE;

  /// Wheat color.
  static const wheat = 0xF5DEB3;

  /// White color.
  static const white = 0xFFFFFF;

  /// White Smoke color.
  static const whiteSmoke = 0xF5F5F5;

  /// Yellow color.
  static const yellow = 0xFFFF00;

  /// Yellow Green color.
  static const yellowGreen = 0x9ACD32;

  /// Fairy Light color.
  static const fairyLight = 0xFFE42D;

  /// Picks color from a specified palette.
  ///
  /// Note that palette have to be 16 entries long.
  /// Even though the palette has only 16 explicitly defined entries, we can
  /// use an [index] from [0..255] to get 256 colors. The 16 explicit palette
  /// entries will be spread evenly across the [0..255] range, and the
  /// intermediate values will be RGB-interpolated between adjacent explicit
  /// entries.
  /// The [brightness] value have to be in range [0..255].
  ///
  /// The output color has an alpha value and thus can be used to create
  /// Flutter [Color] without any additional manipulations.
  ///
  /// This function is ported from a FastLED C++ source code:
  /// https://github.com/FastLED/FastLED/blob/master/src/colorutils.cpp
  static int colorFromPalette({
    required List<int> palette,
    required int index,
    required int brightness,
  }) {
    assert(palette.length == 16, 'palette have to contain 16 entries');

    final ui = index.toUnsigned(8);
    var bri = brightness.toUnsigned(8);
    final hi4 = FastLedMath.lsrX4(ui);
    final lo4 = ui & 0x0F;

    final color = palette[hi4];

    var red1 = (color >> 16) & 0xFF;
    var green1 = (color >> 8) & 0xFF;
    var blue1 = color & 0xFF;

    if (lo4 > 0) {
      final int nextColor;

      if (hi4 == 15) {
        nextColor = palette[0];
      } else {
        nextColor = palette[hi4 + 1];
      }

      final f2 = lo4 << 4;
      final f1 = 255 - f2;

      var red2 = (nextColor >> 16) & 0xFF;
      red1 = FastLedMath.scale8(red1, f1);
      red2 = FastLedMath.scale8(red2, f2);
      red1 += red2;
      red1 = red1.toUnsigned(8);

      var green2 = (nextColor >> 8) & 0xFF;
      green1 = FastLedMath.scale8(green1, f1);
      green2 = FastLedMath.scale8(green2, f2);
      green1 += green2;
      green1 = green1.toUnsigned(8);

      var blue2 = nextColor & 0xFF;
      blue1 = FastLedMath.scale8(blue1, f1);
      blue2 = FastLedMath.scale8(blue2, f2);
      blue1 += blue2;
      blue1 = blue1.toUnsigned(8);
    }

    if (bri != 255) {
      if (bri > 0) {
        bri++;

        if (red1 > 0) {
          red1 = FastLedMath.scale8(red1, bri);
        }

        if (green1 > 0) {
          green1 = FastLedMath.scale8(green1, bri);
        }

        if (blue1 > 0) {
          blue1 = FastLedMath.scale8(blue1, bri);
        }
      } else {
        red1 = 0;
        green1 = 0;
        blue1 = 0;
      }
    }

    return (0xFF << 24) | (red1 << 16) | (green1 << 8) | blue1;
  }
}
