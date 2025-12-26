import 'package:flutter/material.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

const _kSizeAnimationDuration = Duration(milliseconds: 200);
const _kSwitchAnimationDuration = Duration(milliseconds: 200);

// The size of the icon before the label.
const _kIconSize = 18.0;

// The corner radius of the badge.
const _kBadgeRadius = Radius.circular(30);

/// Signature for the function that returns a string representation of the
/// specific connection status.
typedef ConnectionStatusLabelResolver =
    String Function(
      ConnectionStatus states,
    );

/// Represents the connection status.
enum ConnectionStatus {
  /// Represents a connected status.
  connected,

  /// Represents a connecting status.
  connecting,

  /// Represents a not connected status.
  notConnected,
}

/// {@template connection_status_badge}
/// Gyver Lamp Connection Status Badge.
/// {@endtemplate}
class ConnectionStatusBadge extends StatefulWidget {
  /// {@macro connection_status_badge}
  const ConnectionStatusBadge({
    required this.status,
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Current connection status.
  final ConnectionStatus status;

  /// The function to resolve the label for the specific status.
  final ConnectionStatusLabelResolver label;

  /// Called when the badge is tapped.
  final VoidCallback? onPressed;

  @override
  State<ConnectionStatusBadge> createState() => ConnectionStatusBadgeState();
}

/// Gyver Lamp Connection Status Badge state.
class ConnectionStatusBadgeState extends State<ConnectionStatusBadge> {
  /// Whether the badge is pressed.
  @visibleForTesting
  bool isPressed = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    final textColor = switch (widget.status) {
      (ConnectionStatus.connected) => theme.connectedText,
      (ConnectionStatus.connecting) => theme.connectingText,
      (ConnectionStatus.notConnected) => theme.notConnectedText,
    };

    return RepaintBoundary(
      child: AnimatedContainer(
        clipBehavior: Clip.antiAlias,
        duration: const Duration(milliseconds: 100),
        decoration: ShapeDecoration(
          color: switch (widget.status) {
            (ConnectionStatus.connected) => theme.connectedBackground,
            (ConnectionStatus.connecting) => theme.connectingBackground,
            (ConnectionStatus.notConnected) => theme.notConnectedBackground,
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_kBadgeRadius),
          ),
          shadows: [
            if (widget.onPressed != null && !isPressed) theme.shadows.shadow1,
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            borderRadius: const BorderRadius.all(_kBadgeRadius),
            mouseCursor: widget.onPressed == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            onTap: widget.onPressed,
            onTapDown: widget.onPressed == null
                ? null
                : (_) => setState(() => isPressed = true),
            onTapUp: widget.onPressed == null
                ? null
                : (_) => setState(() => isPressed = false),
            onTapCancel: widget.onPressed == null
                ? null
                : () => setState(() => isPressed = false),
            child: Padding(
              padding: const EdgeInsets.only(
                left: GyverLampSpacings.sm,
                right: GyverLampSpacings.lg,
                top: GyverLampSpacings.sm,
                bottom: GyverLampSpacings.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: _kSwitchAnimationDuration,
                    child: Icon(
                      GyverLampIcons.wifi,
                      key: ValueKey(textColor),
                      color: textColor,
                      size: _kIconSize,
                    ),
                  ),
                  const SizedBox(width: GyverLampSpacings.sm),
                  Flexible(
                    child: AnimatedSize(
                      duration: _kSizeAnimationDuration,
                      curve: Curves.easeOut,
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.antiAlias,
                      child: AnimatedSwitcher(
                        duration: _kSwitchAnimationDuration,
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          final isNewStatus =
                              child.key == ValueKey(widget.status);

                          final yOffset = isNewStatus ? 0.5 : -0.5;

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, yOffset),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        layoutBuilder:
                            (
                              Widget? currentChild,
                              List<Widget> previousChildren,
                            ) {
                              final Widget? previousChild;

                              if (previousChildren.isEmpty) {
                                previousChild = null;
                              } else {
                                previousChild = previousChildren.first;
                              }

                              return Stack(
                                clipBehavior: Clip.antiAlias,
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  if (previousChild != null)
                                    Positioned.fill(
                                      child: OverflowBox(
                                        alignment: Alignment.centerLeft,
                                        maxWidth: double.infinity,
                                        child: previousChild,
                                      ),
                                    ),
                                  ?currentChild,
                                ],
                              );
                            },
                        child: Text(
                          widget.label(widget.status),
                          key: ValueKey(widget.status),
                          style: GyverLampTextStyles.buttonMediumBold.copyWith(
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
