import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

void main() {
  group('ConnectionStatusIndicator', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;

    setUp(() {
      bloc = _MockConnectionBloc();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: const ConnectionStatusIndicator(),
      );
    }

    group('renders correctly', () {
      testWidgets('when state is $ConnectionInitial', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final badge = tester.widget<ConnectionStatusBadge>(
          find.byType(ConnectionStatusBadge),
        );

        expect(badge.onPressed, isNotNull);
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
        expect(find.text(tester.l10n.notConnected), findsOneWidget);
      });

      testWidgets('when state is $ConnectionFailure', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionFailure(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final badge = tester.widget<ConnectionStatusBadge>(
          find.byType(ConnectionStatusBadge),
        );

        expect(badge.onPressed, isNotNull);
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
        expect(find.text(tester.l10n.notConnected), findsOneWidget);
      });

      testWidgets('when state is $ConnectionInProgress', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final badge = tester.widget<ConnectionStatusBadge>(
          find.byType(ConnectionStatusBadge),
        );

        expect(badge.onPressed, isNull);
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
        expect(find.text(tester.l10n.connecting), findsOneWidget);
      });

      testWidgets('when state is $ConnectionSuccess', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionSuccess(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final badge = tester.widget<ConnectionStatusBadge>(
          find.byType(ConnectionStatusBadge),
        );

        expect(badge.onPressed, isNotNull);
        expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
        expect(find.text(tester.l10n.connected), findsOneWidget);
      });
    });

    testWidgets(
      'on tap shows $ConnectDialog when state is $ConnectionInitial',
      (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        await tester.tap(find.byType(ConnectionStatusIndicator));
        await tester.pumpAndSettle();

        expect(find.byType(ConnectDialog), findsOneWidget);
      },
    );

    testWidgets(
      'on tap shows $DisconnectDialog when state is $ConnectionSuccess',
      (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionSuccess(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        await tester.tap(find.byType(ConnectionStatusIndicator));
        await tester.pumpAndSettle();

        expect(find.byType(DisconnectDialog), findsOneWidget);
      },
    );

    testWidgets('rebuilds when connection state changes', (tester) async {
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

      await tester.pumpSubject(buildSubject());

      expect(find.text(tester.l10n.notConnected), findsOneWidget);

      controller.add(
        ConnectionInProgress(
          address: address,
          port: port,
        ),
      );
      await tester.pump();

      expect(find.text(tester.l10n.connecting), findsOneWidget);
    });
  });
}

extension _ConnectionStatusIndicator on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
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
