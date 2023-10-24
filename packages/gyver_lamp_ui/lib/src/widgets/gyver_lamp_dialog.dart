import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The corner radius of the dialog.
const _kBorderRadius = Radius.circular(8);

/// {@template custom_dialog}
/// Gyver Lamp Custom Dialog.
/// {@endtemplate}
class GyverLampDialog extends StatelessWidget {
  /// {@macro custom_dialog}
  const GyverLampDialog({
    required this.title,
    required this.body,
    required this.actions,
    super.key,
  });

  /// The title on top of the dialog.
  final String title;

  /// The widget which represents a body of the dialog.
  final Widget body;

  /// The list of action on the bottom of the dialog.
  final List<Widget> actions;

  /// Shows the dialog.
  static Future<void> show(
    BuildContext context, {
    required Widget dialog,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => dialog,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = Curves.easeOutBack.transform(animation.value);
        final dy = (1 - curvedAnimation) * 40;

        return Opacity(
          opacity: Curves.easeOutQuart.transform(animation.value),
          child: Transform.translate(
            offset: Offset(0, dy),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return Dialog(
      backgroundColor: theme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(_kBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(GyverLampSpacings.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GyverLampTextStyles.headline6Bold.copyWith(
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: GyverLampSpacings.lg),
                DefaultTextStyle(
                  style: GyverLampTextStyles.body2.copyWith(
                    color: theme.textPrimary,
                  ),
                  child: body,
                ),
                const SizedBox(height: GyverLampSpacings.xlg),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: GyverLampSpacings.sm,
                    runSpacing: GyverLampSpacings.sm,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
