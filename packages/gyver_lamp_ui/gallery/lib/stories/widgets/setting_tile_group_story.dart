import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SettingsGroupStory extends StatelessWidget {
  const SettingsGroupStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Setting Tile Group',
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
                    _InteractiveSettingTileGroup(),
                    SizedBox(height: 12),
                    _StaticSettingTileGroup(),
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
                      const _InteractiveSettingTileGroup(),
                      const SizedBox(height: 12),
                      const _StaticSettingTileGroup(),
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

enum _Language {
  en,
  ua,
  ru,
}

class _InteractiveSettingTileGroup extends StatefulWidget {
  const _InteractiveSettingTileGroup();

  @override
  State<_InteractiveSettingTileGroup> createState() =>
      __InteractiveSettingTileGroupState();
}

class __InteractiveSettingTileGroupState
    extends State<_InteractiveSettingTileGroup> {
  _Language _language = _Language.ua;
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SettingTileGroup(
        label: 'General',
        tiles: [
          SettingTile(
            icon: GyverLampIcons.language,
            label: 'Language',
            action: StatefulBuilder(
              builder: (context, setState) {
                return SegmentedSelector<_Language>(
                  segments: const [
                    SelectorSegment(
                      value: _Language.en,
                      label: 'EN',
                    ),
                    SelectorSegment(
                      value: _Language.ua,
                      label: 'UA',
                    ),
                    SelectorSegment(
                      value: _Language.ru,
                      label: 'RU',
                    ),
                  ],
                  selected: _language,
                  onChanged: (language) {
                    setState(() => _language = language);
                  },
                );
              },
            ),
          ),
          SettingTile(
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
        ],
      ),
    );
  }
}

class _StaticSettingTileGroup extends StatelessWidget {
  const _StaticSettingTileGroup();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SettingTileGroup(
        label: 'Other Stuff',
        tiles: [
          SettingTile(
            icon: GyverLampIcons.github,
            label: 'Lamp Project',
            action: FlatIconButton.medium(
              icon: GyverLampIcons.arrow_outward,
              onPressed: () {},
            ),
          ),
          SettingTile(
            icon: GyverLampIcons.group,
            label: 'Credits',
            action: FlatIconButton.medium(
              icon: GyverLampIcons.arrow_outward,
              onPressed: () {},
            ),
          ),
          SettingTile(
            icon: GyverLampIcons.policy,
            label: 'Privacy Policy',
            action: FlatIconButton.medium(
              icon: GyverLampIcons.arrow_outward,
              onPressed: () {},
            ),
          ),
          SettingTile(
            icon: GyverLampIcons.align_left,
            label: 'Terms of Use',
            action: FlatIconButton.medium(
              icon: GyverLampIcons.arrow_outward,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
