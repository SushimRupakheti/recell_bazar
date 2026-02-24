import 'package:flutter/material.dart';

ThemeData getApplicationTheme({required bool isDarkMode}) {
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
      unselectedItemColor: isDarkMode ? Colors.grey[500] : Colors.grey,
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

    // Text (use modern names)
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      bodyMedium: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.black87),
      titleLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontFamily: 'Montserrat-Bold'),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDarkMode ? const Color(0xFF0E1314) : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
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