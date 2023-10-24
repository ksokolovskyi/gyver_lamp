import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectionBloc extends MockBloc<ConnectionEvent, ConnectionState>
    implements ConnectionBloc {}

void main() {
  group('InitialSetupBottomBar', () {
    final address = IpAddressInput.dirty('192.168.1.5');
    final port = PortInput.dirty(8888);

    late ConnectionBloc bloc;

    setUp(() {
      bloc = _MockConnectionBloc();
      when(() => bloc.state).thenReturn(
        ConnectionInitial(
          address: address,
          port: port,
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider<ConnectionBloc>.value(
        value: bloc,
        child: const InitialSetupBottomBar(),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(InitialSetupBottomBar), findsOneWidget);
      expect(find.byType(ConnectButton), findsOneWidget);
    });
  });
}

extension _InitialSetupBottomBar on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          bottomNavigationBar: subject,
        ),
      ),
    );
  }
}
