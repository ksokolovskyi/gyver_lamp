import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/splash/splash.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({
    required this.dataLoader,
    super.key,
  });

  final Future<AppData> Function() dataLoader;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  AppData? _data;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    widget.dataLoader().then((data) {
      Future.delayed(
        SplashPage.kFadeDuration + SplashPage.kAnimationDuration,
        () {
          if (mounted) {
            setState(() => _data = data);
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    if (data == null) {
      return const SplashPage();
    }

    return App(data: data);
  }
}
