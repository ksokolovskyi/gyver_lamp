import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class FlatIconButtonStory extends StatelessWidget {
  const FlatIconButtonStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Icon Button',
      image: Image.asset('assets/images/button.png'),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Theme(
              data: GyverLampTheme.lightThemeData,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Light Mode',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        FlatIconButton.medium(
                          icon: GyverLampIcons.settings,
                          onPressed: () {},
                        ),
                        const FlatIconButton.medium(
                          icon: GyverLampIcons.settings,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        FlatIconButton.large(
                          icon: GyverLampIcons.settings,
                          onPressed: () {},
                        ),
                        const FlatIconButton.large(
                          icon: GyverLampIcons.settings,
                          onPressed: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          FlatIconButton.medium(
                            icon: GyverLampIcons.settings,
                            onPressed: () {},
                          ),
                          const FlatIconButton.medium(
                            icon: GyverLampIcons.settings,
                            onPressed: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          FlatIconButton.large(
                            icon: GyverLampIcons.settings,
                            onPressed: () {},
                          ),
                          const FlatIconButton.large(
                            icon: GyverLampIcons.settings,
                            onPressed: null,
                          ),
                        ],
                      ),
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
