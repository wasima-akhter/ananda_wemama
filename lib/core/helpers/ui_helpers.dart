// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:we_mama/core/common_widgets/image_error_builder.dart';

// import '../../app/helper_widgets_export.dart';
// import '../common_widgets/custom_btn_w_txt.dart';
// import '../common_widgets/image_picker_bottom_sheet.dart';

// T findCont<T extends GetxController>() {
//   return Get.find<T>();
// }

// defaultErrorBuilder({double? height, double? width}) =>
//     ImageErrorBuilder(height: height, width: width);
// Future<String> svgPathWNewWidth({required String iconPath, required double strokeWidth}) async {
//   // 1️⃣ Load SVG as string
//   String svgStr = await rootBundle.loadString(iconPath);

//   // 2️⃣ Replace stroke-width with desired value
//   String modifiedSvg = svgStr.replaceAll(
//     RegExp(r'stroke-width="[^"]+"'),
//     'stroke-width="$strokeWidth"',
//   );

//   return modifiedSvg;
// }

// TextStyle componentTxtStyle(BuildContext context) => TxtStyle.inter(fs: 11, w: 600);
// TextStyle amountTxtStyle(BuildContext context, {Color? clr}) =>
//     TxtStyle.inter(fs: 11, w: 700, color: clr ?? c.textSecondary);

// TextStyle get titleStyleSemiB => TxtStyle.interSemiB(fs: 16, w: 700);
// TextStyle get fs22w800Style => TxtStyle.interSemiB(fs: 22, w: 800);
// TextStyle get titleStyle =>titleStyle;

// List<BoxShadow> boxShadow({bool? isLess}) => [
//   BoxShadow(
//     color: grey200.withOpacity(isLess == true ? 0.1 : 0.5), // light grey
//     blurRadius: isLess == true ? 6 : 12,
//     offset: isLess == true ? Offset(2, 2) : Offset(6, 6), // right (x) and bottom (y)
//   ),
// ];
// List<BoxShadow> get boxShadowAllSides => [
//   BoxShadow(
//     color: Colors.black.withOpacity(0.05), // #0000000D
//     offset: const Offset(1, 1), // x:1, y:1
//     blurRadius: 10, // blur
//     spreadRadius: 0, // same as Figma
//   ),

//   //         offset: Offset(x, y)

//   // x > 0 → shadow goes to the right

//   // y > 0 → shadow goes to the bottom

//   // blurRadius: 6 → softness of the shadow edges

//   // Lower opacity = softer/lighter shadow
// ];
// List<BoxShadow> boxShadowAllSide({double? shadowIntensity}) => [
//   BoxShadow(
//     color: Colors.black.withOpacity(shadowIntensity ?? 0.1), // #0000000D
//     offset: const Offset(1, 1), // x:1, y:1
//     blurRadius: 10, // blur
//     spreadRadius: 0, // same as Figma
//   ),

//   //         offset: Offset(x, y)

//   // x > 0 → shadow goes to the right

//   // y > 0 → shadow goes to the bottom

//   // blurRadius: 6 → softness of the shadow edges

//   // Lower opacity = softer/lighter shadow
// ];

// CustomBtnWTxt filledBtnWTxt({
//   required BuildContext context,
//   Color? btnColor,
//   void Function()? onTap,
//   required String btnTxt,
//   required bool isLoading,
// }) => CustomBtnWTxt(
//   onTap: onTap,
//   style: TxtStyle.interSemiB(w: 600),
//   btnColor: btnColor ?? greyLoc,
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

//   btnTxt: btnTxt,
//   isLoading: isLoading,
// );

// Future<T?> showPickImageottomSheet<T>({
//   required BuildContext context,

//   double? heightFactor, // default 0.5 of screen
//   bool isScrollControlled = true,
//   Future<void> Function()? onTapAnOption,
// }) {
//   return showModalBottomSheet<T>(
//     
//     isScrollControlled: isScrollControlled,
//     backgroundColor: bgClr,
//     builder: (context) {
//       return AnimatedPadding(
//         duration: const Duration(milliseconds: 250),
//         padding: EdgeInsets.only(bottom: S.bottomInset),
//         child: Container(
//           height: bSheetH * (heightFactor ?? 0.5),
//           width: 1.sw,
//           decoration: BoxDecoration(borderRadius: 0.borderOnly(topLeft: 30, topRight: 30)),
//           child: PickImageBottomSheet(onTap: () async => await onTapAnOption),
//         ).getBtmSheetM,
//       );
//     },
//   );
// }
// // open gallery
