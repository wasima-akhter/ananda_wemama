import 'package:google_fonts/google_fonts.dart';
import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/core/components/app_ui/snacks/founding_mum_badge_snack.dart';
import 'package:mama_app/core/enums/app_enums.dart';

import '../../themes/color/color_model.dart';
import '../../themes/theme_service.dart';

/// --------------------
/// SCREEN HELPER (No BuildContext required)
/// --------------------
class S {
  /// Screen width
  static double get w => 1.sw;

  /// Screen height
  static double get h => 1.sh;

  /// Screen height
  static double get itemGap => 1.sh * 0.01;

  /// Safe area bottom (padding)
  static double get viewPaddingBottom => ScreenUtil().bottomBarHeight;

  /// Keyboard inset (from MediaQuery window)
  static double get bottomInset =>
      MediaQueryData.fromView(WidgetsBinding.instance.window).viewInsets.bottom;

  /// Orientation
  static bool get isPortrait =>
      ScreenUtil().orientation == Orientation.portrait;
  static bool get isLandscape =>
      ScreenUtil().orientation == Orientation.landscape;

  /// Screen padding top (status bar)
  static double get topPadding => ScreenUtil().statusBarHeight;

  /// Screen padding top + notch (viewPadding)
  static double get viewPaddingTop =>
      MediaQueryData.fromView(WidgetsBinding.instance.window).padding.top;
}

/// --------------------
/// THEME COLORS
/// --------------------
extension ColorsX on ThemeController {
  ColorModel get c => selectedColorTheme;
}

// usage
final c = Get.find<ThemeController>().c;

/// --------------------
/// STRING HELPERS
/// --------------------
extension StringExtension_ on String {
  String get cap {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toLowerCaseFirst() {
    if (isEmpty) return this;
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  String capEachWord() {
    if (isEmpty) return this;

    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) {
          final cleaned = word.replaceAll('"', '');
          return word.replaceFirst(
            cleaned,
            '${cleaned[0].toUpperCase()}${cleaned.substring(1).toLowerCase()}',
          );
        })
        .join(' ');
  }

  String lowerEachWord() {
    if (isEmpty) return this;
    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .join(' ');
  }
}

extension BorderRadiusExt on num {
  BorderRadius get brdrRad => BorderRadius.circular(toDouble().r);
}

// extension EdgeExt on num {
//   BorderRadius get brdrRad => BorderRadius.circular(toDouble().r);
// }

/// --------------------
/// SNACKBARS
/// --------------------
class Snack {
  static void showFoundingMumBadge(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    closeAllSnackbar();
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: "Snack",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(duration, () {
          if (Get.isDialogOpen ?? false) Get.back();
        });

        return SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: FoundingMumBadgeSnack(
                  title: title ?? '',
                  message: message,
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static void show(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    closeAllSnackbar();
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        // Full custom content
        messageText: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: S.w * 0.15,
                  child: SvgIcon(
                    iconPath: IconsPath.leaf,
                    height: 30, // fixed icon height
                  ),
                ),
                Gap(itemGap),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TxtStyle.inter(color: c.primary, w: 600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Text(message, style: TxtStyle.inter(color: c.secondary)),
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgClr,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        borderRadius: 8.r,
        padding: EdgeInsets.all(12.w),
        duration: duration,
        animationDuration: const Duration(milliseconds: 300),
        isDismissible: true,
      ),
    );
  }

  static void showError(String message, {String? title}) {
    Get.closeCurrentSnackbar();
    closeAllSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            SizedBox(
              width: S.w * 0.15,
              child: SvgIconColored(
                iconPath: IconsPath.info,
                iconColor: snackErrTxtClr,
                height: 30,
              ),
            ),
            Gap(itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((title ?? '').isNotEmpty)
                    Text(
                      title ?? '',
                      style: TxtStyle.norTxt.copyWith(
                        color: snackErrTxtClr,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TxtStyle.norTxt.copyWith(color: snackErrTxtClr),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: snackErrBg,
        borderRadius: 12.r,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        padding: EdgeInsets.all(12.w),
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Success snackbar with green check icon
  static void showSuccess(String message, {String? title}) {
    Get.closeCurrentSnackbar();
    closeAllSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: S.w * 0.15,
              child: SvgIconColored(
                iconPath: IconsPath.smallTick,
                iconColor: c.primary ?? snackSuccessTxtClr,
                height: 30, // fixed icon height
              ),
            ),
            Gap(itemGap),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((title ?? '').isNotEmpty)
                    Text(
                      title ?? '',
                      style: TxtStyle.norTxt.copyWith(
                        color: c.primary ?? snackSuccessTxtClr,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Text(
                    message,
                    style: TxtStyle.norTxt.copyWith(
                      color: c.primary ?? snackSuccessTxtClr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: c.cardPrimary ?? snackSuccessBg,
        // backgroundColor: c.secondary.withOpacity(0.2),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(12.w),
        borderRadius: 8.r,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Warning snackbar with info icon
  static void showWarning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    closeAllSnackbar();
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        borderColor: snackWarningTxtClr.withOpacity(0.5),
        boxShadows: boxShadowAllSides,
        messageText: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: SvgIcon(
                iconPath: IconsPath.info,
                height: 30, // fixed icon height
              ),
            ),
            Gap(itemGap),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TxtStyle.outfit(color: snackWarningTxtClr, w: 600),
                    ),
                  Text(
                    message,
                    style: TxtStyle.outfit(color: snackWarningTxtClr),
                  ),
                ],
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: snackWarningBg,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
        padding: EdgeInsets.all(12.w),
        borderRadius: 8.r,
        duration: duration,
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

/// --------------------
/// GETX NAVIGATION
/// --------------------
class GNav {
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    void Function(T?)? thenEvent,
  }) async {
    return Get.toNamed<T>(routeName, arguments: arguments)?.then((value) {
      if (thenEvent != null) thenEvent(value);
      return value;
    });
  }

  static Future<T?> pushNamedReplace<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return Get.offNamed<T>(routeName, arguments: arguments) as Future<T?>;
  }

  static Future<T?> pushNamedRemoveUntil<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) async {
    return Get.offAllNamed<T>(
          routeName,
          arguments: arguments,
          predicate: predicate ?? (_) => false,
        )
        as Future<T?>;
  }

  static void pop<T extends Object?>([T? result]) {
    Get.back<T>(result: result);
  }
}

/// --------------------
/// TEXT STYLES (context-free)
/// --------------------
class TxtStyle {
  static TextTheme get textThemeInter => GoogleFonts.interTextTheme();
  static TextTheme get textThemeUrbanist => GoogleFonts.urbanistTextTheme();
  static TextTheme get textThemeOutfit => GoogleFonts.outfitTextTheme();

  static FontWeight getFontWeight(int weight) =>
      FontWeight.values[(weight ~/ 100) - 1];

  static TextStyle inter({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
    List<FontFeature>? fontFeatures,
  }) => textThemeInter.bodyMedium!.copyWith(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? c.primary,
    height: h,
    decoration: dec,
    fontFeatures: fontFeatures,
  );

  static TextStyle interSemiB({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
  }) => GoogleFonts.inter(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? c.primary,
    height: h,
    decoration: dec,
  );

  static TextStyle get txtMclr => inter(fs: 14, w: 400, color: c.primary);
  static TextStyle get txtSclr => inter(fs: 14, w: 400, color: c.textSecondary);
  static TextStyle get txtSclrSm =>
      inter(fs: 12, w: 400, color: c.textSecondary);
  static TextStyle get txtSmMclr => inter(fs: 13, w: 400, color: c.primary);
  static TextStyle get titleMclr => inter(fs: 17, w: 600, color: c.primary);

  static TextStyle get norTxt => inter(fs: 14, w: 400);
  static TextStyle get fs18 => inter(fs: 18, w: 600);
  static TextStyle get errTxt => inter(fs: 11, color: c.primary);
  static TextStyle get priClrTxt => inter(fs: 11, color: c.primary);
  static TextStyle get txtGrey => inter(fs: 11, color: greyLoc, w: 500);
  static TextStyle get confirmTxt => inter(fs: 11, color: c.secondary);
  static TextStyle get btnTxt => inter(fs: 13, w: 600, color: c.textPrimary);
  static TextStyle get italicInter =>
      inter(fs: 17, w: 600).copyWith(fontStyle: FontStyle.italic);

  static TextStyle get titleBPri => inter(fs: 16, w: 600, color: c.primary);

  static TextStyle get normRPri => inter(fs: 16, w: 400, color: c.primary);

  static TextStyle get normRsmPri => inter(fs: 14, w: 400, color: c.primary);
  static TextStyle get normRsmSec =>
      inter(fs: 14, w: 400, color: c.textSecondary);

  static TextStyle get normSmBPri => inter(fs: 14, w: 500, color: c.primary);
  ///////////////////////////////////////////////////////////

  ///             Urbanist

  /////////////////////////////////////////////////////

  static TextStyle urbanist({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
  }) => textThemeUrbanist.bodyMedium!.copyWith(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? black,
    height: h,
    decoration: dec,
  );

  static TextStyle urbanistSemiB({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
  }) => GoogleFonts.urbanist(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? black,
    height: h,
    decoration: dec,
  );

  static TextStyle get urbanistSmTitle600 =>
      TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary);
  static TextStyle get urbanistSmTitle =>
      TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary);
  static TextStyle get urbanistSmTitleSec =>
      TxtStyle.urbanistSemiB(fs: 12, w: 500, color: c.secondary);
  static TextStyle get urbanistSmSecNor =>
      TxtStyle.urbanist(fs: 13, color: c.secondary);

  ///////////////////////////Outfit
  static TextStyle outfit({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
  }) => textThemeOutfit.bodyMedium!.copyWith(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? c.primary,
    height: h,
    decoration: dec,
    decorationColor: color ?? c.primary,
  );

  static TextStyle outfitSemiB({
    double fs = 13,
    int w = 500,
    Color? color,
    double? ls,
    double? h,
    TextDecoration? dec,
  }) => GoogleFonts.outfit(
    fontSize: fs.sp,
    fontWeight: getFontWeight(w),
    letterSpacing: ls,
    color: color ?? c.primary,
    height: h,
    decoration: dec,
  );

  static TextStyle get outfitUnderLTxt => outfit(
    fs: 14,
    w: 400,
    color: c.textSecondary,
    dec: TextDecoration.underline,
  );

  static TextStyle get outfitLarTitle =>
      TxtStyle.outfitSemiB(fs: 18, w: 500, color: c.primary);
  static TextStyle get outfitSmTitle =>
      TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.primary);
  static TextStyle get outfitSmTitleSec =>
      TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.secondary);
  static TextStyle get outfitSmNor => TxtStyle.outfit(fs: 13);
  static TextStyle get outfitxSmNor => TxtStyle.outfit(fs: 11);
  static TextStyle get outfitxSmNorSec =>
      TxtStyle.outfit(fs: 11, color: c.secondary);
  static TextStyle get outfitxSmNor500 => TxtStyle.outfitSemiB(fs: 10, w: 500);
  static TextStyle get outfitSmSecNor =>
      TxtStyle.outfit(fs: 13, color: c.secondary);
  static TextStyle get outfitSmSecNor500 =>
      TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.secondary);
  static TextStyle get outfitSmNor500 =>
      TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.primary);
}

/// --------------------
/// BOX DECORATION HELPERS (context-free)
/// --------------------
class BoxDeco {
  static BoxDecoration decRadiusUp(double rad, {Color? clr}) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(rad.r),
      topRight: Radius.circular(rad.r),
    ),
  );

  static BoxDecoration decRadiusDown(double rad, {Color? clr}) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(rad.r),
      bottomRight: Radius.circular(rad.r),
    ),
  );

  static BoxDecoration decRadiusLeft(double rad, {Color? clr}) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(rad.r),
      bottomLeft: Radius.circular(rad.r),
    ),
  );

  static BoxDecoration decRadiusDownBrderAll(
    double rad, {
    Color? clr,
    Color? brdrClr,
  }) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(rad.r),
      bottomRight: Radius.circular(rad.r),
    ),
    border: Border.all(color: brdrClr ?? c.inputBorder, width: 1.w),
  );

  static BoxDecoration decRadiusUpBrderAll(
    double rad, {
    Color? clr,
    Color? brdrClr,
  }) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(rad.r),
      topRight: Radius.circular(rad.r),
    ),
    border: Border.all(color: brdrClr ?? c.inputBorder, width: 1.w),
  );

  static BoxDecoration decRadiusAll(double rad, {Color? clr}) =>
      BoxDecoration(color: clr ?? bgClr, borderRadius: (rad).brdrRad);

  static BoxDecoration decRadAllBorderedAll(
    double rad, {
    Color? clr,
    Color? brdrClr,
  }) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: rad.brdrRad,
    border: Border.all(color: brdrClr ?? c.inputBorder, width: 0.6.w),
  );

  static BoxDecoration decBrdrBottom({Color? brdrClr, double? w}) =>
      BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: brdrClr ?? c.inputBorder,
            width: (w ?? 1).w,
          ),
        ),
      );

  static BoxDecoration decBrdrTop({
    Color? brdrClr,
    double? w,
    double? rad,
    Color? clr,
  }) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular((rad ?? 4).r),
      topRight: Radius.circular((rad ?? 4).r),
    ),
    border: Border(
      top: BorderSide(color: brdrClr ?? c.inputBorder, width: (w ?? 1).w),
    ),
  );

  static BoxDecoration decBrdrOneSideCustom({
    Color? brdrClr,
    Color? clr,
    double? w,
    List<BrdrCorner>? radiusCorners, // corners to round
    double? rad,
    BrdrSideType? side, // optional side for border
  }) {
    // Build the border dynamically
    Border getBorder() {
      return Border(
        top: (side == BrdrSideType.top)
            ? BorderSide(color: brdrClr ?? c.textPrimary, width: (w ?? 0.6).w)
            : BorderSide.none,
        bottom: (side == BrdrSideType.bottom)
            ? BorderSide(color: brdrClr ?? c.textPrimary, width: (w ?? 0.6).w)
            : BorderSide.none,
        left: (side == BrdrSideType.left)
            ? BorderSide(color: brdrClr ?? c.textPrimary, width: (w ?? 0.6).w)
            : BorderSide.none,
        right: (side == BrdrSideType.right)
            ? BorderSide(color: brdrClr ?? c.textPrimary, width: (w ?? 0.6).w)
            : BorderSide.none,
      );
    }

    // Build radius according to user selection
    Radius r = Radius.circular(rad ?? 0);
    return BoxDecoration(
      color: clr ?? bgClr,
      border: getBorder(),
      borderRadius: BorderRadius.only(
        topLeft: radiusCorners?.contains(BrdrCorner.topLeft) ?? false
            ? r
            : Radius.zero,
        topRight: radiusCorners?.contains(BrdrCorner.topRight) ?? false
            ? r
            : Radius.zero,
        bottomLeft: radiusCorners?.contains(BrdrCorner.bottomLeft) ?? false
            ? r
            : Radius.zero,
        bottomRight: radiusCorners?.contains(BrdrCorner.bottomRight) ?? false
            ? r
            : Radius.zero,
      ),
    );
  }

  static BoxDecoration decRadCus({
    Color? clr,
    double? rad,
    bool? bleft,
    bool? bRight,
    bool? tleft,
    bool? tRight,
  }) => BoxDecoration(
    color: clr ?? bgClr,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(bleft == false ? 0 : (rad ?? 4).r),
      bottomRight: Radius.circular(bRight == false ? 0 : (rad ?? 4).r),
      topLeft: Radius.circular(tleft == false ? 0 : (rad ?? 4).r),
      topRight: Radius.circular(tRight == false ? 0 : (rad ?? 4).r),
    ),
  );
}

class Responsive {
  Responsive._();

  /// -------- DEVICE TYPES --------

  static bool get isSmallMobile => S.w < 360;

  static bool get isMobile => S.w < 600;

  static bool get isTablet => S.w >= 600 && S.w < 1024;

  static bool get isDesktop => S.w >= 1024;

  /// -------- HEIGHT TYPES --------

  static bool get isShortHeight => S.h < 700;

  static bool get isMediumHeight => S.h >= 700 && S.h < 850;

  static bool get isTallHeight => S.h >= 850;

  /// -------- CARD HEIGHTS --------

  static double get upcomingSessionCardHeight {
    if (isSmallMobile) return 220.h;

    if (isTallHeight) return 240.h;

    return 240.h;
  }

  /// Ongoing / Live Session Card
  static double get ongoingSessionCardHeight {
    if (isSmallMobile) return 180.h;

    if (isTallHeight) return 190.h;

    return 200.h;
  }

  /// -------- COMMON SPACING --------

  static double get pageHorizontalPadding {
    if (isTablet) return 24.w;

    return 16.w;
  }

  static double get cardRadius {
    if (isTablet) return 24.r;

    return 20.r;
  }

  /// -------- TEXT SCALE HELPERS --------

  static double font(double size) {
    if (isSmallMobile) return size - 1;

    if (isTablet) return size + 1;

    return size;
  }
}
