import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('ConnectionBloc', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    final exception = ConnectionException('error', StackTrace.current);

    late ConnectionRepository connectionRepository;
    late SettingsController settingsController;
    late StreamController<ConnectionStatus> statusesController;

    setUp(() {
      statusesController = StreamController();

      connectionRepository = _MockConnectionRepository();
      when(() => connectionRepository.statuses).thenAnswer(
        (_) => statusesController.stream,
      );
      when(
        () => connectionRepository.connect(
          address: any(named: 'address'),
          port: any(named: 'port'),
        ),
      ).thenAnswer((_) async {});
      when(connectionRepository.disconnect).thenAnswer((_) async {});

      settingsController = _MockSettingsController();
      when(
        () => settingsController.setIpAddress(
          ipAddress: any(named: 'ipAddress'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => settingsController.setPort(
          port: any(named: 'port'),
        ),
      ).thenAnswer((_) async {});
    });

    tearDown(() {
      statusesController.close();
    });

    group('initial state is correct', () {
      test('when initialConnectionData is null', () {
        final bloc = ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        );

        expect(
          bloc.state,
          equals(
            ConnectionInitial(
              address: IpAddressInput.pure(),
              port: PortInput.pure(),
            ),
          ),
        );
      });

      test('when initialConnectionData is not null', () {
        final bloc = ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
          initialConnectionData: ConnectionData(
            address: address.value,
            port: port.value,
          ),
        );

        expect(
          bloc.state,
          equals(
            ConnectionInitial(
              address: address,
              port: port,
            ),
          ),
        );
      });
    });

    group('on IpAddressUpdated', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial with updated address if not null passed',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        act: (bloc) => bloc.add(
          IpAddressUpdated(address: address.value),
        ),
        expect: () => [
          ConnectionInitial(
            address: address,
            port: PortInput.pure(),
          ),
        ],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial with dirty address if null passed',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
          initialConnectionData: ConnectionData(
            address: address.value,
            port: port.value,
          ),
        ),
        act: (bloc) => bloc.add(
          const IpAddressUpdated(address: null),
        ),
        expect: () => [
          ConnectionInitial(
            address: IpAddressInput.dirty(),
            port: port,
          ),
        ],
      );
    });

    group('on PortUpdated', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial with updated port if not null passed',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        act: (bloc) => bloc.add(
          PortUpdated(port: port.value),
        ),
        expect: () => [
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: port,
          ),
        ],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial with dirty port if null passed',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
          initialConnectionData: ConnectionData(
            address: address.value,
            port: port.value,
          ),
        ),
        act: (bloc) => bloc.add(
          const PortUpdated(port: null),
        ),
        expect: () => [
          ConnectionInitial(
            address: address,
            port: PortInput.dirty(),
          ),
        ],
      );
    });

    group('on ConnectionDataCheckRequested', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits nothing when connection data is valid',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(
          const ConnectionDataCheckRequested(),
        ),
        expect: () => const <ConnectionState>[],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits state with reset connection data when it was not valid',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(
          address: IpAddressInput.dirty('123'),
          port: PortInput.dirty(65536),
        ),
        act: (bloc) => bloc.add(
          const ConnectionDataCheckRequested(),
        ),
        expect: () => [
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ),
        ],
      );
    });

    group('on ConnectionRequested', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits nothing when connection data is not valid',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        act: (bloc) => bloc.add(
          const ConnectionRequested(),
        ),
        expect: () => const <ConnectionState>[],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits [ConnectionInProgress, ConnectionFailure] when connection is '
        'not successful',
        setUp: () {
          when(
            () => connectionRepository.connect(
              address: any(named: 'address'),
              port: any(named: 'port'),
            ),
          ).thenThrow(exception);
        },
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <ConnectionState>[
          ConnectionInProgress(address: address, port: port),
          ConnectionFailure(address: address, port: port),
        ],
        verify: (_) {
          verify(
            () => connectionRepository.connect(
              address: address.value,
              port: port.value,
            ),
          ).called(1);
        },
        errors: () => [exception],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits [ConnectionInProgress, ConnectionSuccess] when connection is '
        'successful',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <ConnectionState>[
          ConnectionInProgress(address: address, port: port),
          ConnectionSuccess(address: address, port: port),
        ],
        verify: (_) {
          verify(
            () => connectionRepository.connect(
              address: address.value,
              port: port.value,
            ),
          ).called(1);
          verify(() => connectionRepository.statuses).called(1);
          verify(
            () => settingsController.setIpAddress(ipAddress: address.value),
          ).called(1);
          verify(
            () => settingsController.setPort(port: port.value),
          ).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial when statuses stream is closed',
        setUp: () {
          statusesController.onListen = () {
            statusesController.close();
          };
        },
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <ConnectionState>[
          ConnectionInProgress(address: address, port: port),
          ConnectionSuccess(address: address, port: port),
          ConnectionInitial(address: address, port: port),
        ],
        verify: (_) {
          verify(
            () => connectionRepository.connect(
              address: address.value,
              port: port.value,
            ),
          ).called(1);
          verify(() => connectionRepository.statuses).called(1);
          verify(
            () => settingsController.setIpAddress(ipAddress: address.value),
          ).called(1);
          verify(
            () => settingsController.setPort(port: port.value),
          ).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInProgress when statuses stream emits '
        'ConnectionStatus.connecting',
        setUp: () {
          statusesController.onListen = () {
            statusesController.add(ConnectionStatus.connecting);
          };
        },
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <ConnectionState>[
          ConnectionInProgress(address: address, port: port),
          ConnectionSuccess(address: address, port: port),
          ConnectionInProgress(address: address, port: port),
        ],
        verify: (_) {
          verify(
            () => connectionRepository.connect(
              address: address.value,
              port: port.value,
            ),
          ).called(1);
          verify(() => connectionRepository.statuses).called(1);
          verify(
            () => settingsController.setIpAddress(ipAddress: address.value),
          ).called(1);
          verify(
            () => settingsController.setPort(port: port.value),
          ).called(1);
        },
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionSuccess when statuses stream emits '
        'ConnectionStatus.connected',
        setUp: () {
          statusesController.onListen = () {
            statusesController
              ..add(ConnectionStatus.connecting)
              ..add(ConnectionStatus.connected);
          };
        },
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInitial(address: address, port: port),
        act: (bloc) => bloc.add(const ConnectionRequested()),
        wait: const Duration(milliseconds: 500),
        expect: () => <ConnectionState>[
          ConnectionInProgress(address: address, port: port),
          ConnectionSuccess(address: address, port: port),
          ConnectionInProgress(address: address, port: port),
          ConnectionSuccess(address: address, port: port),
        ],
        verify: (_) {
          verify(
            () => connectionRepository.connect(
              address: address.value,
              port: port.value,
            ),
          ).called(1);
          verify(() => connectionRepository.statuses).called(1);
          verify(
            () => settingsController.setIpAddress(ipAddress: address.value),
          ).called(1);
          verify(
            () => settingsController.setPort(port: port.value),
          ).called(1);
        },
      );
    });

    group('on ConnectionStatusUpdated', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInProgress when status is ConnectionStatus.connecting',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionSuccess(address: address, port: port),
        act: (bloc) => bloc.add(
          const ConnectionStatusUpdated(status: ConnectionStatus.connecting),
        ),
        expect: () => [
          ConnectionInProgress(address: address, port: port),
        ],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionSuccess when status is ConnectionStatus.connecting',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionInProgress(address: address, port: port),
        act: (bloc) => bloc.add(
          const ConnectionStatusUpdated(status: ConnectionStatus.connected),
        ),
        expect: () => [
          ConnectionSuccess(address: address, port: port),
        ],
      );

      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial when status is ConnectionStatus.disconnected',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionSuccess(address: address, port: port),
        act: (bloc) => bloc.add(
          const ConnectionStatusUpdated(status: ConnectionStatus.disconnected),
        ),
        expect: () => [
          ConnectionInitial(address: address, port: port),
        ],
      );
    });

    group('on DisconnectionRequested', () {
      blocTest<ConnectionBloc, ConnectionState>(
        'emits ConnectionInitial and disconnects',
        build: () => ConnectionBloc(
          connectionRepository: connectionRepository,
          settingsController: settingsController,
        ),
        seed: () => ConnectionSuccess(address: address, port: port),
        act: (bloc) => bloc.add(const DisconnectionRequested()),
        expect: () => [
          ConnectionInitial(address: address, port: port),
        ],
        verify: (_) {
          verify(connectionRepository.disconnect).called(1);
        },
      );
    });
  });
}
