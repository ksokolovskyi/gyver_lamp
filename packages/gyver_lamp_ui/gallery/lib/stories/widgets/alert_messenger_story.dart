import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class AlertMessengerStory extends StatelessWidget {
  const AlertMessengerStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Alert Messenger',
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
                    SizedBox(
                      height: 300,
                      child: _AlertMessenger(),
                    ),
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
                      const SizedBox(
                        height: 300,
                        child: _AlertMessenger(),
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

class _AlertMessenger extends StatelessWidget {
  const _AlertMessenger();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context),
        home: Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.borderInput),
            ),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedElevatedButton.large(
                          child: const Text('Show info'),
                          onPressed: () {
                            AlertMessenger.of(context).showInfo(
                              message: 'Test info message.',
                            );
                          },
                        ),
                        GyverLampGaps.lg,
                        RoundedElevatedButton.large(
                          child: const Text('Show error'),
                          onPressed: () {
                            AlertMessenger.of(context).showError(
                              message: 'Test error message.',
                            );
                          },
                        ),
                      ],
                    ),
                    GyverLampGaps.lg,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedOutlinedButton.large(
                          child: const Text('Hide'),
                          onPressed: () {
                            AlertMessenger.of(context).hide();
                          },
                        ),
                        GyverLampGaps.lg,
                        RoundedOutlinedButton.large(
                          child: const Text('Clear'),
                          onPressed: () {
                            AlertMessenger.of(context).clear();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        builder: (context, child) {
          return AlertMessenger(child: child!);
        },
      ),
    );
  }
}
