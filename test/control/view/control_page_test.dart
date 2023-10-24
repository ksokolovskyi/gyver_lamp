import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

class _MockControlRepository extends Mock implements ControlRepository {}

void main() {
  group('ControlPage', () {
    const connectionData = ConnectionData(
      address: '192.168.1.5',
      port: 3333,
    );

    late ConnectionBloc connectionBloc;
    late ControlRepository controlRepository;
    late StreamController<GyverLampMessage> messagesController;

    setUp(() {
      connectionBloc = _MockConnectionBloc();
      when(() => connectionBloc.state).thenReturn(
        ConnectionInitial(
          address: IpAddressInput.dirty(connectionData.address),
          port: PortInput.dirty(connectionData.port),
        ),
      );

      messagesController = StreamController();

      controlRepository = _MockControlRepository();
      when(() => controlRepository.messages).thenAnswer(
        (_) => messagesController.stream,
      );
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: connectionBloc,
        child: Provider<ControlRepository>.value(
          value: controlRepository,
          child: const ControlPage(),
        ),
      );
    }

    group('route', () {
      test('returns correct GyverLampPageRoute', () {
        expect(
          ControlPage.route(),
          isRoute(whereName: equals('control')),
        );
      });

      testWidgets('can be pushed', (tester) async {
        await tester.pumpWidget(
          BlocProvider<ConnectionBloc>.value(
            value: connectionBloc,
            child: Provider<ControlRepository>.value(
              value: controlRepository,
              child: MaterialApp(
                theme: GyverLampTheme.lightThemeData,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: Center(
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        child: const Text('PUSH'),
                        onPressed: () {
                          Navigator.of(context).push(
                            ControlPage.route(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('PUSH'));
        await tester.pumpAndSettle();

        expect(find.byType(ControlPage), findsOneWidget);
      });
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(ControlPage), findsOneWidget);
      expect(find.byType(ControlView), findsOneWidget);
    });

    testWidgets('listens to the ConnectionBloc', (tester) async {
      when(
        () => controlRepository.requestCurrentState(
          address: any(named: 'address'),
          port: any(named: 'port'),
        ),
      ).thenAnswer((_) async => {});

      final statesController = StreamController<ConnectionState>();
      addTearDown(statesController.close);

      whenListen(
        connectionBloc,
        statesController.stream,
        initialState: ConnectionInitial(
          address: IpAddressInput.dirty(connectionData.address),
          port: PortInput.dirty(connectionData.port),
        ),
      );

      await tester.pumpSubject(buildSubject());

      statesController.add(
        ConnectionSuccess(
          address: IpAddressInput.dirty(connectionData.address),
          port: PortInput.dirty(connectionData.port),
        ),
      );

      await tester.pump();

      verify(
        () => controlRepository.requestCurrentState(
          address: connectionData.address,
          port: connectionData.port,
        ),
      ).called(1);

      final context = tester.firstElement(find.byType(ControlView));
      final controlBloc = context.read<ControlBloc>();

      expect(
        controlBloc.state,
        equals(
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 128,
            speed: 30,
            scale: 10,
            isOn: false,
          ),
        ),
      );
    });
  });
}

extension _ControlPage on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: subject,
      ),
    );
  }
}
