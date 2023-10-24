import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class TypographyStory extends StatelessWidget {
  const TypographyStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Typography',
      image: Image.asset('assets/images/typography.png'),
      trailing: const Text(
        'Font: Inter',
        style: GalleryTextStyles.titleLarge,
        overflow: TextOverflow.ellipsis,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 64,
          vertical: 48,
        ),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Regular Style',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Bold Style',
                      style: GalleryTextStyles.headlineMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Headline 4',
                        style: GyverLampTextStyles.headline4,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Headline 5',
                        style: GyverLampTextStyles.headline5,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Headline 6',
                        style: GyverLampTextStyles.headline6,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Subtitle 1',
                        style: GyverLampTextStyles.subtitle1,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Subtitle 2',
                        style: GyverLampTextStyles.subtitle2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Body 1',
                        style: GyverLampTextStyles.body1,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Body 2',
                        style: GyverLampTextStyles.body2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Large',
                        style: GyverLampTextStyles.buttonLarge,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Medium',
                        style: GyverLampTextStyles.buttonMedium,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Small',
                        style: GyverLampTextStyles.buttonSmall,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Caption',
                        style: GyverLampTextStyles.caption,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'OVERLINE',
                        style: GyverLampTextStyles.overline,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Headline 4',
                        style: GyverLampTextStyles.headline4Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Headline 5',
                        style: GyverLampTextStyles.headline5Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Headline 6',
                        style: GyverLampTextStyles.headline6Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Subtitle 1',
                        style: GyverLampTextStyles.subtitle1Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Subtitle 2',
                        style: GyverLampTextStyles.subtitle2Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Body 1',
                        style: GyverLampTextStyles.body1Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Body 2',
                        style: GyverLampTextStyles.body2Bold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Large',
                        style: GyverLampTextStyles.buttonLargeBold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Medium',
                        style: GyverLampTextStyles.buttonMediumBold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Button Small',
                        style: GyverLampTextStyles.buttonSmallBold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Caption',
                        style: GyverLampTextStyles.captionBold,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'OVERLINE',
                        style: GyverLampTextStyles.overlineBold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
