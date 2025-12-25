import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// Label connect
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Label skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Title on the initial setup page
  ///
  /// In en, this message translates to:
  /// **'Add Your First Lamp'**
  String get initialSetupPageTitle;

  /// Text shown on top of the initial setup form
  ///
  /// In en, this message translates to:
  /// **'Fill in the details of your lamp to easily control it through the app. You can also do it later.'**
  String get initialSetupFormDescription;

  /// Label IP
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get ip;

  /// Error hint shown under IP field after wrong input
  ///
  /// In en, this message translates to:
  /// **'Wrong IP format. Example: 192.168.0.1'**
  String get ipErrorHint;

  /// Label port
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// Error hint shown under Port field after wrong input
  ///
  /// In en, this message translates to:
  /// **'Wrong port format. Example: 8888'**
  String get portErrorHint;

  /// Label not connected
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get notConnected;

  /// Label connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Label connecting
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// Label brightness
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// Label speed
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// Label scale
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get scale;

  /// Label settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label general settings
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Label language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label get in touch settings
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// Label email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label twitter
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// Label dribbble
  ///
  /// In en, this message translates to:
  /// **'Dribbble'**
  String get dribbble;

  /// Label other stuff settings
  ///
  /// In en, this message translates to:
  /// **'Other Stuff'**
  String get otherStuff;

  /// Label lamp project
  ///
  /// In en, this message translates to:
  /// **'Lamp Project'**
  String get lampProject;

  /// Label credits
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// Label privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Label terms of use
  ///
  /// In en, this message translates to:
  /// **'Terms Of Use'**
  String get termsOfUse;

  /// Label wrong format
  ///
  /// In en, this message translates to:
  /// **'Wrong format'**
  String get wrongFormat;

  /// Title text in connect dialog
  ///
  /// In en, this message translates to:
  /// **'Connect lamp'**
  String get connectDialogTitle;

  /// Title text in disconnect dialog
  ///
  /// In en, this message translates to:
  /// **'Disconnect from lamp'**
  String get disconnectDialogTitle;

  /// Body text in disconnect dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect the phone from the lamp?'**
  String get disconnectDialogBody;

  /// Label cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label disconnect
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Label for the sparkles mode
  ///
  /// In en, this message translates to:
  /// **'Sparkles'**
  String get sparklesMode;

  /// Label for the fire mode
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fireMode;

  /// Label for the rainbow vertical mode
  ///
  /// In en, this message translates to:
  /// **'Rainbow Vertical'**
  String get rainbowVerticalMode;

  /// Label for the rainbow horizontal mode
  ///
  /// In en, this message translates to:
  /// **'Rainbow Horizontal'**
  String get rainbowHorizontalMode;

  /// Label for the colors mode
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorsMode;

  /// Label for the madness mode
  ///
  /// In en, this message translates to:
  /// **'Madness'**
  String get madnessMode;

  /// Label for the clouds mode
  ///
  /// In en, this message translates to:
  /// **'Clouds'**
  String get cloudsMode;

  /// Label for the lava mode
  ///
  /// In en, this message translates to:
  /// **'Lava'**
  String get lavaMode;

  /// Label for the plasma mode
  ///
  /// In en, this message translates to:
  /// **'Plasma'**
  String get plasmaMode;

  /// Label for the rainbow mode
  ///
  /// In en, this message translates to:
  /// **'Rainbow'**
  String get rainbowMode;

  /// Label for the rainbow stripes mode
  ///
  /// In en, this message translates to:
  /// **'Rainbow Stripes'**
  String get rainbowStripesMode;

  /// Label for the zebra mode
  ///
  /// In en, this message translates to:
  /// **'Zebra'**
  String get zebraMode;

  /// Label for the forest mode
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forestMode;

  /// Label for the ocean mode
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get oceanMode;

  /// Label for the color mode
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorMode;

  /// Label for the snow mode
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get snowMode;

  /// Label for the matrix mode
  ///
  /// In en, this message translates to:
  /// **'Matrix'**
  String get matrixMode;

  /// Label for the fireflies mode
  ///
  /// In en, this message translates to:
  /// **'Fireflies'**
  String get firefliesMode;

  /// Error text shown after unsuccessful connection attempt
  ///
  /// In en, this message translates to:
  /// **'Error while connecting to the lamp. Please check IP and Port and try again.'**
  String get connectionFailed;

  /// Text shown after lamp is toggled on
  ///
  /// In en, this message translates to:
  /// **'Lamp is ON.'**
  String get lampIsOn;

  /// Text shown after lamp is toggled off
  ///
  /// In en, this message translates to:
  /// **'Lamp is OFF.'**
  String get lampIsOff;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
