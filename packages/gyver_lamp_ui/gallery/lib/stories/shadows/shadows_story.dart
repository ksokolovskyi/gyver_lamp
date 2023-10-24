import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ShadowsStory extends StatelessWidget {
  const ShadowsStory({super.key});

  @override
  Widget build(BuildContext context) {
    final lightShadows = [
      _ShadowCard(
        brightness: Brightness.light,
        shadow: GyverLampShadows.light.shadow1,
        name: 'Elevation 1',
        description: 'used for input field, dropdown menu, surfaces',
      ),
      _ShadowCard(
        brightness: Brightness.light,
        shadow: GyverLampShadows.light.shadow2,
        name: 'Elevation 2',
        description: 'used for enabled buttons',
      ),
      _ShadowCard(
        brightness: Brightness.light,
        shadow: GyverLampShadows.light.shadow3,
        name: 'Elevation 3',
        description: 'used for overlays',
      ),
      _ShadowCard(
        brightness: Brightness.light,
        shadow: GyverLampShadows.light.shadow4,
        name: 'Elevation 4',
        description: 'used to display the effect',
      ),
    ];

    final darkShadows = [
      _ShadowCard(
        brightness: Brightness.dark,
        shadow: GyverLampShadows.dark.shadow1,
        name: 'Elevation 1',
        description: 'used for input field, dropdown menu, surfaces',
      ),
      _ShadowCard(
        brightness: Brightness.dark,
        shadow: GyverLampShadows.dark.shadow2,
        name: 'Elevation 2',
        description: 'used for enabled buttons',
      ),
      _ShadowCard(
        brightness: Brightness.dark,
        shadow: GyverLampShadows.dark.shadow3,
        name: 'Elevation 3',
        description: 'used for overlays',
      ),
      _ShadowCard(
        brightness: Brightness.dark,
        shadow: GyverLampShadows.dark.shadow4,
        name: 'Elevation 4',
        description: 'used to display the effect',
      ),
    ];

    return StoryScaffold(
      title: 'Shadows',
      image: Image.asset('assets/images/palette.png'),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
                    spacing: 48,
                    runSpacing: 48,
                    children: lightShadows,
                  ),
                ],
              ),
            ),
            ColoredBox(
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
                      spacing: 48,
                      runSpacing: 48,
                      children: darkShadows,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({
    required this.brightness,
    required this.shadow,
    required this.name,
    required this.description,
  });

  final Brightness brightness;
  final BoxShadow shadow;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: ShapeDecoration(
                color: brightness == Brightness.light
                    ? Colors.white
                    : GyverLampColors.darkSurfacePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [shadow],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SelectableText(
            name,
            textAlign: TextAlign.start,
            style: brightness == Brightness.light
                ? GalleryTextStyles.bodyLarge
                : GalleryTextStyles.bodyLarge.copyWith(
                    color: GyverLampColors.darkTextPrimary,
                  ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            description,
            textAlign: TextAlign.start,
            style: brightness == Brightness.light
                ? GalleryTextStyles.bodyMedium
                : GalleryTextStyles.bodyMedium.copyWith(
                    color: GyverLampColors.darkTextSecondary,
                  ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
