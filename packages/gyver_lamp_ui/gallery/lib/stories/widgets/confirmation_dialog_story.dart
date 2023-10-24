import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ConfirmationDialogStory extends StatelessWidget {
  const ConfirmationDialogStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Confirmation Dialog',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Light Mode',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    RoundedElevatedButton.large(
                      child: const Text('Show dialog'),
                      onPressed: () {
                        GyverLampDialog.show(
                          context,
                          dialog: Theme(
                            data: GyverLampTheme.lightThemeData,
                            child: const _DisconnectConfirmationDialog(),
                          ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GalleryTextStyles.headlineMedium.copyWith(
                          color: GyverLampColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      RoundedElevatedButton.large(
                        child: const Text('Show dialog'),
                        onPressed: () {
                          GyverLampDialog.show(
                            context,
                            dialog: Theme(
                              data: GyverLampTheme.darkThemeData,
                              child: const _DisconnectConfirmationDialog(),
                            ),
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

class _DisconnectConfirmationDialog extends StatelessWidget {
  const _DisconnectConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Disconnect from Lamp',
      body: 'Are you sure you want to disconnect the phone from the lamp?',
      cancelLabel: 'Cancel',
      confirmLabel: 'Disconnect',
      onCancel: () {},
      onConfirm: () {},
    );
  }
}
