import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:gyver_lamp_client/src/src.dart';

/// A factory to create and bind a [RawDatagramSocket] instance.
typedef RawDatagramSocketFactory = FutureOr<RawDatagramSocket> Function(
  String host,
  int port,
);

/// {@template gyver_lamp_connection}
/// Connection to the lamp to send and receive data.
/// {@endtemplate}
class GyverLampConnection {
  /// {@macro gyver_lamp_connection}
  GyverLampConnection({
    RawDatagramSocketFactory socketFactory = RawDatagramSocket.bind,
    Duration timeout = const Duration(seconds: 5),
  })  : _socketFactory = socketFactory,
        _timeout = timeout;

  final RawDatagramSocketFactory _socketFactory;
  final Duration _timeout;

  final _requestQueue = Queue<Future<void> Function()>();

  bool _isProcessingQueue = false;

  Completer<GyverLampResponse> _responseCompleter = Completer();

  RawDatagramSocket? _socket;
  StreamSubscription<RawSocketEvent>? _subscription;

  /// Whether the connection is closed.
  ///
  /// When connection is not closed it means that socket is live and listening
  /// for an events.
  bool get isClosed => _socket == null;

  /// Creates socket, binds it to the local address and port, and listens to the
  /// events.
  ///
  /// Throws a [GyverLampClientException] if something unexpected happens.
  Future<void> bind() async {
    try {
      _socket = await _socketFactory(InternetAddress.anyIPv4.address, 0);

      _subscription = _socket!.listen(
        (event) async {
          switch (event) {
            case RawSocketEvent.closed:
            case RawSocketEvent.readClosed:
              await close();

            case RawSocketEvent.read:
              _datagramListener(
                _socket?.receive(),
              );

            case RawSocketEvent.write:
            // do nothing
          }
        },
        onDone: () async {
          await close();
        },
        onError: (Object e, StackTrace t) async {
          await close();
        },
      );
    } catch (e, t) {
      throw GyverLampClientException(e, t);
    }
  }

  void _datagramListener(Datagram? datagram) {
    try {
      if (datagram == null) {
        throw GyverLampResponseParseException(
          'Datagram is empty',
          StackTrace.current,
        );
      }

      final data = utf8.decode(datagram.data);

      _responseCompleter.complete(
        parseResponse(data),
      );
    } on GyverLampResponseParseException catch (e) {
      _responseCompleter.completeError(e);
    } catch (e, t) {
      _responseCompleter.completeError(
        GyverLampClientException(e, t),
      );
    }

    _responseCompleter = Completer();
  }

  /// Releases the resources used by the connection.
  ///
  /// Connection still can be reused by calling [bind] function.
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;

    _socket?.close();
    _socket = null;

    // prevent potentially open futures from completing after re-connecting
    _responseCompleter = Completer();
  }

  /// Sends an [event] to the specified lamp's [address] and [port].
  ///
  /// Throws a [GyverLampResponseParseException] in case of malformed response.
  /// Throws a [GyverLampClientException] when data sending or retrieving
  /// failed.
  Future<GyverLampResponse> send({
    required String address,
    required int port,
    required String event,
  }) async {
    final completer = Completer<GyverLampResponse>();

    _requestQueue.add(() async {
      try {
        if (isClosed) {
          await bind();
        }

        final bytes = _socket?.send(
          utf8.encode(event),
          InternetAddress(address),
          port,
        );

        if (bytes == null || bytes == 0) {
          await close();

          throw GyverLampClientException(
            'Message was not sent',
            StackTrace.current,
          );
        }

        final response = await _responseCompleter.future.timeout(_timeout);

        completer.complete(response);
      } on GyverLampResponseParseException catch (e, t) {
        completer.completeError(e, t);
      } on GyverLampClientException catch (e, t) {
        completer.completeError(e, t);
      } catch (e, t) {
        completer.completeError(
          GyverLampClientException(e, t),
        );
      }

      _responseCompleter = Completer();
    });

    if (!_isProcessingQueue) {
      unawaited(_processQueue());
    }

    return completer.future;
  }

  Future<void> _processQueue() async {
    _isProcessingQueue = true;

    while (_requestQueue.isNotEmpty) {
      final request = _requestQueue.removeFirst();
      await request();
    }

    _isProcessingQueue = false;
  }
}
