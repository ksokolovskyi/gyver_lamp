import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class RoundedOutlinedButtonStory extends StatelessWidget {
  const RoundedOutlinedButtonStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Rounded Outlined Button',
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
                        RoundedOutlinedButton.small(
                          onPressed: () {},
                          child: const Text('Button'),
                        ),
                        const RoundedOutlinedButton.small(
                          onPressed: null,
                          child: Text('Button'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        RoundedOutlinedButton.medium(
                          onPressed: () {},
                          child: const Text('Button'),
                        ),
                        const RoundedOutlinedButton.medium(
                          onPressed: null,
                          child: Text('Button'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 48,
                      children: [
                        RoundedOutlinedButton.large(
                          onPressed: () {},
                          child: const Text('Button'),
                        ),
                        const RoundedOutlinedButton.large(
                          onPressed: null,
                          child: Text('Button'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final theme =
                            Theme.of(context).extension<GyverLampAppTheme>()!;

                        return Wrap(
                          spacing: 24,
                          runSpacing: 48,
                          children: [
                            RoundedOutlinedButton.large(
                              onPressed: () {},
                              child: CirclesWaveLoadingIndicator(
                                color: theme.textSecondary,
                              ),
                            ),
                            RoundedOutlinedButton.large(
                              onPressed: null,
                              child: CirclesWaveLoadingIndicator(
                                color: theme.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
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
                          RoundedOutlinedButton.small(
                            onPressed: () {},
                            child: const Text('Button'),
                          ),
                          const RoundedOutlinedButton.small(
                            onPressed: null,
                            child: Text('Button'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          RoundedOutlinedButton.medium(
                            onPressed: () {},
                            child: const Text('Button'),
                          ),
                          const RoundedOutlinedButton.medium(
                            onPressed: null,
                            child: Text('Button'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 24,
                        runSpacing: 48,
                        children: [
                          RoundedOutlinedButton.large(
                            onPressed: () {},
                            child: const Text('Button'),
                          ),
                          const RoundedOutlinedButton.large(
                            onPressed: null,
                            child: Text('Button'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Builder(
                        builder: (context) {
                          final theme =
                              Theme.of(context).extension<GyverLampAppTheme>()!;

                          return Wrap(
                            spacing: 24,
                            runSpacing: 48,
                            children: [
                              RoundedOutlinedButton.large(
                                onPressed: () {},
                                child: CirclesWaveLoadingIndicator(
                                  color: theme.textSecondary,
                                ),
                              ),
                              RoundedOutlinedButton.large(
                                onPressed: null,
                                child: CirclesWaveLoadingIndicator(
                                  color: theme.textSecondary,
                                ),
                              ),
                            ],
                          );
                        },
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
