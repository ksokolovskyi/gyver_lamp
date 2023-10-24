import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockControlBloc extends MockBloc<ControlEvent, ControlState>
    implements ControlBloc {}

void main() {
  group('ControlRulers', () {
    late ControlBloc bloc;

    setUp(() {
      bloc = _MockControlBloc();
      when(() => bloc.state).thenReturn(
        ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider<ControlBloc>.value(
        value: bloc,
        child: const ControlRulers(),
      );
    }

    testWidgets('renders correctly', (tester) async {
      when(() => bloc.state).thenReturn(
        const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.fireflies,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      expect(find.byType(ControlRulers), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.sun), findsOneWidget);
      expect(find.text(tester.l10n.brightness), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.speed), findsOneWidget);
      expect(find.text(tester.l10n.speed), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.scale), findsOneWidget);
      expect(find.text(tester.l10n.scale), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byType(Ruler), findsNWidgets(3));
    });

    testWidgets('rebuilds when brightness changes', (tester) async {
      final statesController = StreamController<ControlState>();
      addTearDown(statesController.close);

      whenListen(
        bloc,
        statesController.stream,
        initialState: const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.sparkles,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      expect(find.text('1'), findsOneWidget);

      statesController.add(
        bloc.state.copyWith(brightness: 33),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNothing);
      expect(find.text('33'), findsOneWidget);
    });

    testWidgets('rebuilds when speed changes', (tester) async {
      final statesController = StreamController<ControlState>();
      addTearDown(statesController.close);

      whenListen(
        bloc,
        statesController.stream,
        initialState: const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.sparkles,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      expect(find.text('2'), findsOneWidget);

      statesController.add(
        bloc.state.copyWith(speed: 33),
      );
      await tester.pumpAndSettle();

      expect(find.text('2'), findsNothing);
      expect(find.text('33'), findsOneWidget);
    });

    testWidgets('rebuilds when scale changes', (tester) async {
      final statesController = StreamController<ControlState>();
      addTearDown(statesController.close);

      whenListen(
        bloc,
        statesController.stream,
        initialState: const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.sparkles,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      expect(find.text('3'), findsOneWidget);

      statesController.add(
        bloc.state.copyWith(scale: 33),
      );
      await tester.pumpAndSettle();

      expect(find.text('3'), findsNothing);
      expect(find.text('33'), findsOneWidget);
    });

    testWidgets(
      'adds event to bloc when brightness is changed',
      (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.fireflies,
            brightness: 33,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        await tester.timedDrag(
          find.widgetWithText(Ruler, '33'),
          const Offset(-(kGapWidth + kMarkWidth), 0),
          const Duration(milliseconds: 250),
        );
        await tester.pump();

        verify(
          () => bloc.add(const BrightnessUpdated(brightness: 34)),
        ).called(1);
      },
    );

    testWidgets('adds event to bloc when speed is changed', (tester) async {
      when(() => bloc.state).thenReturn(
        const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.fireflies,
          brightness: 1,
          speed: 33,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      await tester.timedDrag(
        find.widgetWithText(Ruler, '33'),
        const Offset(-(kGapWidth + kMarkWidth), 0),
        const Duration(milliseconds: 250),
      );
      await tester.pump();

      verify(
        () => bloc.add(const SpeedUpdated(speed: 34)),
      ).called(1);
    });

    testWidgets('adds event to bloc when scale is changed', (tester) async {
      when(() => bloc.state).thenReturn(
        const ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.fireflies,
          brightness: 1,
          speed: 2,
          scale: 33,
        ),
      );

      await tester.pumpSubject(buildSubject());

      await tester.timedDrag(
        find.widgetWithText(Ruler, '33'),
        const Offset(-(kGapWidth + kMarkWidth), 0),
        const Duration(milliseconds: 250),
      );
      await tester.pump();

      verify(
        () => bloc.add(const ScaleUpdated(scale: 34)),
      ).called(1);
    });
  });
}

extension _ControlRulers on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Center(
            child: subject,
          ),
        ),
      ),
    );
  }
}
