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
  group('DisconnectDialog', () {
    late ConnectionBloc bloc;
    late MockNavigator navigator;

    setUp(() {
      bloc = _MockConnectionBloc();
      navigator = MockNavigator();
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: MockNavigatorProvider(
          navigator: navigator,
          child: const DisconnectDialog(),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.text(tester.l10n.disconnectDialogTitle), findsOneWidget);
      expect(find.text(tester.l10n.disconnectDialogBody), findsOneWidget);
      expect(find.text(tester.l10n.cancel), findsOneWidget);
      expect(find.text(tester.l10n.disconnect), findsOneWidget);
    });

    testWidgets('pops on cancel tap', (tester) async {
      when(navigator.maybePop).thenAnswer((_) async => true);

      await tester.pumpSubject(buildSubject());

      await tester.tap(find.text(tester.l10n.cancel));

      verify(navigator.maybePop).called(1);
    });

    testWidgets(
      'pops and adds event to bloc on disconnect tap',
      (tester) async {
        when(navigator.maybePop).thenAnswer((_) async => true);

        await tester.pumpSubject(buildSubject());

        await tester.tap(find.text(tester.l10n.disconnect));

        verify(navigator.maybePop).called(1);
        verify(
          () => bloc.add(const DisconnectionRequested()),
        ).called(1);
      },
    );
  });
}

extension _DisconnectDialog on WidgetTester {
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
