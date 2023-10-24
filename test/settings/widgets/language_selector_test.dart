import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/widgets/widgets.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('LanguageSelector', () {
    final localeVariant = ValueVariant(
      AppLocalizations.supportedLocales.toSet(),
    );

    late ValueNotifier<Locale?> locale;
    late SettingsController settingsController;

    setUpAll(() {
      registerFallbackValue(const Locale('en'));
    });

    setUp(() {
      locale = ValueNotifier(null);

      settingsController = _MockSettingsController();
      when(() => settingsController.locale).thenReturn(locale);
      when(
        () => settingsController.setLocale(locale: any(named: 'locale')),
      ).thenReturn(null);
    });

    tearDown(() {
      locale.dispose();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpSubject(
        controller: settingsController,
        subject: const LanguageSelector(),
      );

      expect(find.byType(LanguageSelector), findsOneWidget);
      expect(find.byType(SegmentedSelector<Locale>), findsOneWidget);
    });

    testWidgets(
      'first locale is selected when setting is not set',
      (WidgetTester tester) async {
        locale.value = null;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
        );

        final selector = tester.widget<SegmentedSelector<Locale>>(
          find.byType(SegmentedSelector<Locale>),
        );
        expect(
          selector.selected,
          equals(AppLocalizations.supportedLocales.first),
        );
      },
    );

    testWidgets(
      'first locale is selected when not supported locale is set',
      (WidgetTester tester) async {
        locale.value = const Locale('fr');

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
        );

        final selector = tester.widget<SegmentedSelector<Locale>>(
          find.byType(SegmentedSelector<Locale>),
        );
        expect(
          selector.selected,
          equals(AppLocalizations.supportedLocales.first),
        );
      },
    );

    testWidgets(
      'context locale is selected when setting is not set',
      (WidgetTester tester) async {
        locale.value = null;

        final contextLocale = AppLocalizations.supportedLocales.last;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
          locale: contextLocale,
        );

        final selector = tester.widget<SegmentedSelector<Locale>>(
          find.byType(SegmentedSelector<Locale>),
        );
        expect(selector.selected, equals(contextLocale));
      },
    );

    testWidgets(
      'correctly sets initially selected locale from context',
      (WidgetTester tester) async {
        locale.value = null;

        final contextLocale = localeVariant.currentValue!;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
          locale: contextLocale,
        );

        final selector = tester.widget<SegmentedSelector<Locale>>(
          find.byType(SegmentedSelector<Locale>),
        );
        expect(selector.selected, equals(contextLocale));
      },
      variant: localeVariant,
    );

    testWidgets(
      'correctly sets initially selected locale from setting',
      (WidgetTester tester) async {
        final settingLocale = localeVariant.currentValue!;

        locale.value = settingLocale;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
        );

        final selector = tester.widget<SegmentedSelector<Locale>>(
          find.byType(SegmentedSelector<Locale>),
        );
        expect(selector.selected, equals(settingLocale));
      },
      variant: localeVariant,
    );

    testWidgets(
      'calls SettingsController.setLocale when new locale is selected',
      (WidgetTester tester) async {
        final locales = localeVariant.values.toList();
        final currentLocale = localeVariant.currentValue!;
        final nextIndex = (locales.indexOf(currentLocale) + 1) % locales.length;
        final nextLocale = locales[nextIndex];

        locale.value = currentLocale;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const LanguageSelector(),
        );

        await tester.tap(find.text(nextLocale.toString().toUpperCase()));

        verify(
          () => settingsController.setLocale(locale: nextLocale),
        ).called(1);
      },
      variant: localeVariant,
    );
  });
}

extension _DarkModeSwitcher on WidgetTester {
  Future<void> pumpSubject({
    required SettingsController controller,
    required Widget subject,
    Locale? locale,
  }) {
    return pumpWidget(
      Provider<SettingsController>.value(
        value: controller,
        child: MaterialApp(
          locale: locale,
          supportedLocales: {
            ...AppLocalizations.supportedLocales,
            if (locale != null) locale,
          }.toList(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: GyverLampTheme.lightThemeData,
          home: Scaffold(
            body: Center(child: subject),
          ),
        ),
      ),
    );
  }
}
