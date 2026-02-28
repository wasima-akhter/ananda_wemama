import 'package:flutter/material.dart';

import 'color_model.dart';

/// =======================
/// LIGHT THEME COLORS
/// =======================
final lightColors = ColorModel(
  /// BRAND COLORS
  primary: const Color(0xFF904224),
  secondary: const Color(0xFFC76D46),

  /// NAVIGATION
  navItemSelected: const Color(0xFF904224),
  navItemUnselected: const Color(0xFFA6827F),

  /// TEXT COLORS
  textPrimary: const Color(0xFF904224),
  textSecondary: const Color(0xFFC76D46),
  textOnPrimary: const Color(0xFFFDECE9),

  /// BUTTONS
  buttonPrimary: const Color(0xFF904224),
  buttonText: const Color(0xFFFDECE9),

  /// INPUT FIELDS
  inputBackground: const Color(0xFFFDECE4),
  inputBorder: const Color(0xFFC76D46),

  /// COMPONENTS
  componentBorder: const Color(0xFFC76D46),
  componentFill: const Color(0xFFC76D46),

  /// BACKGROUNDS
  scaffoldBackground: const Color(0xFFFBF2ED),
  bottomSheetBackground: const Color(0xFFF6CBC1),

  /// CARDS
  cardPrimary: const Color(0xFFFAE0D8),
  cardOngoing: const Color(0xFFEADBD2),
  cardReminder: const Color(0xFFE1C6B6),
  cardMood: const Color(0xFFDFCECE),

  /// MOOD CARD INTERNAL
  moodGistBackground: const Color(0xFFF6E6DC),
  moodTagBackground: const Color(0xFFF6E6DC),

  /// warning, error, success
  warning: Colors.amber,
  error: Colors.redAccent,
  success: Colors.green,
);

/// =======================
/// DARK THEME COLORS
/// =======================
final darkColors = ColorModel(
  /// BRAND COLORS
  primary: const Color(0xFF904224),
  secondary: const Color(0xFFC76D46),

  /// NAVIGATION
  navItemSelected: const Color(0xFF904224),
  navItemUnselected: const Color(0xFF6E5A55),

  /// TEXT COLORS
  textPrimary: const Color(0xFFFDECE9), // Light text for dark bg
  textSecondary: const Color(0xFFE1C6B6),
  textOnPrimary: const Color(0xFFFDECE9),

  /// BUTTONS
  buttonPrimary: const Color(0xFF904224),
  buttonText: const Color(0xFFFDECE9),

  /// INPUT FIELDS
  inputBackground: const Color(0xFF2A1F1C),
  inputBorder: const Color(0xFFC76D46),

  /// COMPONENTS
  componentBorder: const Color(0xFFC76D46),
  componentFill: const Color(0xFF3A2A25),

  /// BACKGROUNDS
  scaffoldBackground: const Color(0xFF1A1412),
  bottomSheetBackground: const Color(0xFF2A1F1C),

  /// CARDS
  cardPrimary: const Color(0xFF2C1F1A),
  cardOngoing: const Color(0xFF3A2A25),
  cardReminder: const Color(0xFF3F2E29),
  cardMood: const Color(0xFF352622),

  /// MOOD CARD INTERNAL
  moodGistBackground: const Color(0xFF3A2A25),
  moodTagBackground: const Color(0xFF4A3731),

  /// warning, error, success
  warning: Colors.amber,
  error: Colors.redAccent,
  success: Colors.green,
);
