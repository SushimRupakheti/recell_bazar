import 'package:flutter/material.dart';
import 'package:recell_bazar/features/splash/presentation/pages/splash_screen.dart';
import 'package:recell_bazar/app/theme/theme_data.dart';
import 'package:recell_bazar/sensors/light_sensor.dart';

class App extends StatefulWidget {
  const App({super.key});

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
    return ValueListenableBuilder<bool>(
      valueListenable: lightSensorController.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getApplicationTheme(isDarkMode: false), // light
          darkTheme: getApplicationTheme(isDarkMode: true), // dark
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
        );
      },
    );
  }
}