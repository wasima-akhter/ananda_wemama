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
  navItemUnselected: AppPalette.brown_,

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
  cardOngoing: AppPalette.beige200,
  cardReminder: AppPalette.beige300,
  cardMood: AppPalette.mauve200,

  // Mood card internal
  moodGistBackground: AppPalette.brown700_10,
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
  static const brown_ = Color(0xFFA6827F);

  // ======================= // TEXT // ======================= static
  static const textPrimary = brown950;
  static const textSecondary = Color(0xFF795548);
  static const textTertiary = Color(0xFFA6827F);

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
  // ADDITIONAL CARD COLORS
  // =======================
  static const beige200 = Color(0xFFEADBD2); // cardOngoing
  static const beige300 = Color(0xFFE1C6B6); // cardReminder
  static const mauve200 = Color(0xFFDFCECE); // cardMood

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

  static const snackSuccess = Color(0xFF4F7A4A);
  // static const snackWarning = Color(0xFF9A6A2A);
  static const snackWarning = Color.fromARGB(255, 196, 125, 58);
  static const snackError = Color(0xFFAD3A3A);

  static const snackPurple = Color(0xFF6B4F8A);
  static const snackDeepPurple = Color(0xFF4A3566);
}

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
  navItemUnselected: AppPalette.brown_,

  // Text
  textPrimary: AppPalette.cream100,
  textSecondary: AppPalette.cream75,
  textOnPrimary: AppPalette.cream100,

  // Buttons
  buttonPrimary: AppPalette.brown900,
  buttonText: AppPalette.cream100,

  // Input fields
  inputBackground: AppPalette.brown925, // #512712
  inputBorder: AppPalette.brown700, // #C76D46
  // Components
  componentBorder: AppPalette.brown700, // #C76D46
  componentFill: AppPalette.brown925, // #512712
  // Scaffold / Bottom sheet
  scaffoldBackground: AppPalette.brown950, // #3B1D0F
  bottomSheetBackground: AppPalette.brown925, // #512712
  // Cards
  cardPrimary: AppPalette.brown925, // #512712
  cardOngoing: AppPalette.brown850, // #922604
  cardReminder: AppPalette.brown850, // #922604
  cardMood: AppPalette.brown850, // #922604
  // Mood card internal
  moodGistBackground: AppPalette.brown850, // #922604
  moodTagBackground: AppPalette.brown700_10, // #F6E6DC
  // Status
  warning: AppPalette.warning,
  error: AppPalette.error,
  success: AppPalette.success,
);
