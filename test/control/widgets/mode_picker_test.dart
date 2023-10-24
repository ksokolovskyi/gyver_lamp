import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockControlBloc extends MockBloc<ControlEvent, ControlState>
    implements ControlBloc {}

void main() {
  group('ModePicker', () {
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
        child: const ModePicker(),
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.sparklesMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.fireMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.rainbowVerticalMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.rainbowHorizontalMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.colorsMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.madnessMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.cloudsMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.lavaMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.plasmaMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.rainbowMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.rainbowStripesMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.zebraMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.forestMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.oceanMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.colorMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.snowMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.matrixMode), findsOneWidget);
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

        expect(find.byType(ModePicker), findsOneWidget);
        expect(find.text(tester.l10n.firefliesMode), findsOneWidget);
      });
    });

    testWidgets('rebuilds when state changes', (tester) async {
      final statesController = StreamController<ControlState>();
      addTearDown(statesController.close);

      whenListen(
        bloc,
        statesController.stream,
        initialState: ControlState(
          connectionData: null,
          isConnected: false,
          isOn: false,
          mode: GyverLampMode.values.first,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );

      await tester.pumpSubject(buildSubject());

      var dropdown = tester.widget<CustomDropdownButton<GyverLampMode>>(
        find.byType(CustomDropdownButton<GyverLampMode>),
      );

      expect(dropdown.selected, equals(GyverLampMode.values.first));

      statesController.add(
        ControlState(
          connectionData: null,
          isConnected: false,
          isOn: true,
          mode: GyverLampMode.values.last,
          brightness: 1,
          speed: 2,
          scale: 3,
        ),
      );
      await tester.pump();

      dropdown = tester.widget<CustomDropdownButton<GyverLampMode>>(
        find.byType(CustomDropdownButton<GyverLampMode>),
      );

      expect(dropdown.selected, equals(GyverLampMode.values.last));
    });

    testWidgets('adds event to bloc when new mode is selected', (tester) async {
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

      await tester.tap(find.byType(ModePicker));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(tester.l10n.firefliesMode),
        50,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(tester.l10n.firefliesMode));
      await tester.tap(find.text(tester.l10n.firefliesMode));
      await tester.pump();

      verify(
        () => bloc.add(
          const ModeUpdated(mode: GyverLampMode.fireflies),
        ),
      ).called(1);
    });
  });
}

extension _ModePicker on WidgetTester {
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
