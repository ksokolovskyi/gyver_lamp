part of 'control_bloc.dart';

abstract class ControlEvent extends Equatable {
  const ControlEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionStateUpdated extends ControlEvent {
  const ConnectionStateUpdated({
    required this.isConnected,
    required this.connectionData,
  }) : assert(
          (isConnected && connectionData != null) || !isConnected,
          'connectionData must not be null when isConnected',
        );

  final bool isConnected;

  final ConnectionData? connectionData;

  @override
  List<Object?> get props => [isConnected, connectionData];
}

class LampMessageReceived extends ControlEvent {
  const LampMessageReceived({
    required this.message,
  });

  final GyverLampMessage message;

  @override
  List<Object?> get props => [message];
}

class ControlRequested extends ControlEvent {
  const ControlRequested();
}

class ModeUpdated extends ControlEvent {
  const ModeUpdated({
    required this.mode,
  });

  final GyverLampMode mode;

  @override
  List<Object?> get props => [mode];
}

class BrightnessUpdated extends ControlEvent {
  const BrightnessUpdated({
    required this.brightness,
  });

  final int brightness;

  @override
  List<Object?> get props => [brightness];
}

class SpeedUpdated extends ControlEvent {
  const SpeedUpdated({
    required this.speed,
  });

  final int speed;

  @override
  List<Object?> get props => [speed];
}

class ScaleUpdated extends ControlEvent {
  const ScaleUpdated({
    required this.scale,
  });

  final int scale;

  @override
  List<Object?> get props => [scale];
}

class PowerToggled extends ControlEvent {
  const PowerToggled({
    required this.isOn,
  });

  final bool isOn;

  @override
  List<Object?> get props => [isOn];
}
