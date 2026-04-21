import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kSecondaryColor,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    cardTheme: CardThemeData(
      color: const Color.fromARGB(255, 233, 233, 230),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 146, 77, 53),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.brown,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
