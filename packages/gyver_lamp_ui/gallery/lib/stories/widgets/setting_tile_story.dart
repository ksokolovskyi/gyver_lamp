import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SettingTileStory extends StatelessWidget {
  const SettingTileStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Setting Tile',
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Theme(
              data: GyverLampTheme.lightThemeData,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Light Mode',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                    SizedBox(height: 32),
                    _InteractiveDarkModeSettingTile(),
                    SizedBox(height: 12),
                    _StaticLinkLaunchSettingTile(),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Theme(
              data: GyverLampTheme.darkThemeData,
              child: ColoredBox(
                color: GyverLampColors.darkBackground,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GalleryTextStyles.headlineMedium.copyWith(
                          color: GyverLampColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _InteractiveDarkModeSettingTile(),
                      const SizedBox(height: 12),
                      const _StaticLinkLaunchSettingTile(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveDarkModeSettingTile extends StatefulWidget {
  const _InteractiveDarkModeSettingTile();

  @override
  State<_InteractiveDarkModeSettingTile> createState() =>
      _InteractiveDarkModeSettingTileState();
}

class _InteractiveDarkModeSettingTileState
    extends State<_InteractiveDarkModeSettingTile> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SettingTile(
        icon: GyverLampIcons.moon,
        label: 'Dark Mode',
        action: StatefulBuilder(
          builder: (context, setState) {
            return Switcher(
              value: _isDark,
              onChanged: (isDark) {
                setState(() => _isDark = isDark);
              },
            );
          },
        ),
      ),
    );
  }
}

class _StaticLinkLaunchSettingTile extends StatelessWidget {
  const _StaticLinkLaunchSettingTile();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SettingTile(
        icon: GyverLampIcons.mail,
        label: 'Email',
        action: FlatIconButton.medium(
          icon: GyverLampIcons.arrow_outward,
          onPressed: () {},
        ),
      ),
    );
  }
}
