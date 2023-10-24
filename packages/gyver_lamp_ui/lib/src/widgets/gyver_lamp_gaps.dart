import 'package:gap/gap.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// Gaps used in the Gyver Lamp UI.
abstract class GyverLampGaps {
  /// xxxs gap (1pt)
  static const Gap xxxs = Gap(GyverLampSpacings.xxxs);

  /// xxs gap (2pt)
  static const Gap xxs = Gap(GyverLampSpacings.xxs);

  /// xs gap (4pt)
  static const Gap xs = Gap(GyverLampSpacings.xs);

  /// sm gap (8pt)
  static const Gap sm = Gap(GyverLampSpacings.sm);

  /// md gap (12pt)
  static const Gap md = Gap(GyverLampSpacings.md);

  /// lg gap (16pt)
  static const Gap lg = Gap(GyverLampSpacings.lg);

  /// smxlg gap (20pt)
  static const Gap xlgsm = Gap(GyverLampSpacings.xlgsm);

  /// xlg gap (24pt)
  static const Gap xlg = Gap(GyverLampSpacings.xlg);

  /// xxlg gap (40pt)
  static const Gap xxlg = Gap(GyverLampSpacings.xxlg);

  /// xxxlg pacing value (64pt)
  static const Gap xxxlg = Gap(GyverLampSpacings.xxxlg);
}
