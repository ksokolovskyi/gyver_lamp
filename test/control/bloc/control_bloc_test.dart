import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:mocktail/mocktail.dart';

class _MockControlRepository extends Mock implements ControlRepository {}

void main() {
  const defaultBrightness = 128;
  const defaultSpeed = 30;
  const defaultScale = 10;

  group('ConnectionBloc', () {
    const connectionData = ConnectionData(
      address: '192.168.1.5',
      port: 8888,
    );

    final exception = ControlException('error', StackTrace.current);

    late ControlRepository controlRepository;
    late StreamController<GyverLampMessage> messagesController;

    setUp(() {
      messagesController = StreamController();

      controlRepository = _MockControlRepository();
      when(() => controlRepository.messages).thenAnswer(
        (_) => messagesController.stream,
      );
    });

    tearDown(() {
      messagesController.close();
    });

    setUpAll(() {
      registerFallbackValue(GyverLampMode.values.first);
    });

    group('initial state is correct', () {
      test('when connectionData is null', () {
        final bloc = ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        );

        expect(
          bloc.state,
          equals(
            ControlState(
              isConnected: false,
              connectionData: null,
              mode: GyverLampMode.values.first,
              brightness: defaultBrightness,
              speed: defaultSpeed,
              scale: defaultScale,
              isOn: false,
            ),
          ),
        );
      });

      test('when connectionData is not null', () {
        final bloc = ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        );

        expect(
          bloc.state,
          equals(
            ControlState(
              isConnected: true,
              connectionData: connectionData,
              mode: GyverLampMode.values.first,
              brightness: defaultBrightness,
              speed: defaultSpeed,
              scale: defaultScale,
              isOn: false,
            ),
          ),
        );
      });
    });

    group('on ControlRequested', () {
      blocTest<ControlBloc, ControlState>(
        'emits nothing when not connected',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        act: (bloc) => bloc.add(const ControlRequested()),
        expect: () => const <ControlState>[],
        verify: (bloc) => expect(bloc.state.isConnected, isFalse),
      );

      blocTest<ControlBloc, ControlState>(
        'calls ControlRepository.requestCurrentState',
        setUp: () {
          when(
            () => controlRepository.requestCurrentState(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(const ControlRequested()),
        expect: () => const <ControlState>[],
        verify: (_) {
          verify(
            () => controlRepository.requestCurrentState(
              address: connectionData.address,
              port: connectionData.port,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.requestCurrentState throws',
        setUp: () {
          when(
            () => controlRepository.requestCurrentState(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(const ControlRequested()),
        expect: () => const <ControlState>[],
        verify: (_) {
          verify(
            () => controlRepository.requestCurrentState(
              address: connectionData.address,
              port: connectionData.port,
            ),
          ).called(1);
        },
        errors: () => [exception],
      );

      blocTest<ControlBloc, ControlState>(
        'subscribes to the messages stream',
        setUp: () {
          when(
            () => controlRepository.requestCurrentState(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenAnswer((_) async => {});

          messagesController.onListen = () {
            messagesController.add(
              GyverLampStateChangedMessage(
                mode: GyverLampMode.values.last,
                brightness: 11,
                speed: 22,
                scale: 33,
                isOn: true,
              ),
            );
          };
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(const ControlRequested()),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.last,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: true,
          ),
        ],
      );
    });

    group('on LampMessageReceived', () {
      blocTest<ControlBloc, ControlState>(
        'emits updated state when messages stream emits '
        'GyverLampStateChangedMessage',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(
          LampMessageReceived(
            message: GyverLampStateChangedMessage(
              mode: GyverLampMode.values.last,
              brightness: 11,
              speed: 22,
              scale: 33,
              isOn: true,
            ),
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.last,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: true,
          ),
        ],
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state when messages stream emits '
        'GyverLampBrightnessChangedMessage',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(
          const LampMessageReceived(
            message: GyverLampBrightnessChangedMessage(brightness: 11),
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: defaultSpeed,
            scale: defaultScale,
            isOn: false,
          ),
        ],
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state when messages stream emits '
        'GyverLampSpeedChangedMessage',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(
          const LampMessageReceived(
            message: GyverLampSpeedChangedMessage(speed: 22),
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: defaultBrightness,
            speed: 22,
            scale: defaultScale,
            isOn: false,
          ),
        ],
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state when messages stream emits '
        'GyverLampScaleChangedMessage',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        act: (bloc) => bloc.add(
          const LampMessageReceived(
            message: GyverLampScaleChangedMessage(scale: 33),
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: defaultBrightness,
            speed: defaultSpeed,
            scale: 33,
            isOn: false,
          ),
        ],
      );
    });

    group('on ConnectionStateUpdated', () {
      blocTest<ControlBloc, ControlState>(
        'emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const ConnectionStateUpdated(
            isConnected: false,
            connectionData: null,
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state when isConnected is true and tries to connect',
        setUp: () {
          when(
            () => controlRepository.requestCurrentState(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: true,
          connectionData: connectionData,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const ConnectionStateUpdated(
            isConnected: true,
            connectionData: connectionData,
          ),
        ),
        expect: () => [
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          verify(
            () => controlRepository.requestCurrentState(
              address: connectionData.address,
              port: connectionData.port,
            ),
          ).called(1);
        },
      );
    });

    group('on ModeUpdated', () {
      blocTest<ControlBloc, ControlState>(
        'only emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          ModeUpdated(mode: GyverLampMode.values.last),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.last,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isFalse);
          expect(bloc.state.connectionData, isNull);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.setMode '
        'when isConnected and connectionData is not null',
        setUp: () {
          when(
            () => controlRepository.setMode(
              address: any(named: 'address'),
              port: any(named: 'port'),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          ModeUpdated(mode: GyverLampMode.values.last),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.last,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.setMode(
              address: connectionData.address,
              port: connectionData.port,
              mode: GyverLampMode.values.last,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.setMode throws',
        setUp: () {
          when(
            () => controlRepository.setMode(
              address: any(named: 'address'),
              port: any(named: 'port'),
              mode: any(named: 'mode'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          ModeUpdated(mode: GyverLampMode.values.last),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.last,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        errors: () => [exception],
      );
    });

    group('on BrightnessUpdated', () {
      blocTest<ControlBloc, ControlState>(
        'only emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const BrightnessUpdated(brightness: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 33,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isFalse);
          expect(bloc.state.connectionData, isNull);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.setBrightness '
        'when isConnected and connectionData is not null',
        setUp: () {
          when(
            () => controlRepository.setBrightness(
              address: any(named: 'address'),
              port: any(named: 'port'),
              brightness: any(named: 'brightness'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const BrightnessUpdated(brightness: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 33,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.setBrightness(
              address: connectionData.address,
              port: connectionData.port,
              brightness: 33,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.setBrightness throws',
        setUp: () {
          when(
            () => controlRepository.setBrightness(
              address: any(named: 'address'),
              port: any(named: 'port'),
              brightness: any(named: 'brightness'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const BrightnessUpdated(brightness: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 33,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        errors: () => [exception],
      );
    });

    group('on SpeedUpdated', () {
      blocTest<ControlBloc, ControlState>(
        'only emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const SpeedUpdated(speed: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 33,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isFalse);
          expect(bloc.state.connectionData, isNull);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.setSpeed '
        'when isConnected and connectionData is not null',
        setUp: () {
          when(
            () => controlRepository.setSpeed(
              address: any(named: 'address'),
              port: any(named: 'port'),
              speed: any(named: 'speed'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const SpeedUpdated(speed: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 33,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.setSpeed(
              address: connectionData.address,
              port: connectionData.port,
              speed: 33,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.setSpeed throws',
        setUp: () {
          when(
            () => controlRepository.setSpeed(
              address: any(named: 'address'),
              port: any(named: 'port'),
              speed: any(named: 'speed'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const SpeedUpdated(speed: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 33,
            scale: 3,
            isOn: false,
          ),
        ],
        errors: () => [exception],
      );
    });

    group('on ScaleUpdated', () {
      blocTest<ControlBloc, ControlState>(
        'only emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const ScaleUpdated(scale: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 33,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isFalse);
          expect(bloc.state.connectionData, isNull);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.setScale '
        'when isConnected and connectionData is not null',
        setUp: () {
          when(
            () => controlRepository.setScale(
              address: any(named: 'address'),
              port: any(named: 'port'),
              scale: any(named: 'scale'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const ScaleUpdated(scale: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 33,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.setScale(
              address: connectionData.address,
              port: connectionData.port,
              scale: 33,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.setScale throws',
        setUp: () {
          when(
            () => controlRepository.setScale(
              address: any(named: 'address'),
              port: any(named: 'port'),
              scale: any(named: 'scale'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const ScaleUpdated(scale: 33),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 33,
            isOn: false,
          ),
        ],
        errors: () => [exception],
      );
    });

    group('on PowerToggled', () {
      blocTest<ControlBloc, ControlState>(
        'only emits updated state when isConnected is false',
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: false,
          connectionData: null,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const PowerToggled(isOn: true),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isFalse);
          expect(bloc.state.connectionData, isNull);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.turnOn '
        'when isConnected, connectionData is not null and isOn',
        setUp: () {
          when(
            () => controlRepository.turnOn(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const PowerToggled(isOn: true),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.turnOn(
              address: connectionData.address,
              port: connectionData.port,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.turnOn throws',
        setUp: () {
          when(
            () => controlRepository.turnOn(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        act: (bloc) => bloc.add(
          const PowerToggled(isOn: true),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        ],
        errors: () => [exception],
      );

      blocTest<ControlBloc, ControlState>(
        'emits updated state and calls ControlRepository.turnOff '
        'when isConnected, connectionData is not null and not isOn',
        setUp: () {
          when(
            () => controlRepository.turnOff(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenAnswer((_) async => {});
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        act: (bloc) => bloc.add(
          const PowerToggled(isOn: false),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        verify: (bloc) {
          expect(bloc.state.isConnected, isTrue);
          expect(bloc.state.connectionData, isNotNull);
          verify(
            () => controlRepository.turnOff(
              address: connectionData.address,
              port: connectionData.port,
            ),
          ).called(1);
        },
      );

      blocTest<ControlBloc, ControlState>(
        'adds error when ControlRepository.turnOff throws',
        setUp: () {
          when(
            () => controlRepository.turnOff(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(exception);
        },
        build: () => ControlBloc(
          controlRepository: controlRepository,
          isConnected: false,
          connectionData: null,
        ),
        seed: () => ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: true,
        ),
        act: (bloc) => bloc.add(
          const PowerToggled(isOn: false),
        ),
        expect: () => <ControlState>[
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ],
        errors: () => [exception],
      );
    });
  });
}
