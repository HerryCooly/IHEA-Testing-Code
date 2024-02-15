import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _colorIHABlue = Color.fromARGB(255, 0, 90, 162); // Primary
const _colorIHABlue2 = Color.fromARGB(255, 27, 79, 134); // Primary Dark
const _colorIHAYellow1 = Color.fromARGB(255, 239, 192, 65); // Use for buttons
const _colorIHAYellow2 = Color.fromARGB(255, 236, 170, 56);
const _colorIHAYellow3 = Color.fromARGB(255, 230, 132, 40);

const _colorTextWhite = Colors.white;

/// https://m3.material.io/components
/// Please use the material3 guidelines if possible - Dylan

/// THEME CUSTOMIZATION HERE
// TODO Finish all styles
class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      useMaterial3: true,
      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        // IH blue is roughly I am guessing:
        seedColor: _colorIHABlue,
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 30,
          fontStyle: FontStyle.normal,
        ),
        bodyMedium: GoogleFonts.roboto(),
        displaySmall: GoogleFonts.robotoCondensed(),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        iconSize: 24,
        elevation: 6,
        hoverElevation: 8,
        focusElevation: 8,
        highlightElevation: 8,
        backgroundColor: _colorIHABlue2,
        hoverColor: _colorIHABlue,
        focusColor: _colorIHABlue,
        foregroundColor: _colorTextWhite,
      ),

      cardTheme: const CardTheme(elevation: 1),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _colorIHABlue, // This is a custom color variable
        ),
      ),

    );
  }
}
