import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppConstants.background,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.spotifyGreen,
        secondary: AppConstants.accent,
        surface: AppConstants.surface,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            titleLarge: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
            titleMedium: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
            bodyLarge: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppConstants.textPrimary,
            ),
            bodyMedium: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppConstants.textSecondary,
            ),
          ),
      cardTheme: const CardThemeData(
        color: AppConstants.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppConstants.spotifyGreen,
        inactiveTrackColor: Colors.white12,
        thumbColor: AppConstants.textPrimary,
        overlayColor: AppConstants.spotifyGreen.withValues(alpha: 0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
    );
  }
}
