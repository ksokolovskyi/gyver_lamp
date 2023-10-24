import 'dart:async';

import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:meta/meta.dart';

/// {@template connection_exception}
/// Exception thrown when connection process fails.
/// {@endtemplate}
class ConnectionException implements Exception {
  /// {@macro connection_exception}
  const ConnectionException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The stack trace associated with the error.
  final StackTrace stackTrace;
}

/// Represents the current status of the connection
enum ConnectionStatus {
  /// Represents a connection status.
  connecting,

  /// Represents a connected status.
  connected,

  /// Represents a disconnected status.
  disconnected,
}

/// {@template connection_repository}
/// Repository to manage connection.
/// {@endtemplate}
class ConnectionRepository {
  /// {@macro connection_repository}
  ConnectionRepository({
    required GyverLampClient client,
    Duration period = const Duration(seconds: 2),
  })  : _client = client,
        _period = period,
        _controller = StreamController.broadcast();

  final GyverLampClient _client;

  final Duration _period;

  final StreamController<ConnectionStatus> _controller;

  StreamSubscription<int>? _subscription;

  /// The stream of connection statuses.
  Stream<ConnectionStatus> get statuses => _controller.stream.distinct();

  /// Whether this repository is disposed
  ///
  /// When repository is disposed it can't be used anymore.
  @visibleForTesting
  bool get isDisposed => _controller.isClosed;

  /// Disposes any internal resources.
  Future<void> dispose() async {
    await disconnect();
    await _controller.close();
  }

  /// Pings the lamp, and if it was successful, constantly pings it until
  /// [disconnect] is called.
  Future<void> connect({
    required String address,
    required int port,
  }) async {
    try {
      _controller.add(ConnectionStatus.connecting);

      await _client.ping(
        address: address,
        port: port,
      );

      _controller.add(ConnectionStatus.connected);

      _subscription = Stream<int>.periodic(
        _period,
        (_) => _,
      ).listen(
        (_) async {
          if (_subscription == null || _controller.isClosed) {
            return;
          }

          try {
            await _client.ping(
              address: address,
              port: port,
            );

            _controller.add(ConnectionStatus.connected);
          } catch (e) {
            await disconnect();
          }
        },
        cancelOnError: true,
      );
    } catch (e, t) {
      _controller.add(ConnectionStatus.disconnected);
      throw ConnectionException(e, t);
    }
  }

  /// Stops constant sending of the ping requests to the lamp
  Future<void> disconnect() async {
    _controller.add(ConnectionStatus.disconnected);

    await _subscription?.cancel();
    _subscription = null;
  }
}
