import 'package:flutter/material.dart';
import 'package:gallery/effect.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GyverLampTheme.lightThemeData,
      home: const Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Effect(),
          ),
        ),
      ),
    );
  }
}
