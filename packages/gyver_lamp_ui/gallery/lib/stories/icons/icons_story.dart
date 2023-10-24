import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';

class IconsStory extends StatelessWidget {
  const IconsStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Icons',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 64,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _Icon(icon: GyverLampIcons.arrow_left),
                _Icon(icon: GyverLampIcons.arrow_outward),
                _Icon(icon: GyverLampIcons.arrow_right),
                _Icon(icon: GyverLampIcons.chevron_down),
                _Icon(icon: GyverLampIcons.chevron_up),
                _Icon(icon: GyverLampIcons.close),
                _Icon(icon: GyverLampIcons.github),
                _Icon(icon: GyverLampIcons.group),
                _Icon(icon: GyverLampIcons.language),
                _Icon(icon: GyverLampIcons.mail),
                _Icon(icon: GyverLampIcons.moon),
                _Icon(icon: GyverLampIcons.policy),
                _Icon(icon: GyverLampIcons.scale),
                _Icon(icon: GyverLampIcons.settings),
                _Icon(icon: GyverLampIcons.speed),
                _Icon(icon: GyverLampIcons.sun),
                _Icon(icon: GyverLampIcons.twitter),
                _Icon(icon: GyverLampIcons.warning),
                _Icon(icon: GyverLampIcons.wifi),
                _Icon(icon: GyverLampIcons.align_left),
                _Icon(icon: GyverLampIcons.x),
                _Icon(icon: GyverLampIcons.dribbble),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 24,
      color: Colors.black,
    );
  }
}
