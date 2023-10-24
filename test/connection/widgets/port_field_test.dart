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
  group('PortField', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;

    setUp(() {
      bloc = _MockConnectionBloc();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: const PortField(),
      );
    }

    group('renders correctly', () {
      testWidgets('when port is not valid', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: address,
            port: PortInput.dirty(65536),
          ),
        );

        await tester.pumpSubject(buildSubject());

        expect(find.byType(LabeledInputField), findsOneWidget);
        expect(find.text('65536'), findsOneWidget);
        expect(find.text(tester.l10n.portErrorHint), findsOneWidget);
      });

      testWidgets('when port is valid', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        expect(find.byType(LabeledInputField), findsOneWidget);
        expect(find.text(port.value.toString()), findsOneWidget);
        expect(find.text(tester.l10n.portErrorHint), findsNothing);
      });

      testWidgets('when state is $ConnectionInProgress', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInProgress(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final field = tester.widget<LabeledInputField>(
          find.byType(LabeledInputField),
        );

        expect(field.enabled, isFalse);
      });
    });

    testWidgets('on change adds event to bloc', (tester) async {
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: IpAddressInput.pure(),
          port: PortInput.pure(),
        ),
      );

      await tester.pumpSubject(buildSubject());

      await tester.enterText(
        find.byType(PortField),
        port.value.toString(),
      );

      verify(
        () => bloc.add(PortUpdated(port: port.value)),
      ).called(1);
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

      var field = tester.widget<LabeledInputField>(
        find.byType(LabeledInputField),
      );

      expect(field.enabled, isTrue);

      controller.add(
        ConnectionInProgress(
          address: address,
          port: port,
        ),
      );
      await tester.pump();

      field = tester.widget<LabeledInputField>(
        find.byType(LabeledInputField),
      );

      expect(field.enabled, isFalse);
    });
  });
}

extension _PortField on WidgetTester {
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
