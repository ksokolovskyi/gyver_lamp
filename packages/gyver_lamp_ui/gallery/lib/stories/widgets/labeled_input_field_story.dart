import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:gallery/theme/theme.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class LabeledInputFieldStory extends StatelessWidget {
  const LabeledInputFieldStory({super.key});

  @override
  Widget build(BuildContext context) {
    return StoryScaffold(
      title: 'Labeled Input Field',
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
                    _IPField(),
                    SizedBox(height: 12),
                    LabeledInputField(
                      label: 'Enabled Field',
                    ),
                    SizedBox(height: 12),
                    LabeledInputField(
                      label: 'Disabled Field',
                      enabled: false,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GalleryTextStyles.headlineMedium.copyWith(
                          color: GyverLampColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _IPField(),
                      const SizedBox(height: 12),
                      const LabeledInputField(
                        label: 'Enabled Label',
                      ),
                      const SizedBox(height: 12),
                      const LabeledInputField(
                        label: 'Disabled Field',
                        enabled: false,
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

class _IPField extends StatefulWidget {
  const _IPField();

  @override
  State<_IPField> createState() => __IPFieldState();
}

class __IPFieldState extends State<_IPField> {
  late final _ipRegExp = RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');

  String? _errorText;

  void _validate(String value) {
    final hasMatch = _ipRegExp.hasMatch(value);

    if (hasMatch) {
      if (_errorText != null) {
        setState(() {
          _errorText = null;
        });
      }

      return;
    }

    setState(() {
      _errorText = 'Wrong IP format. Example: 192.168.0.1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LabeledInputField(
      label: 'IP',
      hintText: 'XXX.XXX.XXX.XXX',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: _validate,
      errorText: _errorText,
    );
  }
}
