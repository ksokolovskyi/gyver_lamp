import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories.dart';
import 'package:gallery/theme/theme.dart';

void main() {
  final dashbook = Dashbook(
    title: 'Gyver Lamp Dashbook',
    theme: ThemeData(
      textTheme: GalleryTextStyles.textTheme,
      colorScheme: const ColorScheme.light(
        primary: GalleryColors.darkBlue,
        background: GalleryColors.background,
      ),
      scaffoldBackgroundColor: GalleryColors.background,
    ),
  );

  addStories(dashbook);

  runApp(dashbook);
}
