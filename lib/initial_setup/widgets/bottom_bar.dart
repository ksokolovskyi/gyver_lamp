import 'package:flutter/material.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class InitialSetupBottomBar extends StatelessWidget {
  const InitialSetupBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: const Padding(
          padding: EdgeInsets.only(
            left: GyverLampSpacings.xlgsm,
            right: GyverLampSpacings.xlgsm,
            top: GyverLampSpacings.sm,
            bottom: GyverLampSpacings.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: ConnectButton.large(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
