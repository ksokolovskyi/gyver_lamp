import 'package:flutter/material.dart';

/// {@template gyver_lamp_page_route}
/// Default [MaterialPageRoute] for the Gyver Lamp application.
/// {@endtemplate}
class GyverLampPageRoute<T> extends MaterialPageRoute<T> {
  /// {@macro gyver_lamp_page_route}
  GyverLampPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });
}
