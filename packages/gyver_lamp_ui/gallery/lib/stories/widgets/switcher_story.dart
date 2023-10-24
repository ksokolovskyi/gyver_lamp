import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SwitcherStory extends StatelessWidget {
  const SwitcherStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Switcher',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Light Mode',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                    SizedBox(height: 32),
                    _Switcher(defaultValue: true),
                    SizedBox(height: 12),
                    _Switcher(defaultValue: false),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GalleryTextStyles.headlineMedium.copyWith(
                          color: GyverLampColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _Switcher(defaultValue: true),
                      const SizedBox(height: 12),
                      const _Switcher(defaultValue: false),
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

class _Switcher extends StatefulWidget {
  const _Switcher({required this.defaultValue});

  final bool defaultValue;

  @override
  State<_Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<_Switcher> {
  late bool _enabled = widget.defaultValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switcher(
          value: _enabled,
          onChanged: (value) {
            setState(() {
              _enabled = value;
            });
          },
        ),
      ],
    );
  }
}
