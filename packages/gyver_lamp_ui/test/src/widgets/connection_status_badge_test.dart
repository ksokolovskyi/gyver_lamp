import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  String label(ConnectionStatus status) => switch (status) {
    (ConnectionStatus.connected) => 'Connected',
    (ConnectionStatus.connecting) => 'Connecting',
    (ConnectionStatus.notConnected) => 'Not Connected',
  };

  group('ConnectionStatusBadge', () {
    testWidgets('renders correctly for connected status', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.connected,
          label: label,
          onPressed: () {},
        ),
      );

      expect(
        find.byType(ConnectionStatusBadge),
        findsOneWidget,
      );
      expect(
        find.text(label(ConnectionStatus.connected)),
        findsOneWidget,
      );
    });

    testWidgets('renders correctly for connecting status', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.connecting,
          label: label,
          onPressed: () {},
        ),
      );

      expect(
        find.byType(ConnectionStatusBadge),
        findsOneWidget,
      );
      expect(
        find.text(label(ConnectionStatus.connecting)),
        findsOneWidget,
      );
    });

    testWidgets('renders correctly for notConnected status', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: () {},
        ),
      );

      expect(
        find.byType(ConnectionStatusBadge),
        findsOneWidget,
      );
      expect(
        find.text(label(ConnectionStatus.notConnected)),
        findsOneWidget,
      );
    });

    testWidgets('animates on status change', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: () {},
        ),
      );

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(
        find.text(label(ConnectionStatus.notConnected)),
        findsOneWidget,
      );

      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.connected,
          label: label,
          onPressed: () {},
        ),
      );

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(
        find.text(label(ConnectionStatus.connected)),
        findsOneWidget,
      );
    });

    testWidgets('calls onPressed after tap', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(ConnectionStatusBadge));

      expect(wasTapped, isTrue);
    });

    testWidgets('cancels tap on drag', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: () => wasTapped = true,
        ),
      );

      final state = tester.state<ConnectionStatusBadgeState>(
        find.byType(ConnectionStatusBadge),
      );

      await tester.drag(
        find.byType(ConnectionStatusBadge),
        const Offset(0, 200),
      );

      expect(wasTapped, isFalse);
      expect(state.isPressed, isFalse);
    });

    testWidgets('animates tap when enabled', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: () {},
        ),
      );

      await tester.pump();

      final state = tester.state<ConnectionStatusBadgeState>(
        find.byType(ConnectionStatusBadge),
      );

      final gesture = await tester.press(
        find.byType(ConnectionStatusBadge),
      );

      expect(tester.binding.hasScheduledFrame, isTrue);
      expect(state.isPressed, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(state.isPressed, isFalse);
    });

    testWidgets('does not animate tap when disabled', (tester) async {
      await tester.pumpSubject(
        ConnectionStatusBadge(
          status: ConnectionStatus.notConnected,
          label: label,
          onPressed: null,
        ),
      );

      await tester.pump();

      final state = tester.state<ConnectionStatusBadgeState>(
        find.byType(ConnectionStatusBadge),
      );

      await tester.press(
        find.byType(ConnectionStatusBadge),
      );
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(state.isPressed, isFalse);
    });
  });
}

extension _ConnectionStatusBadge on WidgetTester {
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
}
