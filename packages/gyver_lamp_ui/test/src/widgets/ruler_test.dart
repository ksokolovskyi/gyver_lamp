import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tactile_feedback/tactile_feedback_platform_interface.dart';

class _MockTactileFeedbackPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TactileFeedbackPlatform {}

void main() {
  late TactileFeedbackPlatform tactileFeedbackPlatform;

  setUp(() {
    tactileFeedbackPlatform = _MockTactileFeedbackPlatform();

    when(tactileFeedbackPlatform.impact).thenAnswer((_) async {});

    TactileFeedbackPlatform.instance = tactileFeedbackPlatform;
  });

  group('Ruler', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        Ruler(
          value: 1,
          maxValue: 100,
          onChanged: (value) {},
        ),
      );

      expect(find.byType(Ruler), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets(
      'animates after new value provided to the widget',
      (tester) async {
        await tester.pumpSubject(
          Ruler(
            value: 1,
            maxValue: 100,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        expect(tester.binding.hasScheduledFrame, isFalse);

        await tester.pumpSubject(
          Ruler(
            value: 3,
            maxValue: 100,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        expect(tester.binding.hasScheduledFrame, isTrue);

        await tester.pumpAndSettle();

        expect(tester.binding.hasScheduledFrame, isFalse);

        expect(find.text('3'), findsOneWidget);
      },
    );

    testWidgets(
      'does not call onChanged after new value provided to the widget',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          Ruler(
            value: 1,
            maxValue: 100,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pump();

        await tester.pumpSubject(
          Ruler(
            value: 3,
            maxValue: 100,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pumpAndSettle();

        expect(wasCalled, isFalse);
      },
    );

    testWidgets(
      'calls onChange for every mark hit during the drag',
      (tester) async {
        final valueNotifier = ValueNotifier(1);

        final changes = <int>[];

        await tester.pumpSubject(
          ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (context, value, _) {
              return Ruler(
                value: value,
                maxValue: 100,
                onChanged: (value) {
                  valueNotifier.value = value;
                  changes.add(value);
                },
              );
            },
          ),
        );

        await tester.dragNMarks(3);

        await tester.pumpAndSettle();

        final expectedChanges = [2, 3, 4];

        expect(changes.length, equals(expectedChanges.length));
        expect(changes, containsAllInOrder(expectedChanges));
        expect(find.text('4'), findsOneWidget);
      },
    );

    testWidgets(
      'correctly works with fling gesture',
      (tester) async {
        for (final platform in TargetPlatform.values) {
          debugDefaultTargetPlatformOverride = platform;

          final changes = <int>[];

          await tester.pumpSubject(
            Builder(
              builder: (context) {
                return Theme(
                  data: Theme.of(context).copyWith(platform: platform),
                  child: Ruler(
                    key: ValueKey(platform),
                    value: 1,
                    maxValue: 100,
                    onChanged: changes.add,
                  ),
                );
              },
            ),
          );

          await tester.fling(
            find.byType(ListView),
            const Offset(-400, 0),
            500,
          );

          await tester.pumpAndSettle();

          debugDefaultTargetPlatformOverride = null;

          expect(changes, isNotEmpty, reason: platform.toString());
        }
      },
    );

    testWidgets(
      'correctly works with overscroll at the start',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          Ruler(
            value: 1,
            maxValue: 100,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.timedDrag(
          find.byType(ListView),
          const Offset(300, 0),
          const Duration(milliseconds: 500),
        );

        await tester.pumpAndSettle();

        expect(wasCalled, isFalse);
      },
    );

    testWidgets(
      'correctly works with overscroll at the end',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          Ruler(
            value: 100,
            maxValue: 100,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.timedDrag(
          find.byType(ListView),
          const Offset(-300, 0),
          const Duration(milliseconds: 500),
        );

        await tester.pumpAndSettle();

        expect(wasCalled, isFalse);
      },
    );

    testWidgets(
      'calls TactileFeedback.impact() when new value is provided to the widget',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        await tester.pumpSubject(
          Ruler(
            value: 1,
            maxValue: 100,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        await tester.pumpSubject(
          Ruler(
            value: 2,
            maxValue: 100,
            onChanged: (value) {},
          ),
        );

        await tester.pumpAndSettle();

        expect(wasImpacted, isTrue);
      },
    );

    testWidgets(
      'calls TactileFeedback.impact() when new value is selected by drag',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        await tester.pumpSubject(
          Ruler(
            value: 1,
            maxValue: 100,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        await tester.dragNMarks(1);

        await tester.pumpAndSettle();

        expect(wasImpacted, isTrue);
      },
    );
  });
}

extension _Ruler on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: child),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dragNMarks(int n) async {
    final offset = (kGapWidth + kMarkWidth) * n;

    await timedDrag(
      find.byType(ListView),
      Offset(-offset, 0),
      const Duration(milliseconds: 1000),
    );
  }
}
