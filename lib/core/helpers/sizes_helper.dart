import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

double get dotSize => 8.0;
double get forArrowSvgSize => 30.0;
// double get dotSize => 8.0;

double get bSheetH => 1.sh * 0.65;
double itemGap = 0.01 * 1.sh; // 1% of screen height

// class ScreenSize {
//   static bool get isTallHeight => Get.height >= 800;
//   static bool get isMediumHeight => Get.height >= 700 && Get.height < 800;
//   static bool get isSmallHeight => Get.height < 700;

// Width
// bool get isWideWidth => Get.width >= 400;
// bool get isMediumWidth => Get.width >= 360 && Get.width < 400;
// bool get isSmallWidth => Get.width < 360;
// }
class ScreenSize {
  // Height
  static bool get isTallHeight => Get.height >= 800;
  static bool get isMediumHeight => Get.height >= 700 && Get.height < 800;
  static bool get isSmallHeight => Get.height < 700;

  // Width
  static bool get isLargeWidth => Get.width >= 430; // Plus/Pro Max
  static bool get isMediumWidth =>
      Get.width >= 390 && Get.width < 430; // Most modern phones
  static bool get isSmallWidth => Get.width < 390; // Compact phones
}
