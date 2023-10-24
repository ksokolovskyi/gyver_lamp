import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class RulerStory extends StatelessWidget {
  const RulerStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Ruler',
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
                    _InteractiveRuler(),
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
                      const _InteractiveRuler(),
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

class _InteractiveRuler extends StatefulWidget {
  const _InteractiveRuler();

  @override
  State<_InteractiveRuler> createState() => _InteractiveRulerState();
}

class _InteractiveRulerState extends State<_InteractiveRuler> {
  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Ruler(
            value: _currentValue,
            maxValue: 255,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
