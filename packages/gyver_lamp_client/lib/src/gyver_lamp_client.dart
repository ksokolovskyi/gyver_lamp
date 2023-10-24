import 'dart:async';
import 'dart:io';

import 'package:gyver_lamp_client/src/src.dart';

/// {@template gyver_lamp_client_exception}
/// Exception thrown when data sending or retrieving failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class GyverLampClientException implements Exception {
  /// {@macro gyver_lamp_client_exception}
  const GyverLampClientException(this.cause, this.stackTrace);

  /// The cause of the exception.
  final dynamic cause;

  /// The stack trace of the exception.
  final StackTrace stackTrace;
}

/// A factory to create a [GyverLampConnection] instance.
typedef GyverLampConnectionFactory = GyverLampConnection Function({
  RawDatagramSocketFactory socketFactory,
  Duration timeout,
});

/// A typedef for logging callback.
typedef LoggerCallback = void Function(String address, int port, Object data);

/// {@template gyver_lamp_client}
/// Wrapper around [GyverLampConnection] for easy and safe communication with
/// the lamp.
/// {@endtemplate}
class GyverLampClient {
  /// {@macro gyver_lamp_client}
  GyverLampClient({
    RawDatagramSocketFactory socketFactory = RawDatagramSocket.bind,
    Duration timeout = const Duration(seconds: 5),
    GyverLampConnectionFactory connectionFactory = GyverLampConnection.new,
    LoggerCallback? onSend,
    LoggerCallback? onResponse,
    LoggerCallback? onError,
  })  : _connection = connectionFactory(
          socketFactory: socketFactory,
          timeout: timeout,
        ),
        _onSend = onSend,
        _onResponse = onResponse,
        _onError = onError,
        _controller = StreamController.broadcast();

  final GyverLampConnection _connection;

  final StreamController<GyverLampResponse> _controller;

  final LoggerCallback? _onSend;

  final LoggerCallback? _onResponse;

  final LoggerCallback? _onError;

  /// The stream of all responses from the client.
  Stream<GyverLampResponse> get responses => _controller.stream;

  /// Whether the client is closed.
  ///
  /// When client is closed it can't be used anymore.
  bool get isClosed => _controller.isClosed;

  /// Releases the resources.
  Future<void> close() async {
    await _connection.close();
    await _controller.close();
  }

  /// Requests the current state of the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampCurrentResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> getCurrentState({
    required String address,
    required int port,
  }) async {
    return sendRaw(
      address: address,
      port: port,
      event: 'GET',
    );
  }

  /// Sends a ping request to the lamp.
  ///
  /// This function can be used to ensure that lamp is accessible.
  /// Typically lamp responds to this request with the
  /// [GyverLampOkResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> ping({
    required String address,
    required int port,
  }) async {
    return sendRaw(
      address: address,
      port: port,
      event: 'DEB',
    );
  }

  /// Updates the currently selected mode on the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampCurrentResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> setMode({
    required String address,
    required int port,
    required int mode,
  }) async {
    assert(
      mode >= 0 && mode <= 17,
      'the mode value range is [0, 17]',
    );

    return sendRaw(
      address: address,
      port: port,
      event: 'EFF $mode',
    );
  }

  /// Updates the brightness level of the selected mode on the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampBrightnessResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> setBrightness({
    required String address,
    required int port,
    required int brightness,
  }) async {
    assert(
      brightness > 0 && brightness <= 255,
      'the brightness value range is [1, 255]',
    );

    return sendRaw(
      address: address,
      port: port,
      event: 'BRI $brightness',
    );
  }

  /// Updates the speed value of the selected mode on the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampSpeedResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> setSpeed({
    required String address,
    required int port,
    required int speed,
  }) async {
    assert(
      speed > 0 && speed <= 255,
      'the speed value range is [1, 255]',
    );

    return sendRaw(
      address: address,
      port: port,
      event: 'SPD $speed',
    );
  }

  /// Updates the scale value of the selected mode on the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampScaleResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> setScale({
    required String address,
    required int port,
    required int scale,
  }) async {
    assert(
      scale > 0 && scale <= 255,
      'the scale value range is [1, 255]',
    );

    return sendRaw(
      address: address,
      port: port,
      event: 'SCA $scale',
    );
  }

  /// Turns on the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampCurrentResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> turnOn({
    required String address,
    required int port,
  }) async {
    return sendRaw(
      address: address,
      port: port,
      event: 'P_ON',
    );
  }

  /// Turns off the lamp.
  ///
  /// Typically lamp responds to this request with the
  /// [GyverLampCurrentResponse].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> turnOff({
    required String address,
    required int port,
  }) async {
    return sendRaw(
      address: address,
      port: port,
      event: 'P_OFF',
    );
  }

  /// Sends passed [event] to the lamp.
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> sendRaw({
    required String address,
    required int port,
    required String event,
  }) async {
    if (isClosed) {
      throw GyverLampClientException(
        'Client is closed',
        StackTrace.current,
      );
    }

    try {
      _onSend?.call(address, port, event);

      final response = await _connection.send(
        address: address,
        port: port,
        event: event,
      );

      _onResponse?.call(address, port, response);

      _controller.add(response);

      return response;
    } catch (e) {
      _onError?.call(address, port, e);
      rethrow;
    }
  }
}
