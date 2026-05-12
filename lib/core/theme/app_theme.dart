import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ===================== DARK THEME COLORS =====================
  static const Color backgroundDeep = Color(0xFF0A0E14);
  static const Color backgroundSurface = Color(0xFF111820);
  static const Color backgroundCard = Color(0xFF151D28);
  static const Color accentNeon = Color(0xFFE8FF47);
  static const Color accentElectric = Color(0xFF00E5CC);
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8BA3B9);
  static const Color textMuted = Color(0xFF5A6E82);
  static const Color borderSubtle = Color(0xFF1E2A38);
  static const Color borderActive = Color(0xFF2A3D50);
  static const Color gridLine = Color(0xFF0F1820);
  static const Color warning = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF6B6B);

  // ===================== LIGHT THEME COLORS =====================
  static const Color lightBackgroundDeep = Color(0xFFF8F9FB);
  static const Color lightBackgroundSurface = Color(0xFFFFFFFF);
  static const Color lightBackgroundCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1E2A);
  static const Color lightTextSecondary = Color(0xFF5A6A7A);
  static const Color lightTextMuted = Color(0xFF9AA5B1);
  static const Color lightBorderSubtle = Color(0xFFE2E8F0);
  static const Color lightBorderActive = Color(0xFFCBD5E0);
  static const Color lightGridLine = Color(0xFFF1F4F8);

  // ===================== DARK THEME =====================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDeep,
    primaryColor: accentNeon,
    colorScheme: ColorScheme.dark(
      primary: accentNeon,
      secondary: accentElectric,
      surface: backgroundCard,
      onSurface: textPrimary,
      error: error,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDeep,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        color: accentNeon,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
      iconTheme: IconThemeData(color: accentNeon),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: accentNeon,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentNeon,
      labelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 13),
      unselectedLabelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w500, fontSize: 13),
      dividerColor: borderSubtle,
    ),
    cardTheme: CardThemeData(
      color: backgroundCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: borderSubtle, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundSurface,
      labelStyle: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 13),
      hintStyle: GoogleFonts.spaceGrotesk(color: textMuted, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: borderSubtle, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: accentNeon, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentNeon.withValues(alpha: 0.12);
          return backgroundSurface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentNeon;
          return textSecondary;
        }),
        side: WidgetStateProperty.all(BorderSide(color: borderSubtle, width: 1)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      ),
    ),
  );

  // ===================== LIGHT THEME =====================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackgroundDeep,
    primaryColor: accentNeon,
    colorScheme: ColorScheme.light(
      primary: accentNeon,
      secondary: accentElectric,
      surface: lightBackgroundCard,
      onSurface: lightTextPrimary,
      error: error,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
      bodyColor: lightTextPrimary,
      displayColor: lightTextPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        color: lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
      iconTheme: IconThemeData(color: lightTextPrimary),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: accentNeon,
      unselectedLabelColor: lightTextSecondary,
      indicatorColor: accentNeon,
      labelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 13),
      unselectedLabelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w500, fontSize: 13),
      dividerColor: lightBorderSubtle,
    ),
    cardTheme: CardThemeData(
      color: lightBackgroundCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: lightBorderSubtle, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBackgroundSurface,
      labelStyle: GoogleFonts.spaceGrotesk(color: lightTextSecondary, fontSize: 13),
      hintStyle: GoogleFonts.spaceGrotesk(color: lightTextMuted, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: lightBorderSubtle, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: accentNeon, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentNeon.withValues(alpha: 0.12);
          return lightBackgroundSurface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accentNeon;
          return lightTextSecondary;
        }),
        side: WidgetStateProperty.all(BorderSide(color: lightBorderSubtle, width: 1)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      ),
    ),
  );

  // ===================== TEXT STYLES =====================
  static TextStyle technicalValue = GoogleFonts.jetBrainsMono(
    fontSize: 38,
    fontWeight: FontWeight.w600,
    color: accentNeon,
    letterSpacing: 2,
  );

  static TextStyle labelStyle = GoogleFonts.spaceGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textMuted,
    letterSpacing: 1.5,
  );

  static TextStyle valueUnitStyle = GoogleFonts.spaceGrotesk(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: accentElectric,
  );
}