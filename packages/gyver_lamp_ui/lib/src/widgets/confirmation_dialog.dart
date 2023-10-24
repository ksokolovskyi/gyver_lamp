import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// {@template confirmation_dialog}
/// Gyver Lamp Confirmation Dialog.
/// {@endtemplate}
class ConfirmationDialog extends StatelessWidget {
  /// {@macro confirmation_dialog}
  const ConfirmationDialog({
    required this.title,
    required this.body,
    required this.onCancel,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    super.key,
  });

  /// The title on top of the dialog.
  final String title;

  /// The text in the body of the dialog.
  final String body;

  /// The label of the cancel button.
  final String cancelLabel;

  /// The label of the confirm button.
  final String confirmLabel;

  /// Called when the cancel button tapped.
  final VoidCallback onCancel;

  /// Called when the confirm button tapped.
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return GyverLampDialog(
      title: title,
      body: Text(body),
      actions: [
        RoundedOutlinedButton.medium(
          onPressed: () {
            Navigator.of(context).maybePop();
            onCancel();
          },
          child: Text(cancelLabel),
        ),
        RoundedElevatedButton.medium(
          onPressed: () {
            Navigator.of(context).maybePop();
            onConfirm();
          },
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
