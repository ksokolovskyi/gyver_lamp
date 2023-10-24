import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:settings_controller/settings_controller.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  static final _segments = AppLocalizations.supportedLocales
      .map(
        (l) => SelectorSegment(
          value: l,
          label: l.languageCode.toUpperCase(),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SettingsController>();

    return ValueListenableBuilder(
      valueListenable: controller.locale,
      builder: (context, savedLocale, _) {
        final contextLocale = savedLocale ?? Localizations.localeOf(context);

        final Locale selectedLocale;

        if (AppLocalizations.supportedLocales.contains(contextLocale)) {
          selectedLocale = contextLocale;
        } else {
          selectedLocale = AppLocalizations.supportedLocales.first;
        }

        return SegmentedSelector<Locale>(
          selected: selectedLocale,
          segments: _segments,
          onChanged: (locale) {
            controller.setLocale(locale: locale);
          },
        );
      },
    );
  }
}
