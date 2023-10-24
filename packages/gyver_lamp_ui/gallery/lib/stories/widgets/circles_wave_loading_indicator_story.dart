import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class CirclesWaveLoadingIndicatorStory extends StatelessWidget {
  const CirclesWaveLoadingIndicatorStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Circles Wave Loading Indicator',
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 64,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CirclesWaveLoadingIndicator(size: 8),
              GyverLampGaps.md,
              CirclesWaveLoadingIndicator(),
              GyverLampGaps.md,
              CirclesWaveLoadingIndicator(size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
