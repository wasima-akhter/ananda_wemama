import 'package:flutter/material.dart';

import '../utils/extension/context_extension.dart';

Color get ctransp => Colors.transparent;

Color get black => Colors.black;
Color get white => Colors.white;
Color get txtDeepGrey => Color(0xFF4D4D4D);
Color get lightGreenClr => Color(0xFFABE7B2);
Color get lightGrey => Color(0xFFF9F9F9);
Color get grey100 => Colors.grey.shade100;
Color get grey200 => Colors.grey.shade200;

Color get greyLoc => Color(0xFF595959);

Color get snackErrBg => Color.fromARGB(255, 253, 236, 236);
Color get snackErrTxtClr => Color(0xFFcf071b);

Color get snackSuccessBg => Color.fromARGB(255, 252, 255, 253);
Color get snackSuccessTxtClr => Color(0xFF23B133);

Color get snackWarningBg => c.scaffoldBackground;
Color get snackWarningTxtClr => c.primary;

Color get bgClr => c.scaffoldBackground;
Color get bgClrNew => Color(0xFFFDF8F5);
Color get inputBgClr => Color(0xFFFEFCFA);
Color get contBgClr => Color(0xFFFDF4F3);
Color get newBorderClr => c.primary.withValues(alpha: 0.1);
Color get newBorderClr2_30 => c.inputBorder.withValues(alpha: 0.3);
//
Color get cardBgDeep => Color(0xFFF9E1D6);
//

Color get deepPrimary => Color(0xFF512814);

//
Color get appRed => Color(0xFFD40D0C);

Color get newCardClr => Color(0xFFFBEDE2);

Color get newCardClr2 => Color(0xFFF8E6DC).withValues(alpha: 0.25);

class AppColors {
  const AppColors._();

  /// ================================
  /// PRIMARY COLORS
  /// ================================

  static Color get primary => const Color(0xFF904224);
  static Color get primaryLight => const Color(0xFFA6827F);
  static Color get secondary => const Color(0xFFC76D46);

  /// ================================
  /// BACKGROUNDS
  /// ================================

  static Color get scaffoldBg => const Color(0xFFFBF2ED);
  static Color get bottomSheetBg => const Color(0xFFF6CBC1);
  static Color get cardBg => const Color(0xFFFAE0D8);
  static Color get inputFieldBg => const Color(0xFFFDECE4);

  /// ================================
  /// BUTTON COLORS
  /// ================================

  static Color get buttonPrimary => const Color(0xFF904224);
  static Color get buttonTextOnPrimary => const Color(0xFFFDECE9);

  /// ================================
  /// NAVIGATION
  /// ================================

  static Color get navSelected => const Color(0xFF904224);
  static Color get navUnselected => const Color(0xFFA6827F);

  /// ================================
  /// INPUT FIELDS
  /// ================================

  static Color get inputBorder => const Color(0x4DC76D46); // 30% opacity

  /// ================================
  /// TEXT COLORS
  /// ================================

  static Color get textPrimary => const Color(0xFF904224);
  static Color get textSecondary => const Color(0xFFC76D46);

  /// ================================
  /// CARD VARIANTS
  /// ================================

  static Color get moodCardBg => const Color(0xFFEADBD2);
  static Color get reminderCardBg => const Color(0xFFE1C6B6);
  static Color get moodGistLineBg => const Color(0xFFDFCECE);
  static Color get moodTagBg => const Color(0xFFF6E6DC);
}
