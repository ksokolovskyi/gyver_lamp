part of 'connection_bloc.dart';

extension ConnectionStateX on ConnectionState {
  bool get isConnected => this is ConnectionSuccess;

  bool get isConnecting => this is ConnectionInProgress;
}

sealed class ConnectionState extends Equatable {
  const ConnectionState({
    required this.address,
    required this.port,
  });

  final IpAddressInput address;

  final PortInput port;

  bool get isLampDataValid => Formz.validate([address, port]);

  ConnectionData? get connectionData => isLampDataValid
      ? ConnectionData(address: address.value, port: port.value)
      : null;

  ConnectionState copyWith({
    IpAddressInput? address,
    PortInput? port,
  });

  @override
  List<Object> get props => [address, port];
}

class ConnectionInitial extends ConnectionState {
  const ConnectionInitial({
    required super.address,
    required super.port,
  });

  @override
  ConnectionInitial copyWith({
    IpAddressInput? address,
    PortInput? port,
  }) {
    return ConnectionInitial(
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}

class ConnectionInProgress extends ConnectionState {
  const ConnectionInProgress({
    required super.address,
    required super.port,
  });

  @override
  ConnectionInProgress copyWith({
    IpAddressInput? address,
    PortInput? port,
  }) {
    return ConnectionInProgress(
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}

class ConnectionSuccess extends ConnectionState {
  const ConnectionSuccess({
    required super.address,
    required super.port,
  });

  @override
  ConnectionSuccess copyWith({
    IpAddressInput? address,
    PortInput? port,
  }) {
    return ConnectionSuccess(
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}

class ConnectionFailure extends ConnectionState {
  const ConnectionFailure({
    required super.address,
    required super.port,
  });

  @override
  ConnectionFailure copyWith({
    IpAddressInput? address,
    PortInput? port,
  }) {
    return ConnectionFailure(
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}
