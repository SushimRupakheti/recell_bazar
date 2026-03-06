import 'package:flutter/material.dart';

ThemeData getApplicationTheme({required bool isDarkMode}) {
  final baseTextTheme =
      isDarkMode ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

  return ThemeData(
    scaffoldBackgroundColor: isDarkMode ? const Color(0xFF0A0F12) : Colors.white,
    fontFamily: 'Montserrat-Regular',
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    colorScheme: isDarkMode
        ? const ColorScheme.dark(
            primary: Color(0xFF26A69A),
            secondary: Color(0xFF80CBC4),
            background: Color(0xFF0A0F12),
            surface: Color(0xFF111416),
            onPrimary: Colors.black,
            onBackground: Colors.white,
            onSurface: Colors.white,
          )
        : ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B7C7C),
            brightness: Brightness.light,
          ),

    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkMode ? Colors.transparent : null,
      elevation: isDarkMode ? 0 : 4,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontFamily: 'Montserrat-Bold',
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
    ),

    // Bottom navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? const Color(0xFF0E1314) : Colors.white,
      selectedItemColor: isDarkMode ? const Color(0xFF26A69A) : const Color(0xFF0B7C7C),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat-Bold',
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Montserrat-Regular',
      ),
    ),

    // Cards, surfaces
    cardColor: isDarkMode ? const Color(0xFF111416) : Colors.white,

    // Text
    // Use a complete base TextTheme so styles like titleMedium/labelLarge
    // don't fall back to low-contrast defaults in dark mode.
    textTheme: baseTextTheme
        .apply(
          bodyColor: isDarkMode ? Colors.white : Colors.black,
          displayColor: isDarkMode ? Colors.white : Colors.black,
          fontFamily: 'Montserrat-Regular',
        )
        .copyWith(
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: isDarkMode ? Colors.white.withOpacity(0.86) : Colors.black87,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w800,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Montserrat-Bold',
            fontWeight: FontWeight.w700,
          ),
        ),

    // Inputs
    inputDecorationTheme: isDarkMode
        ? InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF111416),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.white12,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF26A69A),
                width: 1.4,
              ),
            ),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.65)),
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.80)),
          )
        : InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF26A69A) : const Color(0xFF0B7C7C),
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Icons & dividers
    iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
    dividerColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],

    // Dialogs / Snackbars
    dialogBackgroundColor: isDarkMode ? const Color(0xFF0E1314) : null,
    snackBarTheme: SnackBarThemeData(backgroundColor: isDarkMode ? const Color(0xFF1A1F1F) : null),
  );
}