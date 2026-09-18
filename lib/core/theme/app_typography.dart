import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// CampusMesh Typography strictly mapped from DESIGN.md
class AppTypography {
  AppTypography._();

  // Primary Sans-Serif font (Inter)
  static TextStyle get headlineLg => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.64,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 32 / 26,
        letterSpacing: -0.26,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        letterSpacing: -0.22,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppColors.onSurfaceVariant,
      );

  // Technical Monospace font (JetBrains Mono) for badges, timestamps, codes
  static TextStyle get labelMd => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 18 / 13,
        letterSpacing: 0.26,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 14 / 11,
        letterSpacing: 0.44,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get codeBadge => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.secondary,
      );
}
