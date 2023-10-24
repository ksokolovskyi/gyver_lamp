import 'package:flutter/material.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// {@template labeled_input_field}
/// Gyver Lamp Labeled Input Field.
/// {@endtemplate}
class LabeledInputField extends StatefulWidget {
  /// {@macro labeled_input_field}
  const LabeledInputField({
    required this.label,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    super.key,
  });

  /// Label placed on top of input field.
  final String label;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The type of information for which to optimize the text input control.
  final TextInputType? keyboardType;

  /// The text that suggests what sort of input the field accepts.
  final String? hintText;

  /// The text that appears below the field and indicates an error.
  final String? errorText;

  /// The callback that is called when a new text is entered.
  final ValueChanged<String>? onChanged;

  /// Whether the field is enabled and can be edited.
  final bool enabled;

  /// Whether error exists.
  bool get hasError => errorText != null && errorText!.isNotEmpty;

  @override
  State<LabeledInputField> createState() => _LabeledInputFieldState();
}

class _LabeledInputFieldState extends State<LabeledInputField> {
  late final _internalFocusNode = FocusNode();
  late final _internalController = TextEditingController();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void dispose() {
    _internalFocusNode.dispose();
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GyverLampSpacings.xs,
          ),
          child: Text(
            widget.label,
            style: GyverLampTextStyles.subtitle2.copyWith(
              color: theme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          height: GyverLampSpacings.xs,
        ),
        Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: widget.enabled ? [theme.shadows.shadow1] : null,
                ),
              ),
            ),
            TextField(
              focusNode: _effectiveFocusNode,
              controller: _effectiveController,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                hintText: widget.hintText,
                contentPadding: const EdgeInsets.all(GyverLampSpacings.md),
                isCollapsed: true,
                suffixIcon: RepaintBoundary(
                  child: ListenableBuilder(
                    listenable: _effectiveController,
                    builder: (context, _) {
                      return AnimatedOpacity(
                        opacity: _effectiveController.text.isEmpty ? 0 : 1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        child: GestureDetector(
                          child: const Icon(
                            GyverLampIcons.close,
                            size: 24,
                          ),
                          onTap: () {
                            _effectiveFocusNode.requestFocus();
                            _effectiveController.clear();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              enabled: widget.enabled,
              enableSuggestions: false,
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              style: GyverLampTextStyles.body2.copyWith(
                color: theme.textSecondary,
              ),
              cursorRadius: const Radius.circular(2),
              cursorWidth: 1.5,
              onChanged: (value) {
                final onChanged = widget.onChanged;

                if (onChanged == null) {
                  return;
                }

                onChanged(value);
              },
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 150),
                  opacity: widget.hasError ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: theme.notConnectedText),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.hasError) _Error(errorText: widget.errorText!),
      ],
    );
  }
}

class _Error extends StatefulWidget {
  const _Error({
    required this.errorText,
  });

  final String errorText;

  @override
  State<_Error> createState() => _ErrorState();
}

class _ErrorState extends State<_Error> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return FadeTransition(
      opacity: _opacity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: GyverLampSpacings.xs,
          right: GyverLampSpacings.xs,
          top: GyverLampSpacings.xs,
        ),
        child: Text(
          widget.errorText,
          style: GyverLampTextStyles.caption.copyWith(
            color: theme.notConnectedText,
          ),
        ),
      ),
    );
  }
}
