import 'package:flutter/material.dart';
import 'package:gallery/theme/theme.dart';

abstract class GalleryTextStyles {
  static TextTheme get textTheme => const TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: bodyLarge,
        bodyLarge: bodyMedium,
      );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Figtree',
    fontWeight: FontWeight.w800,
    fontSize: 56,
    color: GalleryColors.darkBlue,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'Figtree',
    fontSize: 40,
    color: GalleryColors.darkGrey,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Figtree',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    color: GalleryColors.darkBlue,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Figtree',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: GalleryColors.darkTeal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Figtree',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0.08,
    color: GalleryColors.grey,
  );
}
