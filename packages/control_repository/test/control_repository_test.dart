import 'dart:async';

import 'package:control_repository/control_repository.dart';
import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockGyverLampClient extends Mock implements GyverLampClient {}

void main() {
  group('ControlRepository', () {
    const address = '192.168.1.1';
    const port = 8888;

    const okResponse = GyverLampOkResponse(timestamp: '11.22.63');

    late GyverLampClient client;
    late ControlRepository subject;

    setUp(() {
      client = _MockGyverLampClient();
      subject = ControlRepository(client: client);
    });

    tearDown(() async {
      if (subject.isDisposed) {
        return;
      }

      subject.dispose();
    });

    test('can be instantiated', () {
      expect(
        ControlRepository(client: client),
        isNotNull,
      );
    });

    group('requestCurrentState', () {
      test('calls GyverLampClient.getCurrentState', () async {
        when(
          () => client.getCurrentState(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.requestCurrentState(
          address: address,
          port: port,
        );

        verify(
          () => client.getCurrentState(address: address, port: port),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.getCurrentState throws',
        () async {
          when(
            () => client.getCurrentState(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.requestCurrentState(
              address: address,
              port: port,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('setMode', () {
      test('calls GyverLampClient.setMode', () async {
        when(
          () => client.setMode(
            address: any(named: 'address'),
            port: any(named: 'port'),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.setMode(
          address: address,
          port: port,
          mode: GyverLampMode.fire,
        );

        verify(
          () => client.setMode(
            address: address,
            port: port,
            mode: GyverLampMode.fire.index,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.setMode throws',
        () async {
          when(
            () => client.setMode(
              address: any(named: 'address'),
              port: any(named: 'port'),
              mode: any(named: 'mode'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.setMode(
              address: address,
              port: port,
              mode: GyverLampMode.fire,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('setBrightness', () {
      test('calls GyverLampClient.setBrightness', () async {
        when(
          () => client.setBrightness(
            address: any(named: 'address'),
            port: any(named: 'port'),
            brightness: any(named: 'brightness'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.setBrightness(
          address: address,
          port: port,
          brightness: 33,
        );

        verify(
          () => client.setBrightness(
            address: address,
            port: port,
            brightness: 33,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.setBrightness throws',
        () async {
          when(
            () => client.setBrightness(
              address: any(named: 'address'),
              port: any(named: 'port'),
              brightness: any(named: 'brightness'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.setBrightness(
              address: address,
              port: port,
              brightness: 33,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('setSpeed', () {
      test('calls GyverLampClient.setSpeed', () async {
        when(
          () => client.setSpeed(
            address: any(named: 'address'),
            port: any(named: 'port'),
            speed: any(named: 'speed'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.setSpeed(
          address: address,
          port: port,
          speed: 33,
        );

        verify(
          () => client.setSpeed(
            address: address,
            port: port,
            speed: 33,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.setSpeed throws',
        () async {
          when(
            () => client.setSpeed(
              address: any(named: 'address'),
              port: any(named: 'port'),
              speed: any(named: 'speed'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.setSpeed(
              address: address,
              port: port,
              speed: 33,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('setScale', () {
      test('calls GyverLampClient.setScale', () async {
        when(
          () => client.setScale(
            address: any(named: 'address'),
            port: any(named: 'port'),
            scale: any(named: 'scale'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.setScale(
          address: address,
          port: port,
          scale: 33,
        );

        verify(
          () => client.setScale(
            address: address,
            port: port,
            scale: 33,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.setScale throws',
        () async {
          when(
            () => client.setScale(
              address: any(named: 'address'),
              port: any(named: 'port'),
              scale: any(named: 'scale'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.setScale(
              address: address,
              port: port,
              scale: 33,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('turnOn', () {
      test('calls GyverLampClient.turnOn', () async {
        when(
          () => client.turnOn(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.turnOn(
          address: address,
          port: port,
        );

        verify(
          () => client.turnOn(
            address: address,
            port: port,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.turnOn throws',
        () async {
          when(
            () => client.turnOn(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.turnOn(
              address: address,
              port: port,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('turnOff', () {
      test('calls GyverLampClient.turnOff', () async {
        when(
          () => client.turnOff(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenAnswer((_) async => okResponse);

        await subject.turnOff(
          address: address,
          port: port,
        );

        verify(
          () => client.turnOff(
            address: address,
            port: port,
          ),
        ).called(1);
      });

      test(
        'throws ControlException when GyverLampClient.turnOff throws',
        () async {
          when(
            () => client.turnOff(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(
            ArgumentError('TEST'),
          );

          await expectLater(
            () async => subject.turnOff(
              address: address,
              port: port,
            ),
            throwsA(
              isA<ControlException>().having(
                (e) => e.error,
                'error',
                isA<ArgumentError>().having(
                  (e) => e.message,
                  'message',
                  equals('TEST'),
                ),
              ),
            ),
          );
        },
      );
    });

    group('messages', () {
      test(
        'emits GyverLampStateChangedMessage when client emits '
        'GyverLampCurrentResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampCurrentResponse(
                mode: 0,
                brightness: 1,
                speed: 2,
                scale: 3,
                isOn: true,
              ),
            ]),
          );

          expect(
            subject.messages,
            emits(
              GyverLampStateChangedMessage(
                mode: GyverLampMode.fromIndex(0),
                brightness: 1,
                speed: 2,
                scale: 3,
                isOn: true,
              ),
            ),
          );
        },
      );

      test(
        'emits GyverLampBrightnessChangedMessage when client emits '
        'GyverLampBrightnessResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampBrightnessResponse(brightness: 1),
            ]),
          );

          expect(
            subject.messages,
            emits(const GyverLampBrightnessChangedMessage(brightness: 1)),
          );
        },
      );

      test(
        'emits GyverLampSpeedChangedMessage when client emits '
        'GyverLampCurrentResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampSpeedResponse(speed: 2),
            ]),
          );

          expect(
            subject.messages,
            emits(const GyverLampSpeedChangedMessage(speed: 2)),
          );
        },
      );

      test(
        'emits GyverLampStateChangedMessage when client emits '
        'GyverLampScaleResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampScaleResponse(scale: 3),
            ]),
          );

          expect(
            subject.messages,
            emits(const GyverLampScaleChangedMessage(scale: 3)),
          );
        },
      );

      test(
        'emits nothing when client emits GyverLampOkResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampOkResponse(timestamp: '11.22.63'),
            ]),
          );

          final messages = <GyverLampMessage>[];

          final subscription = subject.messages.listen(messages.add);
          await Future<void>.delayed(Duration.zero);

          await subscription.cancel();

          expect(messages, isEmpty);
        },
      );

      test(
        'emits nothing when client emits GyverLampUnknownResponse',
        () async {
          when(() => client.responses).thenAnswer(
            (_) => Stream.fromIterable([
              const GyverLampUnknownResponse(data: '123'),
            ]),
          );

          final messages = <GyverLampMessage>[];

          final subscription = subject.messages.listen(messages.add);
          await Future<void>.delayed(Duration.zero);

          await subscription.cancel();

          expect(messages, isEmpty);
        },
      );

      test('subscribes to the GyverLampClient.responses', () async {
        final responses = StreamController<GyverLampResponse>();
        addTearDown(responses.close);
        when(() => client.responses).thenAnswer((_) => responses.stream);

        final messages = <GyverLampMessage>[];
        final subscription = subject.messages.listen(messages.add);
        addTearDown(subscription.cancel);

        responses
          ..add(const GyverLampBrightnessResponse(brightness: 1))
          ..add(const GyverLampSpeedResponse(speed: 2));
        await Future<void>.delayed(Duration.zero);

        expect(
          messages,
          equals([
            const GyverLampBrightnessChangedMessage(brightness: 1),
            const GyverLampSpeedChangedMessage(speed: 2),
          ]),
        );

        messages.clear();

        responses.add(
          const GyverLampCurrentResponse(
            mode: 0,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(
          messages,
          equals([
            GyverLampStateChangedMessage(
              mode: GyverLampMode.fromIndex(0),
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: true,
            ),
          ]),
        );
      });
    });

    group('dispose', () {
      test('cancels subscription to the GyverLampClient.responses', () async {
        final responses = StreamController<GyverLampResponse>();
        addTearDown(responses.close);
        when(() => client.responses).thenAnswer((_) => responses.stream);

        final messages = <GyverLampMessage>[];
        final subscription = subject.messages.listen(messages.add);
        addTearDown(subscription.cancel);

        responses.add(const GyverLampBrightnessResponse(brightness: 1));
        await Future<void>.delayed(Duration.zero);

        expect(
          messages,
          equals([
            const GyverLampBrightnessChangedMessage(brightness: 1),
          ]),
        );

        messages.clear();

        subject.dispose();

        responses.add(const GyverLampSpeedResponse(speed: 2));
        await Future<void>.delayed(Duration.zero);

        expect(subject.isDisposed, isTrue);
        expect(messages, isEmpty);
      });
    });
  });
}
