import 'dart:async';

import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:settings_controller/settings_controller.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc({
    required ConnectionRepository connectionRepository,
    required SettingsController settingsController,
    ConnectionData? initialConnectionData,
  })  : _connectionRepository = connectionRepository,
        _settingsController = settingsController,
        super(
          ConnectionInitial(
            address: initialConnectionData != null
                ? IpAddressInput.dirty(initialConnectionData.address)
                : IpAddressInput.pure(),
            port: initialConnectionData != null
                ? PortInput.dirty(initialConnectionData.port)
                : PortInput.pure(),
          ),
        ) {
    on<IpAddressUpdated>(_onIpAddressUpdated);
    on<PortUpdated>(_onPortUpdated);
    on<ConnectionDataCheckRequested>(_onConnectionDataCheckRequested);
    on<ConnectionRequested>(_onConnectionRequested);
    on<DisconnectionRequested>(_onDisconnectionRequested);
    on<ConnectionStatusUpdated>(_onConnectionStatusUpdated);
  }

  @override
  Future<void> close() async {
    await _unsubscribeFromStatuses();
    return super.close();
  }

  Future<void> _unsubscribeFromStatuses() async {
    await _statusesSubscription?.cancel();
    _statusesSubscription = null;
  }

  final ConnectionRepository _connectionRepository;

  final SettingsController _settingsController;

  StreamSubscription<ConnectionStatus>? _statusesSubscription;

  Future<void> _onIpAddressUpdated(
    IpAddressUpdated event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(
      ConnectionInitial(
        address: IpAddressInput.dirty(event.address ?? ''),
        port: state.port,
      ),
    );
  }

  Future<void> _onPortUpdated(
    PortUpdated event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(
      ConnectionInitial(
        address: state.address,
        port: PortInput.dirty(event.port ?? -1),
      ),
    );
  }

  Future<void> _onConnectionDataCheckRequested(
    ConnectionDataCheckRequested event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(
      state.copyWith(
        address: state.address.isValid ? state.address : IpAddressInput.pure(),
        port: state.port.isValid ? state.port : PortInput.pure(),
      ),
    );
  }

  Future<void> _onConnectionRequested(
    ConnectionRequested event,
    Emitter<ConnectionState> emit,
  ) async {
    final connectionData = state.connectionData;

    if (connectionData == null) {
      return;
    }

    emit(
      ConnectionInProgress(
        address: state.address,
        port: state.port,
      ),
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    try {
      await _connectionRepository.connect(
        address: connectionData.address,
        port: connectionData.port,
      );

      // Saving latest address and port for the future sessions.
      _settingsController
        ..setIpAddress(ipAddress: connectionData.address)
        ..setPort(port: connectionData.port);

      emit(
        ConnectionSuccess(
          address: state.address,
          port: state.port,
        ),
      );
    } catch (e, t) {
      addError(e, t);

      emit(
        ConnectionFailure(
          address: state.address,
          port: state.port,
        ),
      );

      return;
    }

    _statusesSubscription = _connectionRepository.statuses.listen(
      (status) => add(
        ConnectionStatusUpdated(status: status),
      ),
      onDone: () => add(
        const ConnectionStatusUpdated(
          status: ConnectionStatus.disconnected,
        ),
      ),
    );
  }

  Future<void> _onDisconnectionRequested(
    DisconnectionRequested event,
    Emitter<ConnectionState> emit,
  ) async {
    await _connectionRepository.disconnect();
    await _unsubscribeFromStatuses();

    emit(
      ConnectionInitial(
        address: state.address,
        port: state.port,
      ),
    );
  }

  Future<void> _onConnectionStatusUpdated(
    ConnectionStatusUpdated event,
    Emitter<ConnectionState> emit,
  ) async {
    switch (event.status) {
      case ConnectionStatus.connecting:
        emit(
          ConnectionInProgress(
            address: state.address,
            port: state.port,
          ),
        );

      case ConnectionStatus.connected:
        emit(
          ConnectionSuccess(
            address: state.address,
            port: state.port,
          ),
        );

      case ConnectionStatus.disconnected:
        await _unsubscribeFromStatuses();

        emit(
          ConnectionInitial(
            address: state.address,
            port: state.port,
          ),
        );
    }
  }
}
