import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SpacingsStory extends StatelessWidget {
  const SpacingsStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScaffold(
      title: 'Spacings',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 64,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SpacingDescription(
              spacing: GyverLampSpacings.xxxs,
              name: 'xxxs',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xxs,
              name: 'xxs',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xs,
              name: 'xs',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.sm,
              name: 'sm',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.md,
              name: 'md',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.lg,
              name: 'lg',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xlgsm,
              name: 'xlgsm',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xlg,
              name: 'xlg',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xxlg,
              name: 'xxlg',
            ),
            GyverLampGaps.xlg,
            _SpacingDescription(
              spacing: GyverLampSpacings.xxxlg,
              name: 'xxxlg',
            ),
          ],
        ),
      ),
    );
  }
}

class _SpacingDescription extends StatelessWidget {
  const _SpacingDescription({
    required this.spacing,
    required this.name,
  });

  final double spacing;

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 75,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox.square(
              dimension: spacing,
              child: const ColoredBox(color: Colors.red),
            ),
          ),
        ),
        GyverLampGaps.lg,
        SelectableText(
          name,
          style: GalleryTextStyles.bodyLarge,
        ),
      ],
    );
  }
}
