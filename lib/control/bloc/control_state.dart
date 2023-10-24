part of 'control_bloc.dart';

class ControlState extends Equatable {
  const ControlState({
    required this.isConnected,
    required this.connectionData,
    required this.mode,
    required this.brightness,
    required this.speed,
    required this.scale,
    required this.isOn,
  }) : assert(
          (isConnected && connectionData != null) || !isConnected,
          'connectionData must not be null when isConnected',
        );

  final bool isConnected;

  final ConnectionData? connectionData;

  final GyverLampMode mode;

  final int brightness;

  final int speed;

  final int scale;

  final bool isOn;

  ControlState copyWith({
    bool? isConnected,
    ConnectionData? connectionData,
    GyverLampMode? mode,
    int? brightness,
    int? speed,
    int? scale,
    bool? isOn,
  }) {
    return ControlState(
      isConnected: isConnected ?? this.isConnected,
      connectionData: connectionData ?? this.connectionData,
      mode: mode ?? this.mode,
      brightness: brightness ?? this.brightness,
      speed: speed ?? this.speed,
      scale: scale ?? this.scale,
      isOn: isOn ?? this.isOn,
    );
  }

  ControlState copyWithConnectionState({
    required bool isConnected,
    required ConnectionData? connectionData,
  }) {
    return ControlState(
      isConnected: isConnected,
      connectionData: connectionData,
      mode: mode,
      brightness: brightness,
      speed: speed,
      scale: scale,
      isOn: isOn,
    );
  }

  @override
  List<Object?> get props => [
        isConnected,
        connectionData,
        mode,
        brightness,
        speed,
        scale,
        isOn,
      ];
}
