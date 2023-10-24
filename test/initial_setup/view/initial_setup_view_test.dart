import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('InitialSetupView', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;
    late MockNavigator navigator;
    late MockAlertMessenger messenger;
    late SettingsController settingsController;

    setUp(() {
      bloc = _MockConnectionBloc();
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );

      navigator = MockNavigator();
      messenger = MockAlertMessenger();
      settingsController = _MockSettingsController();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: Provider<SettingsController>.value(
          value: settingsController,
          child: MockAlertMessengerProvider(
            messenger: messenger,
            child: MockNavigatorProvider(
              navigator: navigator,
              child: const InitialSetupView(),
            ),
          ),
        ),
      );
    }

    group('renders correctly', () {
      testWidgets('when state is $ConnectionInitial', (tester) async {
        await tester.pumpSubject(buildSubject());

        expect(find.byType(InitialSetupView), findsOneWidget);
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(InitialSetupForm), findsOneWidget);
        expect(find.byType(InitialSetupBottomBar), findsOneWidget);
        expect(find.text(tester.l10n.skip), findsOneWidget);

        final button = tester.widget<FlatTextButton>(
          find.ancestor(
            of: find.text(tester.l10n.skip),
            matching: find.byType(FlatTextButton),
          ),
        );

        expect(button.onPressed, isNotNull);
      });

      testWidgets('when state is $ConnectionInProgress', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        expect(find.byType(InitialSetupView), findsOneWidget);
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(InitialSetupForm), findsOneWidget);
        expect(find.byType(InitialSetupBottomBar), findsOneWidget);
        expect(find.text(tester.l10n.skip), findsOneWidget);

        final button = tester.widget<FlatTextButton>(
          find.ancestor(
            of: find.text(tester.l10n.skip),
            matching: find.byType(FlatTextButton),
          ),
        );

        expect(button.onPressed, isNull);
      });
    });

    testWidgets(
      'clears alerts, sets setting, adds event to bloc and navigates to the '
      'ControlPage when skip is pressed',
      (tester) async {
        when(messenger.clear).thenAnswer((_) async {});
        when(
          () => settingsController.setInitialSetupCompleted(
            completed: any(named: 'completed'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => navigator.pushReplacement<void, void>(any()),
        ).thenAnswer((_) async {});

        await tester.pumpSubject(buildSubject());

        await tester.tap(find.text(tester.l10n.skip));

        verify(messenger.clear).called(1);
        verify(
          () => settingsController.setInitialSetupCompleted(completed: true),
        ).called(1);
        verify(
          () => bloc.add(const ConnectionDataCheckRequested()),
        ).called(1);
        verify(
          () => navigator.pushReplacement<void, void>(
            any(that: isRoute(whereName: equals('control'))),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'clears alerts, sets setting, adds event to bloc and navigates to the '
      'ControlPage when ConnectionSuccess is emitted',
      (tester) async {
        final controller = StreamController<ConnectionState>();
        addTearDown(controller.close);

        whenListen(
          bloc,
          controller.stream,
          initialState: ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        when(messenger.clear).thenAnswer((_) async {});
        when(
          () => settingsController.setInitialSetupCompleted(
            completed: any(named: 'completed'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => navigator.pushReplacement<void, void>(any()),
        ).thenAnswer((_) async {});

        await tester.pumpSubject(buildSubject());

        controller.add(ConnectionSuccess(address: address, port: port));
        await tester.pump();

        verify(messenger.clear).called(1);
        verify(
          () => settingsController.setInitialSetupCompleted(completed: true),
        ).called(1);
        verify(
          () => bloc.add(const ConnectionDataCheckRequested()),
        ).called(1);
        verify(
          () => navigator.pushReplacement<void, void>(
            any(that: isRoute(whereName: equals('control'))),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'shows error when $ConnectionFailure is emitted',
      (tester) async {
        final controller = StreamController<ConnectionState>();
        addTearDown(controller.close);

        whenListen(
          bloc,
          controller.stream,
          initialState: ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        when(
          () => messenger.showError(message: any(named: 'message')),
        ).thenAnswer((_) async {});

        await tester.pumpSubject(buildSubject());

        controller.add(ConnectionFailure(address: address, port: port));
        await tester.pump();

        verify(
          () => messenger.showError(message: tester.l10n.connectionFailed),
        ).called(1);
      },
    );
  });
}

extension _InitialSetupView on WidgetTester {
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
