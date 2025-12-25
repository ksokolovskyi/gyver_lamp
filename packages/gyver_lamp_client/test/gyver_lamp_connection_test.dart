import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gyver_lamp_client/src/src.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRawDatagramSocket extends Mock implements RawDatagramSocket {}

class _MockRawDatagramSocketFactory extends Mock {
  FutureOr<RawDatagramSocket> call(
    String host,
    int port,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(InternetAddress.tryParse('0.0.0.0'));
  });

  group('GyverLampConnection', () {
    const address = '192.168.1.1';
    const port = 8888;
    const timeout = Duration(milliseconds: 200);

    final debugDatagram = Datagram(
      Uint8List.fromList(utf8.encode('OK 11.22.63')),
      InternetAddress(address),
      port,
    );

    // ignore: prefer_const_constructors
    final debugResponse = GyverLampOkResponse(timestamp: '11.22.63');

    late GyverLampConnection subject;
    late RawDatagramSocket socket;
    late RawDatagramSocketFactory socketFactory;
    late StreamController<RawSocketEvent> eventsStreamController;

    setUp(() {
      eventsStreamController = StreamController.broadcast();

      socket = _MockRawDatagramSocket();

      when(
        () => socket.listen(
          any(),
          onDone: any(named: 'onDone'),
          onError: any(named: 'onError'),
          cancelOnError: any(named: 'cancelOnError'),
        ),
      ).thenAnswer(
        (invocation) {
          final positional = invocation.positionalArguments;
          final named = invocation.namedArguments;

          return eventsStreamController.stream.listen(
            (event) async {
              final closure =
                  positional.first as FutureOr<void> Function(RawSocketEvent);
              await closure(event);
            },
            onDone: named[#onDone] as void Function()?,
            onError: named[#onError] as void Function(Object, StackTrace)?,
            cancelOnError: named[#cancelOnError] as bool? ?? false,
          );
        },
      );

      when(
        () => socket.send(any(), any(), any()),
      ).thenAnswer(
        (invocation) {
          final positional = invocation.positionalArguments;
          return (positional.first as List<int>).length;
        },
      );

      when(socket.receive).thenReturn(debugDatagram);

      when(socket.close).thenAnswer((_) {});

      socketFactory = _MockRawDatagramSocketFactory().call;

      when(
        () => socketFactory(any(), any()),
      ).thenAnswer(
        (_) async => socket,
      );

      subject = GyverLampConnection(
        socketFactory: socketFactory,
        timeout: timeout,
      );
    });

    tearDown(() {
      eventsStreamController.close();
      subject.close();
    });

    test('can be instantiated', () {
      expect(
        GyverLampConnection(socketFactory: socketFactory),
        isNotNull,
      );
    });

    group('isClosed', () {
      test('true by default', () {
        expect(
          GyverLampConnection(socketFactory: socketFactory),
          isA<GyverLampConnection>().having(
            (c) => c.isClosed,
            'isClosed',
            isTrue,
          ),
        );
      });

      test('false after binding', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );
      });

      test('true after binding and closing', () async {
        await subject.bind();
        await subject.close();

        expect(
          subject.isClosed,
          isTrue,
        );
      });
    });

    group('bind', () {
      test('calls factory to create new socket', () async {
        await subject.bind();

        verify(
          () => socketFactory.call(
            any(
              that: isA<String>().having(
                (a) => RegExp(r'\d+.\d+.\d+.\d+').hasMatch(a),
                'IPv4 format',
                isTrue,
              ),
            ),
            0,
          ),
        ).called(1);
      });

      test('subscribes to the events stream', () async {
        await subject.bind();

        verify(
          () => socket.listen(
            any(),
            onDone: any(named: 'onDone'),
            onError: any(named: 'onError'),
            cancelOnError: any(named: 'cancelOnError'),
          ),
        ).called(1);
      });

      test('throws GyverLampClientException when exception happens', () async {
        when(
          () => socketFactory(any(), any()),
        ).thenThrow(
          ArgumentError('TEST'),
        );

        await expectLater(
          () => subject.bind(),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                equals(
                  'TEST',
                ),
              ),
            ),
          ),
        );
      });

      test('calls close when the events stream is done', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );

        await eventsStreamController.close();

        await Future<void>.delayed(
          const Duration(milliseconds: 20),
        );

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });

      test('calls close when the events stream has error', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );

        eventsStreamController.addError(TimeoutException('TEST'));

        await Future<void>.delayed(
          const Duration(milliseconds: 20),
        );

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });

      test('calls close when the events stream has closed event', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );

        eventsStreamController.add(RawSocketEvent.closed);

        await Future<void>.delayed(
          const Duration(milliseconds: 20),
        );

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });

      test('calls close when the events stream has readClosed event', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );

        eventsStreamController.add(RawSocketEvent.readClosed);

        await Future<void>.delayed(
          const Duration(milliseconds: 20),
        );

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });

      test('does not call close '
          'when the events stream has write event', () async {
        await subject.bind();

        expect(
          subject.isClosed,
          isFalse,
        );

        eventsStreamController.add(RawSocketEvent.write);

        await Future<void>.delayed(
          const Duration(milliseconds: 20),
        );

        verifyNever(
          () => socket.close(),
        );

        expect(
          subject.isClosed,
          isFalse,
        );
      });
    });

    group('close', () {
      test('closes the connection', () async {
        await subject.bind();
        await subject.close();

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });
    });

    group('send', () {
      test('creates socket and subscribes to the events '
          'when connection is closed', () async {
        expect(
          subject.isClosed,
          isTrue,
        );

        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        await subject.send(
          address: address,
          port: port,
          event: 'DEB',
        );

        verify(
          () => socket.send(
            utf8.encode('DEB'),
            InternetAddress(address),
            port,
          ),
        ).called(1);

        verify(
          () => socketFactory.call(
            any(
              that: isA<String>().having(
                (a) => RegExp(r'\d+.\d+.\d+.\d+').hasMatch(a),
                'IPv4 format',
                isTrue,
              ),
            ),
            0,
          ),
        ).called(1);

        verify(
          () => socket.listen(
            any(),
            onDone: any(named: 'onDone'),
            onError: any(named: 'onError'),
            cancelOnError: any(named: 'cancelOnError'),
          ),
        ).called(1);

        expect(
          subject.isClosed,
          isFalse,
        );
      });

      test('returns response when everything is ok', () async {
        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        final response = await subject.send(
          address: address,
          port: port,
          event: 'DEB',
        );

        expect(
          response,
          equals(debugResponse),
        );
      });

      test('throws GyverLampClientException and calls close '
          'when send is not successful', () async {
        when(
          () => socket.send(any(), any(), any()),
        ).thenReturn(0);

        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals(
                'Message was not sent',
              ),
            ),
          ),
        );

        verify(
          () => socket.close(),
        ).called(1);

        expect(
          subject.isClosed,
          isTrue,
        );
      });

      test('throws GyverLampResponseParseException '
          'when datagram is not present', () async {
        when(
          () => socket.receive(),
        ).thenReturn(null);

        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampResponseParseException>().having(
              (e) => e.cause,
              'cause',
              equals(
                'Datagram is empty',
              ),
            ),
          ),
        );
      });

      test('throws GyverLampResponseParseException '
          'when response format is wrong', () async {
        when(
          () => socket.receive(),
        ).thenReturn(
          Datagram(
            Uint8List.fromList(utf8.encode('OK11.22.63')),
            InternetAddress(address),
            port,
          ),
        );

        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampResponseParseException>(),
          ),
        );
      });

      test('throws GyverLampClientException '
          'when response is malformed', () async {
        when(
          () => socket.receive(),
        ).thenReturn(
          Datagram(
            Uint8List.fromList('©'.codeUnits),
            InternetAddress(address),
            port,
          ),
        );

        eventsStreamController.onListen = () {
          eventsStreamController.sink.add(RawSocketEvent.read);
        };

        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              isA<FormatException>().having(
                (e) => e.message,
                'message',
                equals(
                  'Unexpected extension byte',
                ),
              ),
            ),
          ),
        );
      });

      test('throws GyverLampClientException '
          'when client is closed during the datagram process', () async {
        eventsStreamController.onListen = () async {
          await subject.close();
        };

        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              isA<TimeoutException>().having(
                (e) => e.message,
                'message',
                equals(
                  'Future not completed',
                ),
              ),
            ),
          ),
        );
      });

      test('throws GyverLampClientException '
          'when no response from the lamp causes timeout', () async {
        await expectLater(
          () => subject.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              isA<TimeoutException>().having(
                (e) => e.message,
                'message',
                equals(
                  'Future not completed',
                ),
              ),
            ),
          ),
        );
      });
    });
  });
}
