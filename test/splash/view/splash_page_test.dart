import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/splash/splash.dart';
import 'package:rive/rive.dart';

void main() {
  group('SplashPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(const SplashPage());

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(RiveAnimation), findsOneWidget);
    });

    testWidgets('fades in correctly', (tester) async {
      await tester.pumpWidget(const SplashPage());

      await tester.pump();

      expect(tester.hasRunningAnimations, isTrue);

      await tester.pump(SplashPage.kFadeDuration);

      final fade = tester.widget<FadeTransition>(
        find.byType(FadeTransition),
      );

      expect(fade.opacity.value, equals(1));
    });

    testWidgets('runs rive animation after fade', (tester) async {
      await tester.pumpWidget(const SplashPage());

      await tester.pump();

      final splash = tester.state<SplashPageState>(
        find.byType(SplashPage),
      );

      splash.debugAnimationController!.value = 1;

      await tester.pump();

      expect(tester.hasRunningAnimations, isTrue);

      await tester.pump(SplashPage.kAnimationDuration);

      await tester.pump();

      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
