import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

void main() {
  group('ConnectButton', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;

    setUp(() {
      bloc = _MockConnectionBloc();
    });

    Widget buildSubject({
      Widget? subject,
    }) {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: subject ?? const ConnectButton.large(),
      );
    }

    group('renders correctly', () {
      testWidgets('when size is medium', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ),
        );

        await tester.pumpSubject(
          buildSubject(
            subject: const ConnectButton.medium(),
          ),
        );

        final button = tester.widget<RoundedElevatedButton>(
          find.byType(RoundedElevatedButton),
        );

        expect(button.size, equals(RoundedElevatedButtonSize.medium));
      });

      testWidgets('when size is large', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ),
        );

        await tester.pumpSubject(
          buildSubject(
            subject: const ConnectButton.large(),
          ),
        );

        final button = tester.widget<RoundedElevatedButton>(
          find.byType(RoundedElevatedButton),
        );

        expect(button.size, equals(RoundedElevatedButtonSize.large));
      });

      testWidgets(
        'when state is $ConnectionInitial and lamp data is not valid',
        (tester) async {
          when(() => bloc.state).thenReturn(
            ConnectionInitial(
              address: IpAddressInput.pure(),
              port: PortInput.pure(),
            ),
          );

          expect(bloc.state.isLampDataValid, isFalse);

          await tester.pumpSubject(buildSubject());

          final button = tester.widget<RoundedElevatedButton>(
            find.byType(RoundedElevatedButton),
          );

          expect(button.onPressed, isNull);
          expect(find.text(tester.l10n.connect), findsOneWidget);
        },
      );

      testWidgets(
        'when state is $ConnectionInitial and lamp data is valid',
        (tester) async {
          when(() => bloc.state).thenReturn(
            ConnectionInitial(
              address: address,
              port: port,
            ),
          );

          expect(bloc.state.isLampDataValid, isTrue);

          await tester.pumpSubject(buildSubject());

          final button = tester.widget<RoundedElevatedButton>(
            find.byType(RoundedElevatedButton),
          );

          expect(button.onPressed, isNotNull);
          expect(find.text(tester.l10n.connect), findsOneWidget);
        },
      );

      testWidgets('when state is $ConnectionInProgress', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final button = tester.widget<RoundedElevatedButton>(
          find.byType(RoundedElevatedButton),
        );

        expect(button.onPressed, isNull);
        expect(find.byType(CirclesWaveLoadingIndicator), findsOneWidget);
      });

      testWidgets('when state is $ConnectionFailure', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionFailure(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ),
        );

        await tester.pumpSubject(buildSubject());

        final button = tester.widget<RoundedElevatedButton>(
          find.byType(RoundedElevatedButton),
        );

        expect(button.onPressed, isNull);
        expect(find.text(tester.l10n.connect), findsOneWidget);
      });

      testWidgets('when state is $ConnectionSuccess', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionSuccess(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ),
        );

        await tester.pumpSubject(buildSubject());

        final button = tester.widget<RoundedElevatedButton>(
          find.byType(RoundedElevatedButton),
        );

        expect(button.onPressed, isNull);
        expect(find.text(tester.l10n.connect), findsOneWidget);
      });
    });

    testWidgets('on tap adds event to bloc', (tester) async {
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );

      await tester.pumpSubject(buildSubject());

      await tester.tap(find.byType(ConnectButton));

      verify(() => bloc.add(const ConnectionRequested())).called(1);
    });

    testWidgets('rebuilds when lamp data changes', (tester) async {
      final controller = StreamController<ConnectionState>();
      addTearDown(controller.close);

      whenListen(
        bloc,
        controller.stream,
        initialState: ConnectionInitial(
          address: IpAddressInput.pure(),
          port: PortInput.pure(),
        ),
      );

      await tester.pumpSubject(buildSubject());

      var button = tester.widget<RoundedElevatedButton>(
        find.byType(RoundedElevatedButton),
      );

      expect(button.onPressed, isNull);

      controller.add(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );
      await tester.pump();

      button = tester.widget<RoundedElevatedButton>(
        find.byType(RoundedElevatedButton),
      );

      expect(button.onPressed, isNotNull);
    });

    testWidgets('rebuilds when connection is in progress', (tester) async {
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

      var button = tester.widget<RoundedElevatedButton>(
        find.byType(RoundedElevatedButton),
      );

      expect(button.onPressed, isNotNull);

      controller.add(
        ConnectionInProgress(
          address: address,
          port: port,
        ),
      );
      await tester.pump();

      button = tester.widget<RoundedElevatedButton>(
        find.byType(RoundedElevatedButton),
      );

      expect(button.onPressed, isNull);
    });
  });
}

extension _ConnectButton on WidgetTester {
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
