import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_effects/gyver_lamp_effects.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

class _MockControlBloc extends MockBloc<ControlEvent, ControlState>
    implements ControlBloc {}

void main() {
  group('Effect', () {
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
        child: const Effect(),
      );
    }

    group('renders correctly when selected mode is', () {
      testWidgets('GyverLampMode.sparkles', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
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

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.sparkles));
      });

      testWidgets('GyverLampMode.fire', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.fire,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.fire));
      });

      testWidgets('GyverLampMode.rainbowVertical', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.rainbowVertical,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.verticalRainbow));
      });

      testWidgets('GyverLampMode.rainbowHorizontal', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.rainbowHorizontal,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.horizontalRainbow));
      });

      testWidgets('GyverLampMode.colors', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.colors,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.colors));
      });

      testWidgets('GyverLampMode.madness', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.madness,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.madness));
      });

      testWidgets('GyverLampMode.cloud', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.cloud,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.clouds));
      });

      testWidgets('GyverLampMode.lava', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.lava,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.lava));
      });

      testWidgets('GyverLampMode.plasma', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.plasma,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.plasma));
      });

      testWidgets('GyverLampMode.rainbow', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.rainbow,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.rainbow));
      });

      testWidgets('GyverLampMode.rainbowStripes', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.rainbowStripes,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.rainbowStripes));
      });

      testWidgets('GyverLampMode.zebra', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.zebra,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.zebra));
      });

      testWidgets('GyverLampMode.forest', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.forest,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.forest));
      });

      testWidgets('GyverLampMode.ocean', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.ocean,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.ocean));
      });

      testWidgets('GyverLampMode.color', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.color));
      });

      testWidgets('GyverLampMode.snow', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.snow,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.snow));
      });

      testWidgets('GyverLampMode.matrix', (tester) async {
        when(() => bloc.state).thenReturn(
          const ControlState(
            connectionData: null,
            isConnected: false,
            isOn: false,
            mode: GyverLampMode.matrix,
            brightness: 1,
            speed: 2,
            scale: 3,
          ),
        );

        await tester.pumpSubject(buildSubject());

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.matrix));
      });

      testWidgets('GyverLampMode.fireflies', (tester) async {
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

        final effect = tester.widget<GyverLampEffect>(
          find.byType(GyverLampEffect),
        );

        expect(effect.type, equals(GyverLampEffectType.fireflies));
      });
    });

    testWidgets('rebuilds when mode changes', (tester) async {
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

      var effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.type, equals(GyverLampEffectType.sparkles));

      statesController.add(
        bloc.state.copyWith(mode: GyverLampMode.fireflies),
      );
      await tester.pump();

      effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.type, equals(GyverLampEffectType.fireflies));
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

      var effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.speed, equals(2));

      statesController.add(
        bloc.state.copyWith(speed: 33),
      );
      await tester.pump();

      effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.speed, equals(33));
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

      var effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.scale, equals(3));

      statesController.add(
        bloc.state.copyWith(scale: 33),
      );
      await tester.pump();

      effect = tester.widget<GyverLampEffect>(
        find.byType(GyverLampEffect),
      );

      expect(effect.scale, equals(33));
    });
  });
}

extension _Effect on WidgetTester {
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
