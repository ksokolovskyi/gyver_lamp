import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ControlView extends StatelessWidget {
  const ControlView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ControlBloc, ControlState>(
      listenWhen: (p, c) => p.isOn != c.isOn,
      listener: (context, state) {
        if (!state.isConnected) {
          return;
        }

        AlertMessenger.of(context).showInfo(
          message: state.isOn ? l10n.lampIsOn : l10n.lampIsOff,
        );
      },
      child: const Scaffold(
        appBar: ControlAppBar(),
        body: Center(
          child: Effect(),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(GyverLampSpacings.xlgsm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModePicker(),
              GyverLampGaps.xlg,
              ControlRulers(),
            ],
          ),
        ),
      ),
    );
  }
}
