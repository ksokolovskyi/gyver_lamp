// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get connect => 'Підключитися';

  @override
  String get skip => 'Пропустити';

  @override
  String get initialSetupPageTitle => 'Додайте свою першу лампу';

  @override
  String get initialSetupFormDescription =>
      'Заповніть деталі своєї лампи, щоб мати змогу контролювати її за допомогою застосунку. Ви можете зробити це пізніше.';

  @override
  String get ip => 'IP';

  @override
  String get ipErrorHint => 'Невірний формат IP. Приклад: 192.168.0.1';

  @override
  String get port => 'Порт';

  @override
  String get portErrorHint => 'Невірний формат порта. Приклад: 8888';

  @override
  String get notConnected => 'Не підключена';

  @override
  String get connected => 'Підключена';

  @override
  String get connecting => 'Підключення';

  @override
  String get brightness => 'Яскравість';

  @override
  String get speed => 'Швидкість';

  @override
  String get scale => 'Масштаб';

  @override
  String get settings => 'Налаштування';

  @override
  String get general => 'Основні';

  @override
  String get language => 'Мова';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get getInTouch => 'Зворотній зв\'язок';

  @override
  String get email => 'Email';

  @override
  String get twitter => 'Twitter';

  @override
  String get dribbble => 'Dribbble';

  @override
  String get otherStuff => 'Інше';

  @override
  String get lampProject => 'Проект лампи';

  @override
  String get credits => 'Автори';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get termsOfUse => 'Умови користування';

  @override
  String get wrongFormat => 'Невірний формат';

  @override
  String get connectDialogTitle => 'Подключити лампу';

  @override
  String get disconnectDialogTitle => 'Від\'єднатися від лампи';

  @override
  String get disconnectDialogBody =>
      'Ви впевнені, що хочете від\'єднати телефон від лампи?';

  @override
  String get cancel => 'Закрити';

  @override
  String get disconnect => 'Від\'єднатися';

  @override
  String get sparklesMode => 'Конфетті';

  @override
  String get fireMode => 'Вогонь';

  @override
  String get rainbowVerticalMode => 'Веселка вертикальна';

  @override
  String get rainbowHorizontalMode => 'Веселка горизонтальна';

  @override
  String get colorsMode => 'Кольори';

  @override
  String get madnessMode => 'Божевілля';

  @override
  String get cloudsMode => 'Хмари';

  @override
  String get lavaMode => 'Лава';

  @override
  String get plasmaMode => 'Плазма';

  @override
  String get rainbowMode => 'Веселка';

  @override
  String get rainbowStripesMode => 'Райдужні смужки';

  @override
  String get zebraMode => 'Зебра';

  @override
  String get forestMode => 'Ліс';

  @override
  String get oceanMode => 'Океан';

  @override
  String get colorMode => 'Колір';

  @override
  String get snowMode => 'Сніг';

  @override
  String get matrixMode => 'Матриця';

  @override
  String get firefliesMode => 'Світляки';

  @override
  String get connectionFailed =>
      'Виникла помилка при спробі приєднатися до лампи. Будь-ласка перевірти правильність IP адреси і порту, та спробуйте підключитися знову.';

  @override
  String get lampIsOn => 'Лампу увімкнено.';

  @override
  String get lampIsOff => 'Лампу вимкнено.';
}
