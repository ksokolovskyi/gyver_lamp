import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class CustomDropdownButtonStory extends StatelessWidget {
  const CustomDropdownButtonStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Custom Dropdown Button',
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
                    _InteractiveCustomDropdownButton(),
                    SizedBox(height: 200),
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
                      const _InteractiveCustomDropdownButton(),
                      const SizedBox(height: 200),
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

enum _Mode {
  colorChange,
  rainbowVertical,
  rainbowHorizontal,
  confetti,
  fire,
  matrix,
  clouds,
  lava,
}

class _InteractiveCustomDropdownButton extends StatefulWidget {
  const _InteractiveCustomDropdownButton();

  @override
  State<_InteractiveCustomDropdownButton> createState() =>
      _InteractiveCustomDropdownButtonState();
}

class _InteractiveCustomDropdownButtonState
    extends State<_InteractiveCustomDropdownButton> {
  var _mode = _Mode.colorChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomDropdownButton<_Mode>(
            items: const [
              CustomDropdownMenuItem(
                value: _Mode.colorChange,
                label: 'Color Change',
              ),
              CustomDropdownMenuItem(
                value: _Mode.rainbowVertical,
                label: 'Rainbow Vertical',
              ),
              CustomDropdownMenuItem(
                value: _Mode.rainbowHorizontal,
                label: 'Rainbow Horizontal',
              ),
              CustomDropdownMenuItem(
                value: _Mode.confetti,
                label: 'Confetti',
              ),
              CustomDropdownMenuItem(
                value: _Mode.fire,
                label: 'Fire',
              ),
              CustomDropdownMenuItem(
                value: _Mode.matrix,
                label: 'Matrix',
              ),
              CustomDropdownMenuItem(
                value: _Mode.clouds,
                label: 'Clouds',
              ),
              CustomDropdownMenuItem(
                value: _Mode.lava,
                label: 'Lava',
              ),
            ],
            selected: _mode,
            onChanged: (value) {
              setState(() {
                _mode = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
