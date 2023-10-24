import 'package:equatable/equatable.dart';

final class ConnectionData extends Equatable {
  const ConnectionData({
    required this.address,
    required this.port,
  });

  final String address;

  final int port;

  @override
  List<Object?> get props => [address, port];
}
