import 'package:gyver_lamp_client/src/src.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockGyverLampConnection extends Mock implements GyverLampConnection {}

class _MockGyverLampConnectionFactory extends Mock {
  GyverLampConnection call({
    RawDatagramSocketFactory socketFactory,
    Duration timeout,
  });
}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  group('GyverLampClient', () {
    const address = '192.168.1.1';
    const port = 8888;

    // ignore: prefer_const_constructors
    final expectedResponse = GyverLampOkResponse(timestamp: '11.22.63');

    late GyverLampClient subject;
    late GyverLampConnection connection;
    late GyverLampConnectionFactory connectionFactory;

    setUp(() {
      connection = _MockGyverLampConnection();

      when(connection.close).thenAnswer((_) async {});

      connectionFactory = _MockGyverLampConnectionFactory().call;

      when(
        () => connectionFactory(
          socketFactory: any(named: 'socketFactory'),
          timeout: any(named: 'timeout'),
        ),
      ).thenReturn(connection);

      when(
        () => connection.send(
          address: any(named: 'address'),
          port: any(named: 'port'),
          event: any(named: 'event'),
        ),
      ).thenAnswer(
        (_) async => expectedResponse,
      );

      subject = GyverLampClient(connectionFactory: connectionFactory);
    });

    tearDown(() async {
      await subject.close();
    });

    test('can be instantiated', () {
      expect(
        GyverLampClient(connectionFactory: connectionFactory),
        isNotNull,
      );
    });

    group('close', () {
      test('calls connection close', () async {
        await subject.close();
        verify(connection.close).called(1);
      });

      test('closes the client', () async {
        expect(subject.isClosed, isFalse);

        await subject.close();

        expect(subject.isClosed, isTrue);
      });
    });

    group('getCurrentState', () {
      test('returns the response', () async {
        final response = await subject.getCurrentState(
          address: address,
          port: port,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.getCurrentState(
          address: address,
          port: port,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'GET',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.getCurrentState(
            address: address,
            port: port,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });
    });

    group('ping', () {
      test('returns the response', () async {
        final response = await subject.ping(
          address: address,
          port: port,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.ping(
          address: address,
          port: port,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'DEB',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.ping(
            address: address,
            port: port,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });
    });

    group('setMode', () {
      test('returns the response', () async {
        final response = await subject.setMode(
          address: address,
          port: port,
          mode: 3,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.setMode(
          address: address,
          port: port,
          mode: 3,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'EFF 3',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.setMode(
            address: address,
            port: port,
            mode: 3,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });

      test('throws AssertionError when mode is less than 0', () async {
        await expectLater(
          () => subject.setMode(
            address: address,
            port: port,
            mode: -1,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the mode value range is [0, 17]',
              ),
            ),
          ),
        );
      });

      test('throws AssertionError when mode is greater than 17', () async {
        await expectLater(
          () => subject.setMode(
            address: address,
            port: port,
            mode: 18,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the mode value range is [0, 17]',
              ),
            ),
          ),
        );
      });
    });

    group('setBrightness', () {
      test('returns the response', () async {
        final response = await subject.setBrightness(
          address: address,
          port: port,
          brightness: 33,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.setBrightness(
          address: address,
          port: port,
          brightness: 33,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'BRI 33',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.setBrightness(
            address: address,
            port: port,
            brightness: 33,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });

      test('throws AssertionError when brightness is less than 1', () async {
        await expectLater(
          () => subject.setBrightness(
            address: address,
            port: port,
            brightness: 0,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the brightness value range is [1, 255]',
              ),
            ),
          ),
        );
      });

      test('throws AssertionError '
          'when brightness is greater than 255', () async {
        await expectLater(
          () => subject.setBrightness(
            address: address,
            port: port,
            brightness: 256,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the brightness value range is [1, 255]',
              ),
            ),
          ),
        );
      });
    });

    group('setSpeed', () {
      test('returns the response', () async {
        final response = await subject.setSpeed(
          address: address,
          port: port,
          speed: 33,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.setSpeed(
          address: address,
          port: port,
          speed: 33,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'SPD 33',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.setSpeed(
            address: address,
            port: port,
            speed: 33,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });

      test('throws AssertionError when speed is less than 1', () async {
        await expectLater(
          () => subject.setSpeed(
            address: address,
            port: port,
            speed: 0,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the speed value range is [1, 255]',
              ),
            ),
          ),
        );
      });

      test('throws AssertionError '
          'when speed is greater than 255', () async {
        await expectLater(
          () => subject.setSpeed(
            address: address,
            port: port,
            speed: 256,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the speed value range is [1, 255]',
              ),
            ),
          ),
        );
      });
    });

    group('setScale', () {
      test('returns the response', () async {
        final response = await subject.setScale(
          address: address,
          port: port,
          scale: 33,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.setScale(
          address: address,
          port: port,
          scale: 33,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'SCA 33',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.setScale(
            address: address,
            port: port,
            scale: 33,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });

      test('throws AssertionError when scale is less than 1', () async {
        await expectLater(
          () => subject.setScale(
            address: address,
            port: port,
            scale: 0,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the scale value range is [1, 255]',
              ),
            ),
          ),
        );
      });

      test('throws AssertionError '
          'when scale is greater than 255', () async {
        await expectLater(
          () => subject.setScale(
            address: address,
            port: port,
            scale: 256,
          ),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              equals(
                'the scale value range is [1, 255]',
              ),
            ),
          ),
        );
      });
    });

    group('turnOn', () {
      test('returns the response', () async {
        final response = await subject.turnOn(
          address: address,
          port: port,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.turnOn(
          address: address,
          port: port,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'P_ON',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.turnOn(
            address: address,
            port: port,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });
    });

    group('turnOff', () {
      test('returns the response', () async {
        final response = await subject.turnOff(
          address: address,
          port: port,
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.turnOff(
          address: address,
          port: port,
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'P_OFF',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.turnOff(
            address: address,
            port: port,
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });
    });

    group('sendRaw', () {
      test('returns the response', () async {
        final response = await subject.sendRaw(
          address: address,
          port: port,
          event: 'TEST',
        );

        expect(
          response,
          equals(expectedResponse),
        );
      });

      test('sends the request correctly', () async {
        await subject.sendRaw(
          address: address,
          port: port,
          event: 'TEST',
        );

        verify(
          () => connection.send(
            address: address,
            port: port,
            event: 'TEST',
          ),
        ).called(1);
      });

      test('throws a GyverLampClientException when client is closed', () async {
        await subject.close();

        await expectLater(
          () => subject.sendRaw(
            address: address,
            port: port,
            event: 'TEST',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              equals('Client is closed'),
            ),
          ),
        );
      });

      test('calls onSend callback', () async {
        String? loggedAddress;
        int? loggedPort;
        Object? loggedData;

        final subject = GyverLampClient(
          connectionFactory: connectionFactory,
          onSend: (address, port, data) {
            loggedAddress = address;
            loggedPort = port;
            loggedData = data;
          },
        );

        await subject.sendRaw(
          address: address,
          port: port,
          event: 'TEST',
        );
        await subject.close();

        expect(loggedAddress, equals(address));
        expect(loggedPort, equals(port));
        expect(loggedData, equals('TEST'));
      });

      test('calls onResponse callback', () async {
        String? loggedAddress;
        int? loggedPort;
        Object? loggedData;

        final subject = GyverLampClient(
          connectionFactory: connectionFactory,
          onResponse: (address, port, data) {
            loggedAddress = address;
            loggedPort = port;
            loggedData = data;
          },
        );

        final response = await subject.sendRaw(
          address: address,
          port: port,
          event: 'TEST',
        );
        await subject.close();

        expect(loggedAddress, equals(address));
        expect(loggedPort, equals(port));
        expect(loggedData, equals(expectedResponse));
        expect(loggedData, equals(response));
      });

      test('calls onError callback', () async {
        when(
          () => connection.send(
            address: any(named: 'address'),
            port: any(named: 'port'),
            event: any(named: 'event'),
          ),
        ).thenThrow(
          GyverLampClientException(
            ArgumentError('ERROR'),
            StackTrace.empty,
          ),
        );

        String? loggedAddress;
        int? loggedPort;
        Object? loggedData;

        final subject = GyverLampClient(
          connectionFactory: connectionFactory,
          onError: (address, port, data) {
            loggedAddress = address;
            loggedPort = port;
            loggedData = data;
          },
        );

        await expectLater(
          () => subject.sendRaw(
            address: address,
            port: port,
            event: 'TEST',
          ),
          throwsA(
            isA<GyverLampClientException>().having(
              (e) => e.cause,
              'cause',
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'ERROR',
              ),
            ),
          ),
        );
        await subject.close();

        expect(loggedAddress, equals(address));
        expect(loggedPort, equals(port));
        expect(
          loggedData,
          isA<GyverLampClientException>().having(
            (e) => e.cause,
            'cause',
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'ERROR',
            ),
          ),
        );
      });
    });

    group('responses', () {
      test('emits response of getCurrentState', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.getCurrentState(
          address: address,
          port: port,
        );
      });

      test('emits response of ping', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.ping(
          address: address,
          port: port,
        );
      });

      test('emits response of setMode', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.setMode(
          address: address,
          port: port,
          mode: 3,
        );
      });

      test('emits response of setBrightness', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.setBrightness(
          address: address,
          port: port,
          brightness: 3,
        );
      });

      test('emits response of setSpeed', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.setSpeed(
          address: address,
          port: port,
          speed: 3,
        );
      });

      test('emits response of setScale', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.setScale(
          address: address,
          port: port,
          scale: 3,
        );
      });

      test('emits response of turnOn', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.turnOn(
          address: address,
          port: port,
        );
      });

      test('emits response of turnOff', () async {
        subject.responses.listen((event) {
          expectAsync1(
            (response) {
              expect(
                response,
                equals(expectedResponse),
              );
            },
          );
        });

        await subject.turnOff(
          address: address,
          port: port,
        );
      });
    });
  });
}
