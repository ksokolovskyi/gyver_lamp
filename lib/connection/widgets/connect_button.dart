import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

enum _ConnectButtonSize {
  medium,
  large,
}

class ConnectButton extends StatelessWidget {
  const ConnectButton.medium({
    super.key,
  }) : _size = _ConnectButtonSize.medium;

  const ConnectButton.large({
    super.key,
  }) : _size = _ConnectButtonSize.large;

  final _ConnectButtonSize _size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return BlocBuilder<ConnectionBloc, ConnectionState>(
      buildWhen: (p, c) {
        return p.isLampDataValid != c.isLampDataValid ||
            p.isConnecting ||
            c.isConnecting;
      },
      builder: (context, state) {
        return RoundedElevatedButton(
          size: switch (_size) {
            _ConnectButtonSize.medium => RoundedElevatedButtonSize.medium,
            _ConnectButtonSize.large => RoundedElevatedButtonSize.large,
          },
          onPressed: !state.isConnecting && state.isLampDataValid
              ? () {
                  context.read<ConnectionBloc>().add(
                    const ConnectionRequested(),
                  );
                }
              : null,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            reverseDuration: const Duration(milliseconds: 150),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  filterQuality: FilterQuality.medium,
                  scale: Tween<double>(
                    begin: 0,
                    end: 1,
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
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...previousChildren,
                      ?currentChild,
                    ],
                  );
                },
            child: state.isConnecting
                // Need this Stack to make button width remain the same when
                // loading indicator is shown.
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0,
                        child: Text(context.l10n.connect),
                      ),
                      CirclesWaveLoadingIndicator(
                        size: 8,
                        color: theme.background,
                      ),
                    ],
                  )
                : Text(context.l10n.connect),
          ),
        );
      },
    );
  }
}
