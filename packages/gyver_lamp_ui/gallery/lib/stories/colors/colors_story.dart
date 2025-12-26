import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ColorsStory extends StatelessWidget {
  const ColorsStory({super.key});

  @override
  Widget build(BuildContext context) {
    final lightColors = [
      const _ColorCard(
        color: GyverLampColors.lightBackground,
        name: 'background',
      ),
      const _ColorCard(
        color: GyverLampColors.lightOnBackground,
        name: 'on-background',
      ),
      const _ColorCard(
        color: GyverLampColors.lightSurfacePrimary,
        name: 'surface-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.lightSurfaceSecondary,
        name: 'surface-secondary',
      ),
      const _ColorCard(
        color: GyverLampColors.lightSurfaceVariant,
        name: 'surface-variant',
      ),
      const _ColorCard(
        color: GyverLampColors.lightBorderPrimary,
        name: 'border-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.lightBorderInput,
        name: 'border-input',
      ),
      const _ColorCard(
        color: GyverLampColors.lightTextPrimary,
        name: 'text-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.lightTextSecondary,
        name: 'text-secondary',
      ),
      const _ColorCard(
        color: GyverLampColors.lightPointer,
        name: 'pointer',
      ),
      const _ColorCard(
        color: GyverLampColors.lightConnectedBackground,
        name: 'connected-background',
      ),
      const _ColorCard(
        color: GyverLampColors.lightConnectedText,
        name: 'connected-text',
      ),
      const _ColorCard(
        color: GyverLampColors.lightConnectingBackground,
        name: 'connecting-background',
      ),
      const _ColorCard(
        color: GyverLampColors.lightConnectingText,
        name: 'connecting-text',
      ),
      const _ColorCard(
        color: GyverLampColors.lightNotConnectedBackground,
        name: 'not-connected-background',
      ),
      const _ColorCard(
        color: GyverLampColors.lightNotConnectedText,
        name: 'not-connected-text',
      ),
      const _ColorCard(
        color: GyverLampColors.lightDivider,
        name: 'divider',
      ),
      const _ColorCard(
        color: GyverLampColors.lightButtonDisabled,
        name: 'button-disabled',
      ),
      const _ColorCard(
        color: GyverLampColors.lightTextButtonDisabled,
        name: 'text-button-disabled',
      ),
    ];

    final darkColors = [
      const _ColorCard(
        color: GyverLampColors.darkBackground,
        name: 'background',
      ),
      const _ColorCard(
        color: GyverLampColors.darkOnBackground,
        name: 'on-background',
      ),
      const _ColorCard(
        color: GyverLampColors.darkSurfacePrimary,
        name: 'surface-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.darkSurfaceSecondary,
        name: 'surface-secondary',
      ),
      const _ColorCard(
        color: GyverLampColors.darkSurfaceVariant,
        name: 'surface-variant',
      ),
      const _ColorCard(
        color: GyverLampColors.darkBorderPrimary,
        name: 'border-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.darkBorderInput,
        name: 'border-input',
      ),
      const _ColorCard(
        color: GyverLampColors.darkTextPrimary,
        name: 'text-primary',
      ),
      const _ColorCard(
        color: GyverLampColors.darkTextSecondary,
        name: 'text-secondary',
      ),
      const _ColorCard(
        color: GyverLampColors.darkPointer,
        name: 'pointer',
      ),
      const _ColorCard(
        color: GyverLampColors.darkConnectedBackground,
        name: 'connected-background',
      ),
      const _ColorCard(
        color: GyverLampColors.darkConnectedText,
        name: 'connected-text',
      ),
      const _ColorCard(
        color: GyverLampColors.darkConnectingBackground,
        name: 'connecting-background',
      ),
      const _ColorCard(
        color: GyverLampColors.darkConnectingText,
        name: 'connecting-text',
      ),
      const _ColorCard(
        color: GyverLampColors.darkNotConnectedBackground,
        name: 'not-connected-background',
      ),
      const _ColorCard(
        color: GyverLampColors.darkNotConnectedText,
        name: 'not-connected-text',
      ),
      const _ColorCard(
        color: GyverLampColors.darkDivider,
        name: 'divider',
      ),
      const _ColorCard(
        color: GyverLampColors.darkButtonDisabled,
        name: 'button-disabled',
      ),
      const _ColorCard(
        color: GyverLampColors.darkTextButtonDisabled,
        name: 'text-button-disabled',
      ),
    ];

    return StoryScaffold(
      title: 'Color Palette',
      image: Image.asset('assets/images/palette.png'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 64,
          vertical: 48,
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
              children: lightColors,
            ),
            const SizedBox(height: 72),
            const Text(
              'Dark Mode',
              style: GalleryTextStyles.headlineMedium,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 48,
              runSpacing: 48,
              children: darkColors,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({
    required this.color,
    required this.name,
  });

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285,
      width: 195,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: GalleryColors.greyBlue,
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              name,
              textAlign: TextAlign.center,
              style: GalleryTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            SelectableText(
              '0x${color.toARGB32().toRadixString(16).toUpperCase()}',
              textAlign: TextAlign.center,
              style: GalleryTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
