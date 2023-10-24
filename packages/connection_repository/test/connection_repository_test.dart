import 'dart:async';

import 'package:connection_repository/connection_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockGyverLampClient extends Mock implements GyverLampClient {}

void main() {
  group('ConnectionRepository', () {
    const address = '192.168.1.1';
    const port = 8888;

    const period = Duration(seconds: 1);

    const expectedResponse = GyverLampOkResponse(timestamp: '11.22.63');

    late GyverLampClient client;
    late ConnectionRepository subject;

    setUp(() {
      client = _MockGyverLampClient();

      when(
        () => client.ping(
          address: any(named: 'address'),
          port: any(
            named: 'port',
          ),
        ),
      ).thenAnswer(
        (_) async => expectedResponse,
      );

      subject = ConnectionRepository(
        client: client,
        period: period,
      );
    });

    tearDown(() async {
      if (subject.isDisposed) {
        return;
      }

      await subject.dispose();
    });

    test('can be instantiated', () {
      expect(
        ConnectionRepository(client: client),
        isNotNull,
      );
    });

    group('connect', () {
      test(
        'calls ping',
        () async {
          await subject.connect(
            address: address,
            port: port,
          );

          verify(
            () => client.ping(
              address: address,
              port: port,
            ),
          ).called(1);
        },
      );

      test(
          'emits ConnectionStatus.connecting and ConnectionStatus.connected '
          'when ping returns response', () {
        fakeAsync((async) {
          final emittedStatuses = <ConnectionStatus>[];

          final subscription = subject.statuses.listen(
            emittedStatuses.add,
          );

          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {});

          async.elapse(Duration.zero);

          expect(
            emittedStatuses,
            equals(
              [
                ConnectionStatus.connecting,
                ConnectionStatus.connected,
              ],
            ),
          );

          subscription.cancel();

          async.elapse(Duration.zero);
        });
      });

      test(
          'emits ConnectionStatus.connecting, ConnectionStatus.disconnected '
          'and throws ConnectionException when ping throws', () {
        when(
          () => client.ping(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenThrow(
          ArgumentError('TEST'),
        );

        fakeAsync((async) {
          Object? exception;

          final emittedStatuses = <ConnectionStatus>[];

          final subscription = subject.statuses.listen(
            emittedStatuses.add,
          );

          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {})
              .onError(
            (e, t) {
              exception = e;
            },
          );

          async.elapse(period);

          expect(exception, isNotNull);
          expect(
            exception,
            isA<ConnectionException>().having(
              (e) => e.error,
              'error',
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'TEST',
              ),
            ),
          );

          expect(
            emittedStatuses,
            equals(
              [
                ConnectionStatus.connecting,
                ConnectionStatus.disconnected,
              ],
            ),
          );

          subscription.cancel();

          async.elapse(Duration.zero);
        });
      });

      test('constantly pings lamp with the period delays', () {
        const count = 3;

        fakeAsync((async) {
          final emittedStatuses = <ConnectionStatus>[];

          final subscription = subject.statuses.listen(
            emittedStatuses.add,
          );

          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {});

          async.elapse(period * count);

          expect(
            emittedStatuses,
            equals(
              [
                ConnectionStatus.connecting,
                ConnectionStatus.connected,
              ],
            ),
          );

          subscription.cancel();

          async.elapse(Duration.zero);
        });

        verify(
          () => client.ping(
            address: address,
            port: port,
          ),
        ).called(count + 1);
      });

      test('stops constantly pings after an exception in ping and disconnects',
          () {
        var shouldThrow = false;

        when(
          () => client.ping(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenAnswer((_) async {
          if (!shouldThrow) {
            shouldThrow = true;
            return expectedResponse;
          }

          throw ArgumentError('TEST');
        });

        fakeAsync((async) {
          final emittedStatuses = <ConnectionStatus>[];

          final subscription = subject.statuses.listen(
            emittedStatuses.add,
          );

          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {});

          async.elapse(period);

          expect(
            emittedStatuses,
            equals(
              [
                ConnectionStatus.connecting,
                ConnectionStatus.connected,
                ConnectionStatus.disconnected,
              ],
            ),
          );

          subscription.cancel();

          async.elapse(Duration.zero);
        });

        verify(
          () => client.ping(
            address: address,
            port: port,
          ),
        ).called(2);
      });
    });

    group('disconnect', () {
      test('stops constant pings and emits ConnectionStatus.disconnected', () {
        fakeAsync((async) {
          final emittedStatuses = <ConnectionStatus>[];

          final subscription = subject.statuses.listen(
            emittedStatuses.add,
          );

          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {});

          async.elapse(period);

          subject.disconnect().then((_) {});

          async.elapse(period * 2);

          expect(
            emittedStatuses,
            equals(
              [
                ConnectionStatus.connecting,
                ConnectionStatus.connected,
                ConnectionStatus.disconnected,
              ],
            ),
          );

          subscription.cancel();

          async.elapse(Duration.zero);
        });

        verify(
          () => client.ping(
            address: address,
            port: port,
          ),
        ).called(2);
      });
    });

    group('dispose', () {
      test(
        'disposes internal resources',
        () async {
          await subject.dispose();
          expect(subject.isDisposed, isTrue);
        },
      );

      test('stops constant pings', () {
        fakeAsync((async) {
          subject
              .connect(
                address: address,
                port: port,
              )
              .then((_) {});

          async.elapse(period);

          subject.dispose().then((_) {});

          async.elapse(period * 3);
        });

        verify(
          () => client.ping(
            address: address,
            port: port,
          ),
        ).called(2);
      });
    });
  });
}
