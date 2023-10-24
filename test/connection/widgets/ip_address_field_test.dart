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
  group('IpAddressField', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;

    setUp(() {
      bloc = _MockConnectionBloc();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: const IpAddressField(),
      );
    }

    group('renders correctly', () {
      testWidgets('when address is not valid', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: IpAddressInput.dirty('123'),
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        expect(find.byType(LabeledInputField), findsOneWidget);
        expect(find.text('123'), findsOneWidget);
        expect(find.text(tester.l10n.ipErrorHint), findsOneWidget);
      });

      testWidgets('when address is valid', (tester) async {
        when(() => bloc.state).thenReturn(
          ConnectionInitial(
            address: address,
            port: port,
          ),
        );

        await tester.pumpSubject(buildSubject());

        expect(find.byType(LabeledInputField), findsOneWidget);
        expect(find.text(address.value), findsOneWidget);
        expect(find.text(tester.l10n.ipErrorHint), findsNothing);
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
        find.byType(IpAddressField),
        address.value,
      );

      verify(
        () => bloc.add(IpAddressUpdated(address: address.value)),
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

extension _IpAddressField on WidgetTester {
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
