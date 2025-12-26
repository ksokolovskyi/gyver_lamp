import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

class _MockControlBloc extends MockBloc<ControlEvent, ControlState>
    implements ControlBloc {}

void main() {
  group('ControlAppBar', () {
    late ControlBloc controlBloc;
    late ConnectionBloc connectionBloc;

    setUp(() {
      controlBloc = _MockControlBloc();
      when(() => controlBloc.state).thenReturn(
        const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      connectionBloc = _MockConnectionBloc();
      when(() => connectionBloc.state).thenReturn(
        ConnectionInitial(
          address: IpAddressInput.pure(),
          port: PortInput.pure(),
        ),
      );
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ControlBloc>.value(value: controlBloc),
          BlocProvider<ConnectionBloc>.value(value: connectionBloc),
        ],
        child: const ControlAppBar(),
      );
    }

    test('preferredSize is correct', () {
      expect(
        const ControlAppBar().preferredSize,
        equals(kCustomAppBarSize),
      );
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(ControlAppBar), findsOneWidget);
      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.settings), findsOneWidget);
      expect(find.byType(Switcher), findsOneWidget);
    });

    testWidgets('opens settings page on settings button tap', (tester) async {
      final navigator = MockNavigator();
      when(
        () => navigator.push<void>(any()),
      ).thenAnswer((_) async {});
      when(navigator.canPop).thenReturn(true);

      await tester.pumpSubject(
        MockNavigatorProvider(
          navigator: navigator,
          child: buildSubject(),
        ),
      );

      await tester.tap(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.settings),
          matching: find.byType(FlatIconButton),
        ),
      );

      verify(
        () => navigator.push<void>(
          any(that: isRoute(whereName: equals('settings'))),
        ),
      ).called(1);
    });

    testWidgets('updates switcher when isOn changes', (tester) async {
      final statesController = StreamController<ControlState>();
      addTearDown(statesController.close);

      whenListen(
        controlBloc,
        statesController.stream,
        initialState: const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      var switcher = tester.widget<Switcher>(find.byType(Switcher));

      expect(switcher.value, isFalse);

      statesController.add(
        const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: true,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );
      await tester.pump();

      switcher = tester.widget<Switcher>(find.byType(Switcher));

      expect(switcher.value, isTrue);
    });

    testWidgets('adds event to bloc when switcher is toggled', (tester) async {
      await tester.pumpSubject(buildSubject());

      final switcher = tester.widget<Switcher>(find.byType(Switcher));

      expect(switcher.value, isFalse);

      await tester.tap(find.byType(Switcher));

      verify(
        () => controlBloc.add(const PowerToggled(isOn: true)),
      ).called(1);
    });
  });
}

extension _ControlAppBar on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Center(
            child: subject,
          ),
        ),
      ),
    );
  }
}
