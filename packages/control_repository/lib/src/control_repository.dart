import 'dart:async';

import 'package:control_repository/src/src.dart';
import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:meta/meta.dart';

/// {@template control_exception}
/// Exception thrown when control action fails.
/// {@endtemplate}
class ControlException implements Exception {
  /// {@macro control_exception}
  const ControlException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;
}

/// {@template control_repository}
/// Repository to control the lamp.
/// {@endtemplate}
class ControlRepository {
  /// {@macro control_repository}
  ControlRepository({
    required GyverLampClient client,
  })  : _client = client,
        _controller = StreamController.broadcast();

  final GyverLampClient _client;

  final StreamController<GyverLampMessage> _controller;
  StreamSubscription<GyverLampResponse>? _subscription;

  /// Whether this repository is disposed
  ///
  /// When repository is disposed it can't be used anymore.
  @visibleForTesting
  bool get isDisposed => _controller.isClosed;

  /// The stream of messages from lamp.
  Stream<GyverLampMessage> get messages {
    _subscription ??= _client.responses.listen((response) {
      switch (response) {
        case GyverLampCurrentResponse():
          _controller.add(
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fromIndex(response.mode),
              brightness: response.brightness,
              speed: response.speed,
              scale: response.scale,
              isOn: response.isOn,
            ),
          );

        case GyverLampBrightnessResponse():
          _controller.add(
            GyverLampBrightnessChangedMessage(brightness: response.brightness),
          );

        case GyverLampSpeedResponse():
          _controller.add(
            GyverLampSpeedChangedMessage(speed: response.speed),
          );

        case GyverLampScaleResponse():
          _controller.add(
            GyverLampScaleChangedMessage(scale: response.scale),
          );

        case GyverLampOkResponse():
        case GyverLampUnknownResponse():
        // just ignore those
      }
    });

    return _controller.stream;
  }

  /// Requests the current state of the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> requestCurrentState({
    required String address,
    required int port,
  }) async {
    try {
      await _client.getCurrentState(
        address: address,
        port: port,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Updates the currently selected mode on the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> setMode({
    required String address,
    required int port,
    required GyverLampMode mode,
  }) async {
    try {
      await _client.setMode(
        address: address,
        port: port,
        mode: mode.index,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Updates the brightness level of the selected mode on the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> setBrightness({
    required String address,
    required int port,
    required int brightness,
  }) async {
    try {
      await _client.setBrightness(
        address: address,
        port: port,
        brightness: brightness,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Updates the speed value of the selected mode on the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> setSpeed({
    required String address,
    required int port,
    required int speed,
  }) async {
    try {
      await _client.setSpeed(
        address: address,
        port: port,
        speed: speed,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Updates the speed value of the selected mode on the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> setScale({
    required String address,
    required int port,
    required int scale,
  }) async {
    try {
      await _client.setScale(
        address: address,
        port: port,
        scale: scale,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Turns on the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> turnOn({
    required String address,
    required int port,
  }) async {
    try {
      await _client.turnOn(
        address: address,
        port: port,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Turns off the lamp.
  ///
  /// Throws a [ControlException] in case of exceptions from client.
  Future<void> turnOff({
    required String address,
    required int port,
  }) async {
    try {
      await _client.turnOff(
        address: address,
        port: port,
      );
    } catch (e, t) {
      throw ControlException(e, t);
    }
  }

  /// Disposes any internal resources.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    _controller.close();
  }
}
