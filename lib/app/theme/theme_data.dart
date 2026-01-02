import 'package:flutter/material.dart';

<<<<<<< HEAD
class ThemeData extends StatefulWidget {
  const ThemeData({super.key});

  @override
  State<ThemeData> createState() => _ThemeDataState();
}

class _ThemeDataState extends State<ThemeData> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
=======
ThemeData getApplicationTheme() {

  return ThemeData(
    scaffoldBackgroundColor:Colors.white,
    fontFamily: 'Montserrat-Regular',
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0B7C7C)),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0B7C7C),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Montserrat-Bold',
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Montserrat-Regular',
      ),
    ),


    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: Colors.white,
    //   contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(6),
    //     borderSide: const BorderSide(color: Colors.grey),
    //   ),

    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(6),
    //     borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
    //   ),

    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(6),
    //     borderSide: const BorderSide(color: Colors.red),
    //   ),

    //   focusedErrorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(6),
    //     borderSide: const BorderSide(color: Colors.red, width: 2),
    //   ),

    //   labelStyle: const TextStyle(
    //     fontFamily: 'OpenSans-Regular',
    //     fontSize: 14,
    //     color: Colors.black87,
    //   ),

    //   hintStyle: const TextStyle(
    //     fontFamily: 'OpenSans-Regular',
    //     fontSize: 14,
    //     color: Colors.grey,
    //   ),
    // ),
  );
}
>>>>>>> 27078be15c22dd44fa668859f635beff0d9ac9a0
