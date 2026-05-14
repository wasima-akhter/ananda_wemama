// import 'package:flutter/material.dart';
// import 'package:taskip/utils/extensions/context_extension.dart';

// class TextfieldInputdec {
//   static InputDecoration underlineWithIcon({
//     required BuildContext context,
//     String? hintText,
//     required Color borderColor,
//     required bool forForm,
//     required bool hasSuffixIcon,
//     required String suffixIconType, // 'location' or 'search'
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       isDense: true,
//       // hint: Text(
//       //   hintText,
//       //   style: forForm ? context.grey14Serif : context.black16Serif,
//       // ),
//       hintText: hintText,
//       // contentPadding: EdgeInsets.only(bottom: 15),
//       focusedBorder: UnderlineInputBorder(
//         borderSide: BorderSide(width: 0.5, color: borderColor),
//       ),
//       enabledBorder: UnderlineInputBorder(
//         borderSide: BorderSide(
//           width: 0.5,
//           color: context.colors.primaryBorderColor,
//         ),
//       ),
//       suffixIcon: hasSuffixIcon
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 26,
//                   height: 26,
//                   child: Builder(
//                     builder: (context) {
//                       return suffixIcon ?? SizedBox.shrink();
//                     },
//                   ),
//                 ),
//               ],
//             )
//           : SizedBox.shrink(),
//     );
//   }
// }
