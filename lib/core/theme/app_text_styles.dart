import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// GHARAR Typography
/// Playfair Display for elegant, poetic headings
/// Plus Jakarta Sans for crystal-clear, modern readability
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge({required bool isDark}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBurgundy,
        height: 1.2,
      );

  static TextStyle displayMedium({required bool isDark}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: isDark ? AppColors.darkTextPrimary : AppColors.deepBurgundy,
        height: 1.25,
      );

  static TextStyle displaySmall({required bool isDark}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        height: 1.3,
      );

  static TextStyle headline({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );

  static TextStyle titleMedium({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );

  static TextStyle bodyLarge({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        height: 1.5,
      );

  static TextStyle bodyMedium({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        height: 1.45,
      );

  static TextStyle bodySmall({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      );

  static TextStyle labelLarge({required bool isDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      );

  static TextStyle quote({required bool isDark}) => GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColors.darkTextSecondary : AppColors.burgundyRose,
    height: 1.4,
  );
}
