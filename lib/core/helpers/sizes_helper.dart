import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

double get dotSize => 8.0;
double get forArrowSvgSize => 30.0;
// double get dotSize => 8.0;

double get bSheetH => 1.sh * 0.65;
double itemGap = 0.01 * 1.sh; // 1% of screen height

final actionBtnHeight = 35.h;

class DeviceSize {
  const DeviceSize._();

  static const double phoneMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static double get width => ScreenUtil().screenWidth;

  static bool get isPhone => width < phoneMaxWidth;

  static bool get isTablet => width >= phoneMaxWidth && width < tabletMaxWidth;

  static bool get isPhoneOrTablet => width < tabletMaxWidth;

  static bool get isSmallPhone => width < 380;
}

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

extension ScreenSizeX on ScreenSize {
  /// 📱 Shortest side (important for orientation + small devices)
  static double get shortestSide =>
      Get.width < Get.height ? Get.width : Get.height;

  static double get longestSide =>
      Get.width > Get.height ? Get.width : Get.height;

  /// 📱 Device type based on shortest side (more reliable than width/height separately)
  static bool get isCompactDevice => shortestSide < 360;

  static bool get isNormalPhone => shortestSide >= 360 && shortestSide < 420;

  static bool get isLargePhone => shortestSide >= 420;

  /// 📱 Tablet detection (VERY important for layout stability)
  static bool get isTablet => shortestSide >= 600;
}

extension ScreenSizeShortestLogic on ScreenSize {
  /// Use this for scaling paddings, gaps, overlaps
  static double get s => Get.width < Get.height ? Get.width : Get.height;

  /// Safe vertical spacing multiplier
  static double v(double factor) => s * factor;

  /// Safe horizontal spacing multiplier
  static double h(double factor) => Get.width * factor;
}
