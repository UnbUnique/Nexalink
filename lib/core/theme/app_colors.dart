import 'package:flutter/material.dart';

/// CampusMesh Color System derived strictly from DESIGN.md
class AppColors {
  AppColors._();

  // Surface & Canvas
  static const Color surface = Color(0xFF111317);
  static const Color surfaceDim = Color(0xFF111317);
  static const Color surfaceBright = Color(0xFF37393D);
  static const Color surfaceContainerLowest = Color(0xFF0C0E11);
  static const Color surfaceContainerLow = Color(0xFF1A1C1F);
  static const Color surfaceContainer = Color(0xFF1E2023);
  static const Color surfaceContainerHigh = Color(0xFF282A2D);
  static const Color surfaceContainerHighest = Color(0xFF333538);

  // Text & On-Surface
  static const Color onSurface = Color(0xFFE2E2E6);
  static const Color onSurfaceVariant = Color(0xFFCBC3D7);
  static const Color inverseSurface = Color(0xFFE2E2E6);
  static const Color inverseOnSurface = Color(0xFF2F3034);

  // Outlines & Borders
  static const Color outline = Color(0xFF958EA0);
  static const Color outlineVariant = Color(0xFF494454);
  static const Color ghostBorder = Color(0x1FFFFFFF); // 12% white subtle border
  static const Color faintBorder = Color(0x14FFFFFF); // 8% white subtle border

  // Primary Accent (Vibrant Electric Purple)
  static const Color primary = Color(0xFFD0BCFF);
  static const Color onPrimary = Color(0xFF3C0091);
  static const Color primaryContainer = Color(0xFFA078FF);
  static const Color onPrimaryContainer = Color(0xFF340080);
  static const Color inversePrimary = Color(0xFF6D3BD7);
  static const Color primaryFixed = Color(0xFFE9DDFF);
  static const Color primaryFixedDim = Color(0xFFD0BCFF);
  static const Color onPrimaryFixed = Color(0xFF23005C);

  // Secondary Accent (Neon Teal / Cyan)
  static const Color secondary = Color(0xFF4CD7F6);
  static const Color onSecondary = Color(0xFF003640);
  static const Color secondaryContainer = Color(0xFF03B5D3);
  static const Color onSecondaryContainer = Color(0xFF00424E);
  static const Color secondaryFixed = Color(0xFFACEDFF);
  static const Color secondaryFixedDim = Color(0xFF4CD7F6);
  static const Color onSecondaryFixed = Color(0xFF001F26);

  // Tertiary
  static const Color tertiary = Color(0xFFC4C6D0);
  static const Color onTertiary = Color(0xFF2D3038);
  static const Color tertiaryContainer = Color(0xFF8E909A);
  static const Color onTertiaryContainer = Color(0xFF272A31);

  // Error & Emergency Alerts
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  static const Color emergencyVibrant = Color(0xFFDC2626);

  // Priority warning
  static const Color warning = Color(0xFFFACC15);
  static const Color onWarning = Color(0xFF422006);

  // Ambient Glows
  static const Color purpleGlow = Color(0x33A078FF);
  static const Color tealGlow = Color(0x334CD7F6);
}
