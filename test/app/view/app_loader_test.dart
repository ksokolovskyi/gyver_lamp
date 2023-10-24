import 'dart:async';

import 'package:connection_repository/connection_repository.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/splash/splash.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockControlRepository extends Mock implements ControlRepository {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  late ConnectionRepository connectionRepository;
  late ControlRepository controlRepository;
  late SettingsController settingsController;

  late ValueNotifier<Locale?> locale;
  late ValueNotifier<bool?> darkModeOn;

  late AppData appData;

  setUp(() {
    connectionRepository = _MockConnectionRepository();
    controlRepository = _MockControlRepository();
    settingsController = _MockSettingsController();

    locale = ValueNotifier(null);
    when(() => settingsController.locale).thenReturn(locale);

    darkModeOn = ValueNotifier(null);
    when(() => settingsController.darkModeOn).thenReturn(darkModeOn);

    appData = AppData(
      connectionRepository: connectionRepository,
      controlRepository: controlRepository,
      settingsController: settingsController,
      initialConnectionData: null,
      initialSetupCompleted: false,
    );
  });

  tearDown(() {
    locale.dispose();
    darkModeOn.dispose();
  });

  group(
    'AppLoader',
    () {
      testWidgets('shows SplashPage when loading', (tester) async {
        final completer = Completer<AppData>();

        await tester.pumpWidget(
          AppLoader(
            dataLoader: () => completer.future,
          ),
        );

        expect(find.byType(SplashPage), findsOneWidget);
      });

      testWidgets(
        'first shows SplashPage when dataLoader completes and then shows App '
        'after delay',
        (tester) async {
          final completer = Completer<AppData>();

          await tester.pumpWidget(
            AppLoader(
              dataLoader: () => completer.future,
            ),
          );

          expect(find.byType(SplashPage), findsOneWidget);

          completer.complete(appData);
          await tester.pump();

          expect(find.byType(SplashPage), findsOneWidget);

          await tester.pump(
            SplashPage.kFadeDuration + SplashPage.kAnimationDuration,
          );

          expect(find.byType(App), findsOneWidget);
        },
      );
    },
  );
}
