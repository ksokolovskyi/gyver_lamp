part of 'connection_bloc.dart';

sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class IpAddressUpdated extends ConnectionEvent {
  const IpAddressUpdated({
    required this.address,
  });

  final String? address;

  @override
  List<Object?> get props => [address];
}

class PortUpdated extends ConnectionEvent {
  const PortUpdated({
    required this.port,
  });

  final int? port;

  @override
  List<Object?> get props => [port];
}

class ConnectionDataCheckRequested extends ConnectionEvent {
  const ConnectionDataCheckRequested();
}

class ConnectionRequested extends ConnectionEvent {
  const ConnectionRequested();
}

class DisconnectionRequested extends ConnectionEvent {
  const DisconnectionRequested();
}

class ConnectionStatusUpdated extends ConnectionEvent {
  const ConnectionStatusUpdated({
    required this.status,
  });

  final ConnectionStatus status;

  @override
  List<Object?> get props => [status];
}
