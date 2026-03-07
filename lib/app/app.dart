import 'package:flutter/material.dart';
import 'package:recell_bazar/features/splash/presentation/pages/splash_screen.dart';
import 'package:recell_bazar/app/theme/theme_data.dart';
import 'package:recell_bazar/app/theme/theme_mode_controller.dart';
import 'package:recell_bazar/sensors/light_sensor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _AppState? state = context.findAncestorStateOfType<_AppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // start the shared controller
    lightSensorController.startListening();
  }

  @override
  void dispose() {
    lightSensorController.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemePreference>(
      valueListenable: appThemeController.preference,
      builder: (context, pref, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: lightSensorController.isDarkMode,
          builder: (context, isDark, _) {
            final themeMode = switch (pref) {
              AppThemePreference.auto => isDark ? ThemeMode.dark : ThemeMode.light,
              AppThemePreference.dark => ThemeMode.dark,
              AppThemePreference.light => ThemeMode.light,
            };

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: getApplicationTheme(isDarkMode: false), // light
              darkTheme: getApplicationTheme(isDarkMode: true), // dark
              themeMode: themeMode,
              home: SplashScreen(),
              locale: _locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ne'),
              ],
            );
          },
        );
      },
    );
  }

  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }
}
