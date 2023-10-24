import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

enum Language {
  english,
  ukrainian,
  russian,
}

class SegmentedSelectorStory extends StatelessWidget {
  const SegmentedSelectorStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Segmented Selector',
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
                    _Selector(),
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
                      const _Selector(),
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

class _Selector extends StatefulWidget {
  const _Selector();

  @override
  State<_Selector> createState() => __SelectorState();
}

class __SelectorState extends State<_Selector> {
  Language _selected = Language.english;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SegmentedSelector<Language>(
          segments: const [
            SelectorSegment(
              value: Language.english,
              label: 'EN',
            ),
            SelectorSegment(
              value: Language.ukrainian,
              label: 'UA',
            ),
            SelectorSegment(
              value: Language.russian,
              label: 'RU',
            ),
          ],
          selected: _selected,
          onChanged: (language) {
            setState(() {
              _selected = language;
            });
          },
        ),
      ],
    );
  }
}
