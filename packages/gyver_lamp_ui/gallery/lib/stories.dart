import 'package:dashbook/dashbook.dart';
import 'package:gallery/stories/colors/colors_story.dart';
import 'package:gallery/stories/icons/icons_story.dart';
import 'package:gallery/stories/shadows/shadows_story.dart';
import 'package:gallery/stories/spacings/spacings_story.dart';
import 'package:gallery/stories/typography/typography_story.dart';
import 'package:gallery/stories/widgets/widgets.dart';

void addStories(Dashbook dashbook) {
  dashbook.storiesOf('Color Palette').add(
        'default',
        (_) => const ColorsStory(),
      );

  dashbook.storiesOf('Icons').add(
        'default',
        (_) => const IconsStory(),
      );

  dashbook.storiesOf('Shadows').add(
        'default',
        (_) => const ShadowsStory(),
      );

  dashbook.storiesOf('Spacings').add(
        'default',
        (_) => const SpacingsStory(),
      );

  dashbook.storiesOf('Typography').add(
        'default',
        (_) => const TypographyStory(),
      );

  dashbook.storiesOf('Alert messenger').add(
        'default',
        (_) => const AlertMessengerStory(),
      );

  dashbook.storiesOf('Circles Wave Loading Indicator').add(
        'default',
        (_) => const CirclesWaveLoadingIndicatorStory(),
      );

  dashbook.storiesOf('Confirmation Dialog').add(
        'default',
        (_) => const ConfirmationDialogStory(),
      );

  dashbook.storiesOf('Connection Status Badge').add(
        'default',
        (_) => const ConnectionStatusBadgeStory(),
      );

  dashbook.storiesOf('App Bar').add(
        'default',
        (_) => const CustomAppBarStory(),
      );

  dashbook.storiesOf('Dropdown Button').add(
        'default',
        (_) => const CustomDropdownButtonStory(),
      );

  dashbook.storiesOf('Divider').add(
        'default',
        (_) => const DividerStory(),
      );

  dashbook.storiesOf('Labeled Input Field').add(
        'default',
        (_) => const LabeledInputFieldStory(),
      );

  dashbook.storiesOf('Buttons')
    ..add(
      'Flat Icon Button',
      (_) => const FlatIconButtonStory(),
    )
    ..add(
      'Flat Text Button',
      (_) => const FlatTextButtonStory(),
    )
    ..add(
      'Rounded Elevated Button',
      (_) => const RoundedElevatedButtonStory(),
    )
    ..add(
      'Rounded Outlined Button',
      (_) => const RoundedOutlinedButtonStory(),
    );

  dashbook.storiesOf('Ruler').add(
        'default',
        (_) => const RulerStory(),
      );

  dashbook.storiesOf('Segmented Selector').add(
        'default',
        (_) => const SegmentedSelectorStory(),
      );

  dashbook.storiesOf('Settings')
    ..add(
      'Setting Tile',
      (_) => const SettingTileStory(),
    )
    ..add(
      'Settings Group',
      (_) => const SettingsGroupStory(),
    );

  dashbook.storiesOf('Switcher').add(
        'default',
        (_) => const SwitcherStory(),
      );
}
