import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

class App extends StatefulWidget {
  const App({
    required this.data,
    super.key,
  });

  final AppData data;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final settingsListenable = Listenable.merge([
    widget.data.settingsController.locale,
    widget.data.settingsController.darkModeOn,
  ]);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsController>.value(
          value: widget.data.settingsController,
        ),
        Provider<ControlRepository>.value(
          value: widget.data.controlRepository,
        ),
        BlocProvider<ConnectionBloc>(
          lazy: false,
          create: (context) {
            return ConnectionBloc(
              connectionRepository: widget.data.connectionRepository,
              settingsController: widget.data.settingsController,
              initialConnectionData: widget.data.initialConnectionData,
            )..add(
                const ConnectionRequested(),
              );
          },
        ),
      ],
      child: ListenableBuilder(
        listenable: settingsListenable,
        builder: (context, _) {
          final locale = widget.data.settingsController.locale.value;
          final darkModeOn = widget.data.settingsController.darkModeOn.value;

          final themeMode = darkModeOn == null
              ? ThemeMode.system
              : (darkModeOn ? ThemeMode.dark : ThemeMode.system);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gyver Lamp',
            theme: GyverLampTheme.lightThemeData,
            darkTheme: GyverLampTheme.darkThemeData,
            themeMode: themeMode,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget.data.initialSetupCompleted
                ? const ControlPage()
                : const InitialSetupView(),
            builder: (context, child) {
              final theme = Theme.of(context);
              final colors = theme.extension<GyverLampAppTheme>()!;
              final brightness = theme.brightness;

              final overlayStyle = brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark;

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: overlayStyle.copyWith(
                  systemNavigationBarColor: colors.background,
                  systemNavigationBarIconBrightness:
                      brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark,
                ),
                child: AlertMessenger(child: child!),
              );
            },
          );
        },
      ),
    );
  }
}
