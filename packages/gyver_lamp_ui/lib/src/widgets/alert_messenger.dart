import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// The error alert message display duration.
const kErrorAlertDuration = Duration(seconds: 10);

/// The info alert message display duration.
const kInfoAlertDuration = Duration(seconds: 5);

/// The alert message show animation duration.
const kShowDuration = Duration(milliseconds: 250);

/// The alert message hide animation duration.
const kHideDuration = Duration(milliseconds: 150);

/// {@template alert_messenger}
/// Gyver Lamp Alert Messenger.
///
/// Typically [AlertMessenger] is used in the [MaterialApp] builder as follows:
/// ```dart
/// return MaterialApp(
///    home: const Scaffold(),
///    theme: GyverLampTheme.lightThemeData,
///    builder: (context, child) {
///       return AlertMessenger(
///          child: child!,
///       );
///    },
/// );
/// ```
/// {@endtemplate}
class AlertMessenger extends StatefulWidget {
  /// {@macro alert_messenger}
  const AlertMessenger({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Typical usage of the [AlertMessenger.of] function is to call it in
  /// response to a user gesture or an application state change.
  static AlertMessengerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AlertMessengerState>();

    assert(() {
      if (state == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('No AlertMessenger widget found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require an AlertMessenger '
            'widget ancestor.',
          ),
          ...context.describeMissingAncestor(
            expectedAncestorType: AlertMessenger,
          ),
        ]);
      }

      return true;
    }(), '');

    return state!;
  }

  @override
  State<AlertMessenger> createState() => AlertMessengerState();
}

/// State for a [AlertMessenger].
class AlertMessengerState extends State<AlertMessenger>
    with SingleTickerProviderStateMixin {
  final _overlayKey = GlobalKey<OverlayState>();

  final _entries = Queue<OverlayEntry>();

  late final OverlayEntry _childEntry;

  late final AnimationController _controller;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _childEntry = OverlayEntry(
      builder: (context) => widget.child,
      maintainState: true,
      opaque: true,
    );

    _controller = AnimationController(
      vsync: this,
      duration: kShowDuration,
      reverseDuration: kHideDuration,
    );
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry
        ..remove()
        ..dispose();
    }
    _entries.clear();

    _childEntry
      ..remove()
      ..dispose();

    _controller.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        key: _overlayKey,
        initialEntries: [_childEntry],
      ),
    );
  }

  /// Shows an error alert message with animation.
  Future<void> showError({
    required String message,
  }) async {
    final alert = _Alert.error(
      message: message,
      onClose: hide,
    );

    return _show(alert);
  }

  /// Shows an info alert message with animation.
  Future<void> showInfo({
    required String message,
  }) async {
    final alert = _Alert.info(
      message: message,
      onClose: hide,
    );

    return _show(alert);
  }

  Future<void> _show(_Alert alert) async {
    final entry = OverlayEntry(
      builder: (context) => _buildOverlayEntry(alert),
    );

    _entries.addLast(entry);

    if (_timer != null) {
      await hide();
    }

    _overlayKey.currentState!.insert(entry);

    _timer = Timer(alert.duration, hide);

    await _controller.forward();
  }

  /// Hides current alert message with animation.
  Future<void> hide() async {
    if (_entries.isEmpty) {
      return;
    }

    await _controller.reverse();

    _entries.removeFirst().remove();

    _timer?.cancel();
    _timer = null;
  }

  /// Hides current alert message without animation.
  void clear() {
    _timer?.cancel();
    _timer = null;

    for (final entry in _entries) {
      entry.remove();
    }

    _entries.clear();
  }

  Widget _buildOverlayEntry(_Alert alert) {
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double dy;
          final double opacity;

          if (_controller.status == AnimationStatus.forward) {
            final curvedAnimation = Curves.easeOutBack.transform(
              _controller.value,
            );
            dy = (1 - curvedAnimation) * 10;
            opacity = Curves.easeOutQuart.transform(_controller.value);
          } else {
            final curvedAnimation = Curves.easeIn.transform(
              _controller.value,
            );
            dy = (1 - curvedAnimation) * 5;
            opacity = Curves.easeIn.transform(_controller.value);
          }

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, dy),
              child: child,
            ),
          );
        },
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(GyverLampSpacings.xlg),
            child: alert,
          ),
        ),
      ),
    );
  }
}

enum _AlertType {
  error,
  info,
}

class _Alert extends StatelessWidget {
  const _Alert.error({
    required this.message,
    required this.onClose,
  }) : type = _AlertType.error;

  const _Alert.info({
    required this.message,
    required this.onClose,
  }) : type = _AlertType.info;

  final _AlertType type;

  final String message;

  final VoidCallback onClose;

  Duration get duration => switch (type) {
    _AlertType.error => kErrorAlertDuration,
    _AlertType.info => kInfoAlertDuration,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    final Color backgroundColor;
    final Color textColor;
    final Color dividerColor;
    final Color borderColor;

    switch (type) {
      case _AlertType.error:
        backgroundColor = theme.notConnectedBackground;
        textColor = theme.notConnectedText;
        dividerColor = textColor.withValues(alpha: 0.25);
        borderColor = textColor.withValues(alpha: 0.10);

      case _AlertType.info:
        backgroundColor = theme.surfacePrimary;
        textColor = theme.textPrimary;
        dividerColor = theme.borderPrimary;
        borderColor = theme.borderPrimary;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: borderColor),
        boxShadow: [theme.shadows.shadow2],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: GyverLampSpacings.lg,
          right: GyverLampSpacings.sm,
          top: GyverLampSpacings.sm,
          bottom: GyverLampSpacings.sm,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: GyverLampTextStyles.body2.copyWith(
                    color: textColor,
                  ),
                ),
              ),
              GyverLampGaps.md,
              VerticalDivider(
                width: 2,
                thickness: 2,
                color: dividerColor,
              ),
              GyverLampGaps.xs,
              FlatIconButton.medium(
                icon: GyverLampIcons.close,
                color: backgroundColor,
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
