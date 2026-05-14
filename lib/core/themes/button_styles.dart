// import 'package:flutter/material.dart';

// import '../helper/color_helper.dart';
// import '../utils/extensions/context_extension.dart';

// class ButtonStyles {
//   ButtonStyle primaryClr(BuildContext context) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: context.colors.primaryColor,
//       minimumSize: const Size(250, 48),
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius:6.brdrRad),
//     );
//   }

//   final ButtonStyle grey = ElevatedButton.styleFrom(
//     backgroundColor: Colors.grey[300],
//     minimumSize: const Size(220, 45),
//     shape: RoundedRectangleBorder(borderRadius:6.brdrRad),
//   );

//   final ButtonStyle transparentNohw = ElevatedButton.styleFrom(
//     backgroundColor: ctransp,
//     elevation: 0,
//     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     minimumSize: const Size(260, 10),
//     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//     shape: RoundedRectangleBorder(borderRadius:0.brdrRad),
//   );

//   ButtonStyle customBtn({Color? btnColor, double? w, double? h, double? rad}) {
//     return ElevatedButton.styleFrom(
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       padding: EdgeInsets.zero,
//       backgroundColor: btnColor ?? cwhite,
//       minimumSize: Size(w ?? 240, h ?? 48),
//       shape: RoundedRectangleBorder(borderRadius:(rad ?? 6).brdrRad),
//       elevation: 0,
//     );
//   }

//   ButtonStyle customBtnBordered(
//     Color? borderClr,
//     Color? btnColor,
//     double? w,
//     double? h,
//     double? rad,
//     double? brdrW,
//     EdgeInsetsGeometry? padding,
//   ) {
//     return ElevatedButton.styleFrom(
//       backgroundColor: btnColor ?? cc.primaryColor,
//       minimumSize: Size.zero,

//       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       padding: padding ?? EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         side: brdrW == null
//             ? BorderSide.none
//             : BorderSide(color: borderClr ?? cgrey(shade: 200), width: brdrW ?? 0.8),
//         borderRadius:(rad ?? 6).brdrRad,
//       ),
//       elevation: 0,
//     );
//   }
// }
