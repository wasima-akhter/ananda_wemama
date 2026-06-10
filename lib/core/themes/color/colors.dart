import 'package:flutter/material.dart';

import 'color_model.dart';

/// =======================
/// LIGHT THEME COLORS
/// =======================
final lightColors = ColorModel(
  // Foreground / Text
  foregroundPrimary: AppPalette.brown950,
  foregroundSecondary: AppPalette.brown925,

  // Backgrounds
  backgroundPrimary: AppPalette.cream100,
  backgroundSecondary: AppPalette.cream200,

  // Borders / strokes
  strokePrimary: AppPalette.brown850,
  strokeSecondary: AppPalette.brown650,

  // Accents
  accentBackground: AppPalette.rose50,
  accentForeground: AppPalette.brown650,

  // Misc
  disabled: AppPalette.cream75,
  overlay: AppPalette.brown900_10,

  // Brand colors
  primary: AppPalette.brown900,
  secondary: AppPalette.brown700,

  // Navigation
  navItemSelected: AppPalette.brown900,
  navItemUnselected: AppPalette.brown650,

  // Text
  textPrimary: AppPalette.brown900,
  textSecondary: AppPalette.brown700,
  textOnPrimary: AppPalette.cream100,

  // Buttons
  buttonPrimary: AppPalette.brown900,
  buttonText: AppPalette.cream100,

  // Input fields
  inputBackground: AppPalette.cream200,
  inputBorder: AppPalette.brown700,

  // Components
  componentBorder: AppPalette.brown700,
  componentFill: AppPalette.brown700,

  // Scaffold / Bottom sheet
  scaffoldBackground: AppPalette.cream50,
  bottomSheetBackground: AppPalette.rose200,

  // Cards
  cardPrimary: AppPalette.rose100,
  cardOngoing: AppPalette.rose200,
  cardReminder: AppPalette.cream200,
  cardMood: AppPalette.cream100,

  // Mood card internal
  moodGistBackground: AppPalette.cream75,
  moodTagBackground: AppPalette.cream75,

  // Status
  warning: AppPalette.warning,
  error: AppPalette.error,
  success: AppPalette.success,
);

/// =======================
/// DARK THEME COLORS
/// =======================
final darkColors = ColorModel(
  // Foreground / Text
  foregroundPrimary: AppPalette.cream100,
  foregroundSecondary: AppPalette.cream75,

  // Backgrounds
  backgroundPrimary: AppPalette.brown950,
  backgroundSecondary: AppPalette.brown925,

  // Borders / strokes
  strokePrimary: AppPalette.brown700,
  strokeSecondary: AppPalette.brown650,

  // Accents
  accentBackground: AppPalette.brown850,
  accentForeground: AppPalette.cream100,

  // Misc
  disabled: AppPalette.brown900_10,
  overlay: Colors.black26, // overlay can stay as semi-transparent black
  // Brand colors
  primary: AppPalette.brown900,
  secondary: AppPalette.brown700,

  // Navigation
  navItemSelected: AppPalette.brown900,
  navItemUnselected: AppPalette.brown650,

  // Text
  textPrimary: AppPalette.cream100,
  textSecondary: AppPalette.cream75,
  textOnPrimary: AppPalette.cream100,

  // Buttons
  buttonPrimary: AppPalette.brown900,
  buttonText: AppPalette.cream100,

  // Input fields
  inputBackground: AppPalette.brown925,
  inputBorder: AppPalette.brown700,

  // Components
  componentBorder: AppPalette.brown700,
  componentFill: AppPalette.brown925,

  // Scaffold / Bottom sheet
  scaffoldBackground: AppPalette.brown950,
  bottomSheetBackground: AppPalette.brown925,

  // Cards
  cardPrimary: AppPalette.brown925,
  cardOngoing: AppPalette.brown850,
  cardReminder: AppPalette.brown850,
  cardMood: AppPalette.brown850,

  // Mood card internal
  moodGistBackground: AppPalette.brown850,
  moodTagBackground: AppPalette.brown700_10,

  // Status
  warning: AppPalette.warning,
  error: AppPalette.error,
  success: AppPalette.success,
);

/// =======================
/// CENTRALIZED APP PALETTE
/// =======================
class AppPalette {
  // =======================
  // BRAND
  // =======================
  static const brown950 = Color(0xFF3B1D0F);
  static const brown925 = Color(0xFF512712);
  static const brown900 = Color(0xFF904224);
  static const brown850 = Color(0xFF922604);
  static const brown700 = Color(0xFFC76D46);
  static const brown700_10 = Color(0xFFF6E6DC);
  static const brown650 = Color(0xFFC96C4F);

  // =======================
  // LIGHT SURFACES
  // =======================
  static const cream50 = Color(0xFFFBF2ED);
  static const cream75 = Color(0xFFF9EFE6);
  static const cream100 = Color(0xFFFDECE9);
  static const cream200 = Color(0xFFFDECE4);

  // =======================
  // ACCENTS
  // =======================
  static const rose50 = Color(0xFFF9E0D6);
  static const rose100 = Color(0xFFFAE0D8);
  static const rose200 = Color(0xFFF6CBC1);

  // =======================
  // OVERLAYS
  // =======================
  static const brown900_10 = Color(0x1A904224);

  // =======================
  // STATUS
  // =======================
  static const success = Colors.green;
  static const warning = Colors.amber;
  static const error = Colors.redAccent;
}
