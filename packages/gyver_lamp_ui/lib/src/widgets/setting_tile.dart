import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// The minimal height of the tile.
const _kTileHeight = 56.0;

/// The size of the icon.
const _kIconSize = 24.0;

/// {@template setting_tile}
/// Gyver Lamp Setting Tile.
/// {@endtemplate}
class SettingTile extends StatelessWidget {
  /// {@macro setting_tile}
  const SettingTile({
    required this.icon,
    required this.label,
    required this.action,
    super.key,
  });

  /// The icon of the tile.
  final IconData icon;

  /// The label of the tile.
  final String label;

  /// A widget to display after the label.
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _kTileHeight),
      child: ColoredBox(
        color: theme.surfacePrimary,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: GyverLampSpacings.lg,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: _kIconSize,
                      color: theme.textPrimary,
                    ),
                    const SizedBox(width: GyverLampSpacings.sm),
                    Flexible(
                      child: Text(
                        label,
                        style: GyverLampTextStyles.subtitle1.copyWith(
                          color: theme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            action,
          ],
        ),
      ),
    );
  }
}
