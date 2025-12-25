// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get connect => 'Подключиться';

  @override
  String get skip => 'Пропустить';

  @override
  String get initialSetupPageTitle => 'Добавте свою первую лампу';

  @override
  String get initialSetupFormDescription =>
      'Заполните детали своей лампы чтобы иметь возможность контролировать ее при помощи приложения. Вы можете сделать это позже.';

  @override
  String get ip => 'IP';

  @override
  String get ipErrorHint => 'Неверный формат IP. Пример: 192.168.0.1';

  @override
  String get port => 'Порт';

  @override
  String get portErrorHint => 'Неверный формат порта. Пример: 8888';

  @override
  String get notConnected => 'Не подключена';

  @override
  String get connected => 'Подключена';

  @override
  String get connecting => 'Подключение';

  @override
  String get brightness => 'Яркость';

  @override
  String get speed => 'Скорость';

  @override
  String get scale => 'Масштаб';

  @override
  String get settings => 'Настройки';

  @override
  String get general => 'Основное';

  @override
  String get language => 'Язык';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get getInTouch => 'Обратная связь';

  @override
  String get email => 'Email';

  @override
  String get twitter => 'Twitter';

  @override
  String get dribbble => 'Dribbble';

  @override
  String get otherStuff => 'Другое';

  @override
  String get lampProject => 'Проект лампы';

  @override
  String get credits => 'Авторы';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get wrongFormat => 'Неверный формат';

  @override
  String get connectDialogTitle => 'Подключить лампу';

  @override
  String get disconnectDialogTitle => 'Отключиться от лымпы';

  @override
  String get disconnectDialogBody =>
      'Вы уверены что хотите отключить телефон от лымпы?';

  @override
  String get cancel => 'Закрыть';

  @override
  String get disconnect => 'Отключиться';

  @override
  String get sparklesMode => 'Конфетти';

  @override
  String get fireMode => 'Огонь';

  @override
  String get rainbowVerticalMode => 'Радуга вертикальная';

  @override
  String get rainbowHorizontalMode => 'Радуга горизонтальная';

  @override
  String get colorsMode => 'Цвета';

  @override
  String get madnessMode => 'Безумие';

  @override
  String get cloudsMode => 'Облака';

  @override
  String get lavaMode => 'Лава';

  @override
  String get plasmaMode => 'Плазма';

  @override
  String get rainbowMode => 'Радуга';

  @override
  String get rainbowStripesMode => 'Разужные полоски';

  @override
  String get zebraMode => 'Зебра';

  @override
  String get forestMode => 'Лес';

  @override
  String get oceanMode => 'Океан';

  @override
  String get colorMode => 'Цвет';

  @override
  String get snowMode => 'Снег';

  @override
  String get matrixMode => 'Матрица';

  @override
  String get firefliesMode => 'Светляки';

  @override
  String get connectionFailed =>
      'Произошла ошибка при попытке подключения к лампе. Пожалуйста проверьте правильность IP адреса и порта, и попробуйте подключиться опять.';

  @override
  String get lampIsOn => 'Лампа включена.';

  @override
  String get lampIsOff => 'Лампа выключена.';
}
