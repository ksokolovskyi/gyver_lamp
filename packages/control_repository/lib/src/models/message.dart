import 'package:control_repository/src/models/mode.dart';
import 'package:equatable/equatable.dart';

/// {@template gyver_lamp_message}
/// The message received from the lamp.
/// {@endtemplate}
sealed class GyverLampMessage extends Equatable {
  /// {@macro gyver_lamp_message}
  const GyverLampMessage();

  @override
  List<Object?> get props;
}

/// {@template gyver_lamp_state_changed_message}
/// The message received from the lamp which indicates state change.
/// {@endtemplate}
class GyverLampStateChangedMessage extends GyverLampMessage {
  /// {@macro gyver_lamp_state_changed_message}
  const GyverLampStateChangedMessage({
    required this.mode,
    required this.brightness,
    required this.speed,
    required this.scale,
    required this.isOn,
  });

  /// The current selected mode.
  final GyverLampMode mode;

  /// The brightness level of the current mode.
  final int brightness;

  /// The speed value of the current mode.
  final int speed;

  /// The scale value of the current mode.
  final int scale;

  /// Whether lamp is enabled.
  final bool isOn;

  @override
  List<Object?> get props => [mode, brightness, speed, scale, isOn];
}

/// {@template gyver_lamp_brightness_changed_message}
/// The message received from the lamp after the brightness level change.
/// {@endtemplate}
class GyverLampBrightnessChangedMessage extends GyverLampMessage {
  /// {@macro gyver_lamp_brightness_changed_message}
  const GyverLampBrightnessChangedMessage({
    required this.brightness,
  });

  /// The brightness level of the current mode.
  final int brightness;

  @override
  List<Object?> get props => [brightness];
}

/// {@template gyver_lamp_speed_changed_message}
/// The message received from the lamp after the speed value change.
/// {@endtemplate}
class GyverLampSpeedChangedMessage extends GyverLampMessage {
  /// {@macro gyver_lamp_speed_changed_message}
  const GyverLampSpeedChangedMessage({
    required this.speed,
  });

  /// The speed value of the current mode.
  final int speed;

  @override
  List<Object?> get props => [speed];
}

/// {@template gyver_lamp_scale_changed_message}
/// The message received from the lamp after the scale value change.
/// {@endtemplate}
class GyverLampScaleChangedMessage extends GyverLampMessage {
  /// {@macro gyver_lamp_scale_changed_message}
  const GyverLampScaleChangedMessage({
    required this.scale,
  });

  /// The scale value of the current mode.
  final int scale;

  @override
  List<Object?> get props => [scale];
}
