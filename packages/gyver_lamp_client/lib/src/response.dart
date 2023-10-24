import 'package:equatable/equatable.dart';

/// {@template gyver_lamp_response}
/// The response received from the lamp.
/// {@endtemplate}
sealed class GyverLampResponse extends Equatable {
  /// {@macro gyver_lamp_response}
  const GyverLampResponse();

  @override
  List<Object?> get props;
}

/// {@template gyver_lamp_current_response}
/// The response received from the lamp which provides current state.
/// {@endtemplate}
class GyverLampCurrentResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_current_response}
  const GyverLampCurrentResponse({
    required this.mode,
    required this.brightness,
    required this.speed,
    required this.scale,
    required this.isOn,
  });

  /// The index of the current mode.
  final int mode;

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

/// {@template gyver_lamp_ok_response}
/// The response received from the lamp after the ping request.
/// {@endtemplate}
class GyverLampOkResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_ok_response}
  const GyverLampOkResponse({
    required this.timestamp,
  });

  /// The timestamp when ping request was received by the lamp.
  final String timestamp;

  @override
  List<Object?> get props => [timestamp];
}

/// {@template gyver_lamp_brightness_response}
/// The response received from the lamp which provides current brightness level.
/// {@endtemplate}
class GyverLampBrightnessResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_brightness_response}
  const GyverLampBrightnessResponse({
    required this.brightness,
  });

  /// The brightness level.
  final int brightness;

  @override
  List<Object?> get props => [brightness];
}

/// {@template gyver_lamp_speed_response}
/// The response received from the lamp which provides current speed value.
/// {@endtemplate}
class GyverLampSpeedResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_speed_response}
  const GyverLampSpeedResponse({
    required this.speed,
  });

  /// The speed value.
  final int speed;

  @override
  List<Object?> get props => [speed];
}

/// {@template gyver_lamp_scale_response}
/// The response received from the lamp which provides current scale value.
/// {@endtemplate}
class GyverLampScaleResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_scale_response}
  const GyverLampScaleResponse({
    required this.scale,
  });

  /// The scale value.
  final int scale;

  @override
  List<Object?> get props => [scale];
}

/// {@template gyver_lamp_unknown_response}
/// The not recognized response received from the lamp.
/// {@endtemplate}
class GyverLampUnknownResponse extends GyverLampResponse {
  /// {@macro gyver_lamp_unknown_response}
  const GyverLampUnknownResponse({
    required this.data,
  });

  /// Original (non-parsed) data from the response.
  final String data;

  @override
  List<Object?> get props => [data];
}
