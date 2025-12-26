import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

void main() {
  group('ConnectDialog', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;
    late MockNavigator navigator;
    late MockAlertMessenger messenger;

    setUp(() {
      bloc = _MockConnectionBloc();

      navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);

      messenger = MockAlertMessenger();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: MockAlertMessengerProvider(
          messenger: messenger,
          child: MockNavigatorProvider(
            navigator: navigator,
            child: const ConnectDialog(),
          ),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );

      await tester.pumpSubject(buildSubject());

      expect(find.text(tester.l10n.connectDialogTitle), findsOneWidget);
      expect(find.byType(IpAddressField), findsOneWidget);
      expect(find.byType(PortField), findsOneWidget);
      expect(find.byType(ConnectButton), findsOneWidget);
    });

    testWidgets('on cancel tap works correctly', (tester) async {
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );

      when(navigator.maybePop).thenAnswer((_) async => true);
      when(messenger.clear).thenAnswer((_) async {});

      await tester.pumpSubject(buildSubject());

      await tester.tap(find.text(tester.l10n.cancel));

      verify(navigator.maybePop).called(1);
      verify(messenger.clear).called(1);
      verify(
        () => bloc.add(const ConnectionDataCheckRequested()),
      ).called(1);
    });

    testWidgets('closes when connection is established', (tester) async {
      final controller = StreamController<ConnectionState>();
      addTearDown(controller.close);

      whenListen(
        bloc,
        controller.stream,
        initialState: ConnectionInitial(
          address: address,
          port: port,
        ),
      );

      when(navigator.maybePop).thenAnswer((_) async => true);
      when(messenger.clear).thenAnswer((_) async {});

      await tester.pumpSubject(buildSubject());

      controller.add(
        ConnectionSuccess(
          address: address,
          port: port,
        ),
      );
      await tester.pump();

      verify(navigator.maybePop).called(1);
      verify(messenger.clear).called(1);
      verify(
        () => bloc.add(const ConnectionDataCheckRequested()),
      ).called(1);
    });

    testWidgets(
      'shows error when connection is not established',
      (tester) async {
        final controller = StreamController<ConnectionState>();
        addTearDown(controller.close);

        whenListen(
          bloc,
          controller.stream,
          initialState: ConnectionInitial(
            address: address,
            port: port,
          ),
        );

        when(navigator.maybePop).thenAnswer((_) async => true);

        when(messenger.clear).thenAnswer((_) async {});
        when(
          () => messenger.showError(message: any(named: 'message')),
        ).thenAnswer((_) async {});

        await tester.pumpSubject(buildSubject());

        controller.add(
          ConnectionFailure(
            address: address,
            port: port,
          ),
        );
        await tester.pump();

        verify(
          () => messenger.showError(message: tester.l10n.connectionFailed),
        ).called(1);

        verifyNever(messenger.clear);
        verifyNever(navigator.maybePop);
        verifyNever(
          () => bloc.add(const ConnectionDataCheckRequested()),
        );
      },
    );
  });
}

extension _ConnectDialog on WidgetTester {
  Future<void> pumpSubject(
    Widget subject,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Center(child: subject),
        ),
      ),
    );
  }
}
