import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class CustomAppBarStory extends StatelessWidget {
  const CustomAppBarStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'App Bar',
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
                    _ActionsAppBar(),
                    SizedBox(height: 12),
                    _TitleAppBar(),
                    SizedBox(height: 12),
                    _ScrollableAppBar(),
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
                      const _ActionsAppBar(),
                      const SizedBox(height: 12),
                      const _TitleAppBar(),
                      const SizedBox(height: 12),
                      const _ScrollableAppBar(),
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

class _ActionsAppBar extends StatelessWidget {
  const _ActionsAppBar();

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      padding: const EdgeInsets.symmetric(
        horizontal: GyverLampSpacings.xlgsm,
      ),
      leading: ConnectionStatusBadge(
        status: ConnectionStatus.connected,
        label: (_) => 'Connected',
        onPressed: () {},
      ),
      actions: [
        FlatIconButton.medium(
          icon: GyverLampIcons.settings,
          onPressed: () {},
        ),
        Switcher(
          value: true,
          onChanged: (_) {},
        ),
      ],
    );
  }
}

class _TitleAppBar extends StatelessWidget {
  const _TitleAppBar();

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: FlatIconButton.medium(
        icon: GyverLampIcons.arrow_left,
        onPressed: () {},
      ),
      title: 'Title',
    );
  }
}

class _ScrollableAppBar extends StatelessWidget {
  const _ScrollableAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return SizedBox(
      height: 200,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Scroll Me',
        ),
        body: ColoredBox(
          color: theme.surfacePrimary,
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              return Text(
                '$index',
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
    );
  }
}
