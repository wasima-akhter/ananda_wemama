import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_mama/app/controller_export.dart';

/// --------------------
/// SIZEDBOX EXTENSIONS
/// --------------------
extension SizedBoxExtension on num {
  Widget get toHeight => SizedBox(height: toDouble().h);
  Widget get toWidth => SizedBox(width: toDouble().w);
}

extension TxtStyleExtension on num {
  TextStyle get titleMclrCusFS =>
      TxtStyle.interSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get titleMclrCusFSsemi =>
      TxtStyle.interSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get norMclrCusFS =>
      TxtStyle.inter(fs: toDouble(), w: 400, color: c.primary);

  TextStyle get titleMclrCusFSURB =>
      TxtStyle.urbanistSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get titleSclrCusFSURB =>
      TxtStyle.urbanistSemiB(fs: toDouble(), w: 600, color: c.textSecondary);
  TextStyle get titleMclrCusFSsemiURB =>
      TxtStyle.urbanistSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get norMclrCusFSURB =>
      TxtStyle.urbanist(fs: toDouble(), w: 400, color: c.primary);

  TextStyle get titleMclrCusFSOutfit =>
      TxtStyle.outfitSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get titleSclrCusFSOutfit =>
      TxtStyle.outfitSemiB(fs: toDouble(), w: 600, color: c.textSecondary);
  TextStyle get titleMclrCusFSsemioutfit =>
      TxtStyle.outfitSemiB(fs: toDouble(), w: 600, color: c.primary);
  TextStyle get norMclrCusFSoutfit =>
      TxtStyle.outfit(fs: toDouble(), w: 400, color: c.primary);
  TextStyle get norSecclrCusFSoutfit =>
      TxtStyle.outfit(fs: toDouble(), w: 400, color: c.secondary);
  TextStyle get norSecclrUnderLoutfit => TxtStyle.outfit(
    fs: 14,
    w: 400,
    color: c.textSecondary,
    dec: TextDecoration.underline,
  );

  // titleB -> 16px, semi, 600
  // normRL --> 16px, reg, 400
  // normRsm --> 14px, reg, 400
  // normSmB --> 14px, semi, 500
}

/// --------------------
/// RADIUS EXTENSIONS
/// --------------------
extension RadiusExtension_ on num {
  BorderRadiusGeometry get circular => BorderRadius.circular(toDouble().r);
  BorderRadiusGeometry get only => BorderRadius.circular(toDouble().r);
}

/// --------------------
/// BOX DECORATION EXTENSIONS
/// --------------------
extension BoxdecorationExtension on num {
  BoxDecoration circleBrdr({Color? clr, Color? brdrClr, double? brdrW}) =>
      BoxDecoration(
        shape: BoxShape.circle,
        color: clr,
        border: Border.all(color: brdrClr ?? c.primary, width: brdrW ?? 0.6),
      );
}

/// --------------------
/// BORDER RADIUS HELPER
/// --------------------
extension BorderRadiusHelper on num {
  BorderRadius borderOnly({
    double topLeft = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
    double topRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft.r),
      topRight: Radius.circular(topRight.r),
      bottomLeft: Radius.circular(bottomLeft.r),
      bottomRight: Radius.circular(bottomRight.r),
    );
  }
}

/// --------------------
/// EDGE INSETS EXTENSIONS
/// --------------------
extension EdgeInsetExtension on num {
  EdgeInsetsGeometry get ph => EdgeInsets.symmetric(horizontal: toDouble().w);
  EdgeInsetsGeometry get pv => EdgeInsets.symmetric(vertical: toDouble().h);
  EdgeInsetsGeometry get pa => EdgeInsets.all(toDouble().r);
  EdgeInsetsGeometry get pzero => EdgeInsets.zero;
}

/// --------------------
/// PADDING EXTENSIONS
/// --------------------
extension PaddingExtensions on Widget {
  Widget pHV(double h, double v) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h.w, vertical: v.h),
    child: this,
  );

  Widget pAll(double a) => Padding(padding: EdgeInsets.all(a.r), child: this);

  Widget pOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    ),
    child: this,
  );

  /// Common reusable padding
  Widget get getcp => Padding(
    padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
    child: this,
  );
}

/// --------------------
/// MARGIN EXTENSIONS
/// --------------------
extension MarginExtensions on Widget {
  Widget mHV(double h, double v) => Container(
    margin: EdgeInsets.symmetric(horizontal: h.w, vertical: v.h),
    child: this,
  );

  Widget mAll(double a) => Container(margin: EdgeInsets.all(a.r), child: this);

  Widget mOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Container(
    margin: EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    ),
    child: this,
  );

  Widget mR(double right) => Container(
    margin: EdgeInsets.only(right: right.w),
    child: this,
  );
  Widget mL(double left) => Container(
    margin: EdgeInsets.only(left: left.w),
    child: this,
  );
  Widget mT(double top) => Container(
    margin: EdgeInsets.only(top: top.h),
    child: this,
  );
  Widget mB(double bottom) => Container(
    margin: EdgeInsets.only(bottom: bottom.h),
    child: this,
  );

  Widget get getcm => Container(
    margin: EdgeInsets.only(top: 0, left: 16.w, right: 16.w, bottom: 0),
    child: this,
  );

  Widget get get10cm => Container(
    margin: EdgeInsets.only(top: 0, left: 10.w, right: 10.w, bottom: 0),
    child: this,
  );

  Widget get getBtmSheetM => Container(
    margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
    child: this,
  );
}

/// --------------------
/// MAX / MIN EXTENSIONS
/// --------------------
extension MaxMinNullable on List<num>? {
  num maxValue() {
    if (this == null || this!.isEmpty) return 0;
    return this!.reduce((a, b) => a > b ? a : b);
  }

  num minValue() {
    if (this == null || this!.isEmpty) return 0;
    return this!.reduce((a, b) => a < b ? a : b);
  }
}

/// --------------------
/// MEDIA QUERY VALUES
/// --------------------
extension MediaQueryValues on BuildContext {
  double get h => MediaQuery.of(this).size.height;
  double get w => MediaQuery.of(this).size.width;
}

/// --------------------
/// ITEM GAP (RESPONSIVE)
/// --------------------
extension ItemGapExtension on num {
  double itemGap(BuildContext context) => context.h * 0.01 * this;
}

extension NumberFormatting on num? {
  String formatToK() {
    if (this == null) return '0';

    if (this! >= 1000) {
      double result = this! / 1000;

      if (result % 1 == 0) {
        return '${result.toInt()}K';
      } else {
        return '${result.toStringAsFixed(1)}K';
      }
    }

    return toString();
  }
}
