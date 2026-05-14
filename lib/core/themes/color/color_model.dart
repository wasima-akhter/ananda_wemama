import 'package:flutter/material.dart';

class ColorModel {
  final Color primary;
  final Color secondary;

  final Color navItemSelected;
  final Color navItemUnselected;

  final Color textPrimary;
  final Color textSecondary;
  final Color textOnPrimary;

  final Color buttonPrimary;
  final Color buttonText;

  final Color inputBackground;
  final Color inputBorder;

  final Color componentBorder;
  final Color componentFill;

  final Color scaffoldBackground;
  final Color bottomSheetBackground;

  final Color cardPrimary;
  final Color cardOngoing;
  final Color cardReminder;
  final Color cardMood;

  final Color moodGistBackground;
  final Color moodTagBackground;

  final Color warning;
  final Color error;
  final Color success;

  ColorModel({
    required this.primary,
    required this.secondary,
    required this.navItemSelected,
    required this.navItemUnselected,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnPrimary,
    required this.buttonPrimary,
    required this.buttonText,
    required this.inputBackground,
    required this.inputBorder,
    required this.componentBorder,
    required this.componentFill,
    required this.scaffoldBackground,
    required this.bottomSheetBackground,
    required this.cardPrimary,
    required this.cardOngoing,
    required this.cardReminder,
    required this.cardMood,
    required this.moodGistBackground,
    required this.moodTagBackground,
    required this.warning,
    required this.error,
    required this.success,
  });
}
