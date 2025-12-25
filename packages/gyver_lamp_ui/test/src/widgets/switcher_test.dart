import 'dart:ui';

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
  group('Switcher', () {
    late TactileFeedbackPlatform tactileFeedbackPlatform;

    setUp(() {
      tactileFeedbackPlatform = _MockTactileFeedbackPlatform();

      when(tactileFeedbackPlatform.impact).thenAnswer((_) async {});

      TactileFeedbackPlatform.instance = tactileFeedbackPlatform;
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        Switcher(
          value: true,
          onChanged: (value) {},
        ),
      );

      final state = tester.state<SwitcherState>(find.byType(Switcher));

      expect(find.byType(Switcher), findsOneWidget);
      expect(state.value, isTrue);
    });

    testWidgets('calls onChanged when toggled on by drag', (tester) async {
      var isToggled = false;

      await tester.pumpSubject(
        StatefulBuilder(
          builder: (context, setState) {
            return Switcher(
              value: isToggled,
              onChanged: (value) {
                setState(
                  () => isToggled = value,
                );
              },
            );
          },
        ),
      );

      await tester.dragSwitcherForward();
      await tester.pumpAndSettle();

      expect(isToggled, isTrue);
    });

    testWidgets('calls onChanged when toggled off by drag', (tester) async {
      var isToggled = true;

      await tester.pumpSubject(
        StatefulBuilder(
          builder: (context, setState) {
            return Switcher(
              value: isToggled,
              onChanged: (value) {
                setState(
                  () => isToggled = value,
                );
              },
            );
          },
        ),
      );

      await tester.dragSwitcherBackward();
      await tester.pumpAndSettle();

      expect(isToggled, isFalse);
    });

    testWidgets(
      'calls onChanged when toggled on by drag and directionality is rtl',
      (tester) async {
        var isToggled = false;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.rtl,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Switcher(
                  value: isToggled,
                  onChanged: (value) {
                    setState(
                      () => isToggled = value,
                    );
                  },
                );
              },
            ),
          ),
        );

        await tester.dragSwitcherForward(textDirection: TextDirection.rtl);
        await tester.pumpAndSettle();

        expect(isToggled, isTrue);
      },
    );

    testWidgets(
      'calls onChanged when toggled off by drag and directionality is rtl',
      (tester) async {
        var isToggled = true;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.rtl,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Switcher(
                  value: isToggled,
                  onChanged: (value) {
                    setState(
                      () => isToggled = value,
                    );
                  },
                );
              },
            ),
          ),
        );

        await tester.dragSwitcherBackward(textDirection: TextDirection.rtl);
        await tester.pumpAndSettle();

        expect(isToggled, isFalse);
      },
    );

    testWidgets('calls onChanged when toggled on by tap', (tester) async {
      var isToggled = false;

      await tester.pumpSubject(
        StatefulBuilder(
          builder: (context, setState) {
            return Switcher(
              value: isToggled,
              onChanged: (value) {
                setState(
                  () => isToggled = value,
                );
              },
            );
          },
        ),
      );

      await tester.tap(find.byType(Switcher));
      await tester.pumpAndSettle();

      expect(isToggled, isTrue);
    });

    testWidgets('calls onChanged when toggled off by tap', (tester) async {
      var isToggled = true;

      await tester.pumpSubject(
        StatefulBuilder(
          builder: (context, setState) {
            return Switcher(
              value: isToggled,
              onChanged: (value) {
                setState(
                  () => isToggled = value,
                );
              },
            );
          },
        ),
      );

      await tester.tap(find.byType(Switcher));
      await tester.pumpAndSettle();

      expect(isToggled, isFalse);
    });

    testWidgets(
      'does not call onChanged when dragged slightly by mouse',
      (tester) async {
        var isToggled = false;

        await tester.pumpSubject(
          StatefulBuilder(
            builder: (context, setState) {
              return Switcher(
                value: isToggled,
                onChanged: (value) {
                  setState(
                    () => isToggled = value,
                  );
                },
              );
            },
          ),
        );

        await tester.dragSwitcherForwardSlightlyByMouse();
        await tester.pumpAndSettle();

        expect(isToggled, isFalse);
      },
    );

    testWidgets(
      'does not call onChanged after widget value update',
      (tester) async {
        var wasToggled = false;

        await tester.pumpSubject(
          Switcher(
            value: true,
            onChanged: (value) => wasToggled = true,
          ),
        );

        final state = tester.state<SwitcherState>(find.byType(Switcher));

        expect(state.value, isTrue);

        await tester.pumpSubject(
          Switcher(
            value: false,
            onChanged: (value) => wasToggled = true,
          ),
        );

        expect(state.value, isFalse);
        expect(wasToggled, isFalse);
      },
    );

    testWidgets('animates after widget value update', (tester) async {
      await tester.pumpSubject(
        Switcher(
          value: true,
          onChanged: (value) {},
        ),
      );

      await tester.pump();

      final state = tester.state<SwitcherState>(find.byType(Switcher));

      expect(state.value, isTrue);
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpSubject(
        Switcher(
          value: false,
          onChanged: (value) {},
        ),
      );

      expect(state.value, isFalse);
      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets(
      'animates back when update value is not passed into the widget',
      (tester) async {
        var wasToggled = false;

        await tester.pumpSubject(
          Switcher(
            value: false,
            onChanged: (value) {
              wasToggled = true;
            },
          ),
        );

        await tester.pump();

        final state = tester.state<SwitcherState>(find.byType(Switcher));

        expect(state.value, isFalse);
        expect(tester.binding.hasScheduledFrame, isFalse);

        await tester.tap(find.byType(Switcher));

        expect(wasToggled, isTrue);
        expect(state.value, isFalse);

        expect(tester.binding.hasScheduledFrame, isTrue);

        await tester.pumpAndSettle();

        expect(tester.binding.hasScheduledFrame, isFalse);
      },
    );

    testWidgets('animates thumb on press', (tester) async {
      await tester.pumpSubject(
        Switcher(
          value: false,
          onChanged: (value) {},
        ),
      );

      await tester.pumpAndSettle();

      final finder = find.byType(Switcher);

      final width = tester.getSize(finder).width;
      final offset = -width / 2 + width / 4;
      final left = tester.getCenter(finder).translate(offset, 0);

      final state = tester.state<SwitcherState>(finder);

      await TestAsyncUtils.guard<void>(() async {
        final gesture = await tester.startGesture(left);

        await tester.pumpAndSettle();

        expect(state.reactionController.isCompleted, isTrue);

        await gesture.up();

        await tester.pumpAndSettle();

        expect(state.reactionController.isDismissed, isTrue);
      });
    });

    testWidgets(
      'calls TactileFeedback.impact() when toggled on by drag',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        var isToggled = false;

        await tester.pumpSubject(
          StatefulBuilder(
            builder: (context, setState) {
              return Switcher(
                value: isToggled,
                onChanged: (value) {
                  setState(
                    () => isToggled = value,
                  );
                },
              );
            },
          ),
        );

        await tester.dragSwitcherForward();
        await tester.pumpAndSettle();

        expect(isToggled, isTrue);
        expect(wasImpacted, isTrue);
      },
    );

    testWidgets(
      'calls TactileFeedback.impact() when toggled on by tap',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        var isToggled = false;

        await tester.pumpSubject(
          StatefulBuilder(
            builder: (context, setState) {
              return Switcher(
                value: isToggled,
                onChanged: (value) {
                  setState(
                    () => isToggled = value,
                  );
                },
              );
            },
          ),
        );

        await tester.tap(find.byType(Switcher));
        await tester.pumpAndSettle();

        expect(isToggled, isTrue);
        expect(wasImpacted, isTrue);
      },
    );
  });
}

extension _Switcher on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> dragSwitcherForwardSlightlyByMouse() async {
    final finder = find.byType(Switcher);

    final width = getSize(finder).width;
    final offset = -width / 2 + width / 6;
    final left = getCenter(finder).translate(offset, 0);

    return dragFrom(
      left,
      Offset(width / 4, 0),
      kind: PointerDeviceKind.mouse,
    );
  }

  Future<void> dragSwitcherForward({
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    if (textDirection != TextDirection.ltr) {
      return dragSwitcherBackward();
    }

    final finder = find.byType(Switcher);

    final width = getSize(finder).width;
    final offset = -width / 2 + width / 6;
    final left = getCenter(finder).translate(offset, 0);

    return dragFrom(left, Offset(width, 0));
  }

  Future<void> dragSwitcherBackward({
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    if (textDirection != TextDirection.ltr) {
      return dragSwitcherForward();
    }

    final finder = find.byType(Switcher);

    final width = getSize(finder).width;
    final offset = width / 2 - width / 6;
    final right = getCenter(finder).translate(offset, 0);

    return dragFrom(right, Offset(-width, 0));
  }
}
