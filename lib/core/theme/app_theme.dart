import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundDeep = Color(0xFF0D0D1A);
  static const Color backgroundCard = Color(0xFF13132B);
  static const Color accentCyan = Color(0xFF00F0FF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDeep,
    primaryColor: accentCyan,
    colorScheme: ColorScheme.dark(
      primary: accentCyan,
      surface: backgroundCard,
      onSurface: textPrimary,
    ),
    textTheme: GoogleFonts.robotoTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDeep,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.robotoMono(
        color: accentCyan,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: accentCyan,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentCyan,
    ),
  );

  static TextStyle technicalValue = GoogleFonts.robotoMono(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: accentCyan,
  );
}
