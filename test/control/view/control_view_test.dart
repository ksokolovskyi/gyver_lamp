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

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

class _MockControlBloc extends MockBloc<ControlEvent, ControlState>
    implements ControlBloc {}

void main() {
  group('ControlView', () {
    const connectionData = ConnectionData(
      address: '192.168.1.5',
      port: 3333,
    );

    late ConnectionBloc connectionBloc;
    late ControlBloc controlBloc;
    late MockNavigator navigator;
    late MockAlertMessenger messenger;

    setUp(() {
      connectionBloc = _MockConnectionBloc();
      when(() => connectionBloc.state).thenReturn(
        ConnectionInitial(
          address: IpAddressInput.dirty(connectionData.address),
          port: PortInput.dirty(connectionData.port),
        ),
      );

      controlBloc = _MockControlBloc();
      when(() => controlBloc.state).thenReturn(
        ControlState(
          isConnected: true,
          connectionData: connectionData,
          mode: GyverLampMode.values.first,
          brightness: 11,
          speed: 22,
          scale: 33,
          isOn: false,
        ),
      );

      navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);

      messenger = MockAlertMessenger();
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ConnectionBloc>.value(value: connectionBloc),
          BlocProvider<ControlBloc>.value(value: controlBloc),
        ],
        child: MockAlertMessengerProvider(
          messenger: messenger,
          child: MockNavigatorProvider(
            navigator: navigator,
            child: const ControlView(),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(ControlView), findsOneWidget);
      expect(find.byType(ControlAppBar), findsOneWidget);
      expect(find.byType(Effect), findsOneWidget);
      expect(find.byType(ModePicker), findsOneWidget);
      expect(find.byType(ControlRulers), findsOneWidget);
    });

    testWidgets(
      'does not show message that lamp is toggled when not isConnected',
      (tester) async {
        final controller = StreamController<ControlState>();
        addTearDown(controller.close);

        whenListen(
          controlBloc,
          controller.stream,
          initialState: ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: false,
          ),
        );

        await tester.pumpSubject(buildSubject());

        controller.add(
          ControlState(
            isConnected: false,
            connectionData: null,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: true,
          ),
        );

        verifyNever(() => messenger.showInfo(message: any(named: 'message')));
      },
    );

    testWidgets(
      'shows message that lamp is toggled on when isConnected',
      (tester) async {
        when(
          () => messenger.showInfo(message: any(named: 'message')),
        ).thenAnswer((_) async => {});

        final controller = StreamController<ControlState>();
        addTearDown(controller.close);

        whenListen(
          controlBloc,
          controller.stream,
          initialState: ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: false,
          ),
        );

        await tester.pumpSubject(buildSubject());

        controller.add(
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: true,
          ),
        );

        await tester.pump();

        verify(
          () => messenger.showInfo(message: tester.l10n.lampIsOn),
        ).called(1);
      },
    );

    testWidgets(
      'shows message that lamp is toggled off when isConnected',
      (tester) async {
        when(
          () => messenger.showInfo(message: any(named: 'message')),
        ).thenAnswer((_) async => {});

        final controller = StreamController<ControlState>();
        addTearDown(controller.close);

        whenListen(
          controlBloc,
          controller.stream,
          initialState: ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: true,
          ),
        );

        await tester.pumpSubject(buildSubject());

        controller.add(
          ControlState(
            isConnected: true,
            connectionData: connectionData,
            mode: GyverLampMode.values.first,
            brightness: 11,
            speed: 22,
            scale: 33,
            isOn: false,
          ),
        );

        await tester.pump();

        verify(
          () => messenger.showInfo(message: tester.l10n.lampIsOff),
        ).called(1);
      },
    );
  });
}

extension _ControlView on WidgetTester {
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
