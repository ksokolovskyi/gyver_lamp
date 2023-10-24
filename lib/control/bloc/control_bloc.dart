import 'dart:async';

import 'package:control_repository/control_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  ControlBloc({
    required ControlRepository controlRepository,
    required bool isConnected,
    required ConnectionData? connectionData,
  })  : _controlRepository = controlRepository,
        super(
          ControlState(
            isConnected: isConnected,
            connectionData: connectionData,
            mode: GyverLampMode.fromIndex(0),
            brightness: 128,
            speed: 30,
            scale: 10,
            isOn: false,
          ),
        ) {
    on<ControlRequested>(_onControlRequested);
    on<ConnectionStateUpdated>(_onConnectionStateUpdated);
    on<LampMessageReceived>(_onLampMessageReceived);
    on<ModeUpdated>(_onModeUpdated);
    on<BrightnessUpdated>(_onBrightnessUpdated);
    on<SpeedUpdated>(_onSpeedUpdated);
    on<ScaleUpdated>(_onScaleUpdated);
    on<PowerToggled>(_onPowerToggled);
  }

  final ControlRepository _controlRepository;

  StreamSubscription<GyverLampMessage>? _messageSubscription;

  @override
  Future<void> close() async {
    await _unsubscribeFromMessages();
    return super.close();
  }

  Future<void> _subscribeToMessages() async {
    await _unsubscribeFromMessages();

    _messageSubscription = _controlRepository.messages.listen(
      (message) {
        add(
          LampMessageReceived(message: message),
        );
      },
    );
  }

  Future<void> _unsubscribeFromMessages() async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  Future<void> _onControlRequested(
    ControlRequested event,
    Emitter<ControlState> emit,
  ) async {
    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      await _subscribeToMessages();

      await _controlRepository.requestCurrentState(
        address: connectionData.address,
        port: connectionData.port,
      );
    } catch (e, t) {
      addError(e, t);
    }
  }

  Future<void> _onConnectionStateUpdated(
    ConnectionStateUpdated event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWithConnectionState(
        isConnected: event.isConnected,
        connectionData: event.connectionData,
      ),
    );

    if (event.isConnected) {
      add(const ControlRequested());
    } else {
      await _unsubscribeFromMessages();
    }
  }

  Future<void> _onLampMessageReceived(
    LampMessageReceived event,
    Emitter<ControlState> emit,
  ) async {
    final message = event.message;

    switch (message) {
      case GyverLampStateChangedMessage():
        emit(
          state.copyWith(
            mode: message.mode,
            brightness: message.brightness,
            speed: message.speed,
            scale: message.scale,
            isOn: message.isOn,
          ),
        );

      case GyverLampBrightnessChangedMessage():
        emit(
          state.copyWith(brightness: message.brightness),
        );

      case GyverLampSpeedChangedMessage():
        emit(
          state.copyWith(speed: message.speed),
        );

      case GyverLampScaleChangedMessage():
        emit(
          state.copyWith(scale: message.scale),
        );
    }
  }

  Future<void> _onModeUpdated(
    ModeUpdated event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWith(mode: event.mode),
    );

    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      await _controlRepository.setMode(
        address: connectionData.address,
        port: connectionData.port,
        mode: event.mode,
      );
    } catch (e, t) {
      addError(e, t);
    }
  }

  Future<void> _onBrightnessUpdated(
    BrightnessUpdated event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWith(brightness: event.brightness),
    );

    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      await _controlRepository.setBrightness(
        address: connectionData.address,
        port: connectionData.port,
        brightness: event.brightness,
      );
    } catch (e, t) {
      addError(e, t);
    }
  }

  Future<void> _onSpeedUpdated(
    SpeedUpdated event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWith(speed: event.speed),
    );

    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      await _controlRepository.setSpeed(
        address: connectionData.address,
        port: connectionData.port,
        speed: event.speed,
      );
    } catch (e, t) {
      addError(e, t);
    }
  }

  Future<void> _onScaleUpdated(
    ScaleUpdated event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWith(scale: event.scale),
    );

    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      await _controlRepository.setScale(
        address: connectionData.address,
        port: connectionData.port,
        scale: event.scale,
      );
    } catch (e, t) {
      addError(e, t);
    }
  }

  Future<void> _onPowerToggled(
    PowerToggled event,
    Emitter<ControlState> emit,
  ) async {
    emit(
      state.copyWith(isOn: event.isOn),
    );

    if (!state.isConnected) {
      return;
    }

    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    try {
      if (event.isOn) {
        await _controlRepository.turnOn(
          address: connectionData.address,
          port: connectionData.port,
        );
      } else {
        await _controlRepository.turnOff(
          address: connectionData.address,
          port: connectionData.port,
        );
      }
    } catch (e, t) {
      addError(e, t);
    }
  }
}
