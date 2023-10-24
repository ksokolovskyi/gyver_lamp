import 'dart:async';

import 'package:connection_repository/connection_repository.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart' hide ConnectionStatus;
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockControlRepository extends Mock implements ControlRepository {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  const address = '192.168.1.5';
  const port = 8888;

  late ConnectionRepository connectionRepository;
  late ControlRepository controlRepository;
  late SettingsController settingsController;

  late ValueNotifier<Locale?> locale;
  late ValueNotifier<bool?> darkModeOn;

  setUp(() {
    connectionRepository = _MockConnectionRepository();
    controlRepository = _MockControlRepository();
    settingsController = _MockSettingsController();

    locale = ValueNotifier(null);
    when(() => settingsController.locale).thenReturn(locale);

    darkModeOn = ValueNotifier(null);
    when(() => settingsController.darkModeOn).thenReturn(darkModeOn);
  });

  tearDown(() {
    locale.dispose();
    darkModeOn.dispose();
  });

  group('App', () {
    group('renders correctly', () {
      testWidgets('when initialSetupCompleted is false', (tester) async {
        await tester.pumpWidget(
          App(
            data: AppData(
              connectionRepository: connectionRepository,
              controlRepository: controlRepository,
              settingsController: settingsController,
              initialConnectionData: null,
              initialSetupCompleted: false,
            ),
          ),
        );

        expect(find.byType(App), findsOneWidget);
        expect(find.byType(InitialSetupView), findsOneWidget);
      });

      testWidgets('when initialSetupCompleted is true', (tester) async {
        await tester.pumpWidget(
          App(
            data: AppData(
              connectionRepository: connectionRepository,
              controlRepository: controlRepository,
              settingsController: settingsController,
              initialConnectionData: null,
              initialSetupCompleted: true,
            ),
          ),
        );

        expect(find.byType(App), findsOneWidget);
        expect(find.byType(ControlPage), findsOneWidget);
      });
    });

    testWidgets(
      'initiates connection when initialConnectionData is not null',
      (tester) async {
        when(
          () => connectionRepository.connect(
            address: any(named: 'address'),
            port: any(named: 'port'),
          ),
        ).thenAnswer((_) async {});

        final statusesController = StreamController<ConnectionStatus>();
        addTearDown(statusesController.close);
        when(() => connectionRepository.statuses).thenAnswer(
          (_) => statusesController.stream,
        );

        await tester.pumpWidget(
          App(
            data: AppData(
              connectionRepository: connectionRepository,
              controlRepository: controlRepository,
              settingsController: settingsController,
              initialConnectionData: const ConnectionData(
                address: address,
                port: port,
              ),
              initialSetupCompleted: true,
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 500));

        verify(
          () => connectionRepository.connect(address: address, port: port),
        ).called(1);
        verify(() => connectionRepository.statuses).called(1);
      },
    );

    group('themeMode', () {
      testWidgets(
        'is ThemeMode.system when darkModeOn setting is null',
        (tester) async {
          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: false,
              ),
            ),
          );

          final materialApp = tester.widget<MaterialApp>(
            find.byType(MaterialApp),
          );

          expect(materialApp.themeMode, equals(ThemeMode.system));
        },
      );

      testWidgets(
        'is ThemeMode.dark when darkModeOn setting is true',
        (tester) async {
          darkModeOn.value = true;

          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: false,
              ),
            ),
          );

          final materialApp = tester.widget<MaterialApp>(
            find.byType(MaterialApp),
          );

          expect(materialApp.themeMode, equals(ThemeMode.dark));
        },
      );

      testWidgets(
        'is ThemeMode.system when darkModeOn setting is false',
        (tester) async {
          darkModeOn.value = false;

          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: false,
              ),
            ),
          );

          final materialApp = tester.widget<MaterialApp>(
            find.byType(MaterialApp),
          );

          expect(materialApp.themeMode, equals(ThemeMode.system));
        },
      );

      testWidgets(
        'changes when darkModeOn setting changes',
        (tester) async {
          darkModeOn.value = false;

          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: false,
              ),
            ),
          );

          var materialApp = tester.widget<MaterialApp>(
            find.byType(MaterialApp),
          );

          expect(materialApp.themeMode, equals(ThemeMode.system));

          darkModeOn.value = true;
          await tester.pump();

          materialApp = tester.widget<MaterialApp>(
            find.byType(MaterialApp),
          );

          expect(materialApp.themeMode, equals(ThemeMode.dark));
        },
      );
    });

    group('locale', () {
      final localeVariant = ValueVariant(
        AppLocalizations.supportedLocales.toSet(),
      );

      testWidgets(
        'is first supported when locale setting is null',
        (tester) async {
          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: true,
              ),
            ),
          );

          final context = tester.element(find.byType(ControlPage));

          expect(
            Localizations.localeOf(context),
            equals(AppLocalizations.supportedLocales.first),
          );
        },
      );

      testWidgets(
        'is equal to the locale setting',
        (tester) async {
          locale.value = localeVariant.currentValue;

          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: true,
              ),
            ),
          );

          final context = tester.element(find.byType(ControlPage));

          expect(Localizations.localeOf(context), equals(locale.value));
        },
        variant: localeVariant,
      );

      testWidgets(
        'changes when locale setting changes',
        (tester) async {
          locale.value = AppLocalizations.supportedLocales.first;

          await tester.pumpWidget(
            App(
              data: AppData(
                connectionRepository: connectionRepository,
                controlRepository: controlRepository,
                settingsController: settingsController,
                initialConnectionData: null,
                initialSetupCompleted: true,
              ),
            ),
          );

          var context = tester.element(find.byType(ControlPage));

          expect(Localizations.localeOf(context), equals(locale.value));

          locale.value = AppLocalizations.supportedLocales.last;
          await tester.pump();

          context = tester.element(find.byType(ControlPage));

          expect(Localizations.localeOf(context), equals(locale.value));
        },
      );
    });

    testWidgets('creates AlertMessenger', (tester) async {
      await tester.pumpWidget(
        App(
          data: AppData(
            connectionRepository: connectionRepository,
            controlRepository: controlRepository,
            settingsController: settingsController,
            initialConnectionData: null,
            initialSetupCompleted: true,
          ),
        ),
      );

      expect(find.byType(AlertMessenger), findsOneWidget);
    });
  });
}
