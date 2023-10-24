import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('GyverLampGaps', () {
    const gaps = [
      GyverLampGaps.xxxs,
      GyverLampGaps.xxs,
      GyverLampGaps.xs,
      GyverLampGaps.sm,
      GyverLampGaps.md,
      GyverLampGaps.lg,
      GyverLampGaps.xlgsm,
      GyverLampGaps.xlg,
      GyverLampGaps.xxlg,
      GyverLampGaps.xxxlg,
    ];

    testWidgets('can be used in Row', (tester) async {
      await tester.pumpSubject(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: gaps,
        ),
      );

      expect(
        find.byType(Gap),
        findsNWidgets(gaps.length),
      );

      final size = tester.getSize(find.byType(Row));

      expect(
        size.width,
        equals(
          gaps.fold<double>(0, (sum, gap) => sum + gap.mainAxisExtent),
        ),
      );
    });

    testWidgets('can be used in Column', (tester) async {
      await tester.pumpSubject(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: gaps,
        ),
      );

      expect(
        find.byType(Gap),
        findsNWidgets(gaps.length),
      );

      final size = tester.getSize(find.byType(Column));

      expect(
        size.height,
        equals(
          gaps.fold<double>(0, (sum, gap) => sum + gap.mainAxisExtent),
        ),
      );
    });
  });
}

extension _GyverLampGaps on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
