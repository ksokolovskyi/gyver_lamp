import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

class MockAlertMessengerProvider extends AlertMessenger {
  const MockAlertMessengerProvider({
    required this.messenger,
    required super.child,
    super.key,
  });

  final MockAlertMessenger messenger;

  @override
  AlertMessengerState createState() {
    // ignore: no_logic_in_create_state
    return _MockAlertMessengerState(messenger: messenger);
  }
}

class MockAlertMessenger extends Mock
    with _MockAlertMessengerDiagnosticsMixin
    implements AlertMessengerState {}

class _MockAlertMessengerState extends State<AlertMessenger>
    with SingleTickerProviderStateMixin
    implements AlertMessengerState {
  _MockAlertMessengerState({
    required this.messenger,
  });

  final MockAlertMessenger messenger;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  Future<void> showError({
    required String message,
  }) async {
    return messenger.showError(message: message);
  }

  @override
  Future<void> showInfo({
    required String message,
  }) async {
    return messenger.showInfo(message: message);
  }

  @override
  Future<void> hide() async {
    return messenger.hide();
  }

  @override
  void clear() {
    messenger.clear();
  }
}

mixin _MockAlertMessengerDiagnosticsMixin on Object {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}
