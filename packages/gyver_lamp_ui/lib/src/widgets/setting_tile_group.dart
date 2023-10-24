import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The corner radius of the group.
const _kBorderRadius = Radius.circular(8);

/// {@template setting_tile_group}
/// Gyver Lamp Setting Tile Group.
/// {@endtemplate}
class SettingTileGroup extends StatelessWidget {
  /// {@macro setting_tile_group}
  const SettingTileGroup({
    required this.label,
    required this.tiles,
    super.key,
  });

  /// The label of the group.
  final String label;

  /// The list of the tiles to group.
  final List<SettingTile> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.surfacePrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_kBorderRadius),
        ),
        shadows: [theme.shadows.shadow1],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: GyverLampSpacings.sm,
          horizontal: GyverLampSpacings.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: GyverLampTextStyles.body2.copyWith(
                color: theme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            ...tiles.intersperse(const Divider()),
          ],
        ),
      ),
    );
  }
}
