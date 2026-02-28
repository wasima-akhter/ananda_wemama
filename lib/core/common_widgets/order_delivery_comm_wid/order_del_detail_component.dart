// import 'package:mama_app/core/common_widgets/gesture_detector_cus.dart';

// import '../../../app/helper_widgets_export.dart';
// import '../../../gen/assets.gen.dart';
// import '../custom_btn_w_txt.dart';
// import '../list_ot_item_list.dart';

// class OrderDelDescriptionCard extends StatelessWidget {
//   final ListOfItemDataModel? listOfItem;
//   final bool? noLocationRow;
//   final Widget? rightBtnWidet;
//   const OrderDelDescriptionCard({Key? key, this.listOfItem, this.noLocationRow, this.rightBtnWidet})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double itemGap = 1.sh * 0.01;
//     String title = '';
//     String subtitle = '';
//     String value = '';
//     String time = '';
//     if (listOfItem != null) {
//       title = listOfItem?.title ?? Strings.fakeName;
//       subtitle = listOfItem!.subTitle ?? '';
//       value = listOfItem!.value ?? '';
//       time = listOfItem!.time ?? '';
//     }
//     return ContainerBordered(
//       vp: 25,
//       hp: 8,

//       // brdrW: 0.1,
//       // brdrClr: grey200,
//       // contClr: Colors.amber[100],
//       boxShadow: boxShadowAllSides,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // image
//           Expanded(flex: 2, child: CircleImage(radius: 24)),
//           Expanded(
//             flex: 7,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 TextFit(Strings.fakeName, style: titleStyleSemiB),

//                 Gap(itemGap * 0.5),
//                 Text("+30 54564 5565", style: TxtStyle.inter(w: 600, color: txtDeepGrey)),
//                 Gap(itemGap * 0.5),
//                 Text(
//                   "electenergynltd@email.com",
//                   style: TxtStyle.inter(w: 600, color: txtDeepGrey),
//                 ),
//                 Gap(itemGap),

//                 if (noLocationRow == null)
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Row(
//                           children: [
//                             SvgIcon(iconPath: Assets.icons.locationFilledSvg),
//                             Gap(itemGap * 0.2),
//                             Container(
//                               constraints: BoxConstraints(maxWidth: 1.sw * 0.13),
//                               child: TextFit(
//                                 Strings.fakeLocationName,
//                                 style: TxtStyle.inter(fs: 11, color: c.primary, w: 600),
//                                 overflow: TextOverflow.clip,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       Expanded(
//                         flex: 3,
//                         child: CusGestureDetector(
//                           onTap: () {
//                             GNav.pushNamed(RoutePaths.reviewAndRating);
//                           },
//                           child: Row(
//                             children: [
//                               Text(
//                                 "4.0",
//                                 style: TxtStyle.inter(fs: 11, color: c.primary, w: 600),
//                               ),
//                               Gap(itemGap * 0.5),
//                               SvgIcon(iconPath: Assets.icons.starFilledSvg, height: 12),
//                               Gap(itemGap * 0.5),
//                               Text(
//                                 "(120 Rating)",
//                                 style: TxtStyle.inter(fs: 11, color: c.primary, w: 600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                 if (rightBtnWidet != null)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [rightBtnWidet ?? SizedBox.shrink()],
//                   ),
//               ],
//             ),
//           ),

//           //
//         ],
//       ),
//     );
//   }
// }

// class OrderDelDetListComponent extends StatelessWidget {
//   final List<OrderDelDetListComItemBar>? listOfBarItems;
//   const OrderDelDetListComponent({Key? key, this.listOfBarItems}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double itemGap = 1.sh * 0.04;

//     if (listOfBarItems != null) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ...List.generate(listOfBarItems!.length, (index) {
//             final title = listOfBarItems![index].title;
//             final value = listOfBarItems![index].value;
//             return Column(
//               children: [
//                 OrderDelDetListComItemBar(title: title, value: value),

//                 Gap(itemGap),
//               ],
//             );
//           }),
//         ],
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         OrderDelDetListComItemBar(title: Strings.orderDate, value: "8 Nov 2025"),
//         Gap(itemGap),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             OrderDelDetListComItemBar(title: Strings.rate, value: "₦ 1,499.30"),
//             OrderDelDetListComItemBar(
//               title: Strings.quantity,
//               value: "10 Litter Fuel",
//               alignRight: true,
//             ),
//           ],
//         ),
//         Gap(itemGap),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,

//           children: [
//             OrderDelDetListComItemBar(title: Strings.totalPrice, value: "₦ 1,499.30"),
//             OrderDelDetListComItemBar(
//               title: Strings.orderStatus,
//               value: "Pending",
//               alignRight: true,
//             ),
//           ],
//         ),
//         Gap(itemGap),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             OrderDelDetListComItemBar(
//               title: Strings.deliveryAddress,
//               subValue: "Obinrikiti street, Lagos Island, Lagos, Nigeria",
//               value: "UBA House Marina Lagos",
//             ),
//             OrderDelDetListComItemBar(
//               buttonText: Strings.viewOnMap,
//               onButtonTap: () {
//                 // go to map page
//                 print("view on map");
//                 GNav.pushNamed(RoutePaths.googleMap);
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// /// 🔹 A reusable widget for displaying a title-value pair in the order details.
// /// 🔹 Supports optional sub-values, button widgets, and alignment (left/right).
// class OrderDelDetListComItemBar extends StatelessWidget {
//   // ⚙️ Alignment flags
//   final bool? alignRight;

//   // 📝 Text content
//   final String? title;
//   final String? value;
//   final String? subValue;

//   // 🔘 Optional button
//   final String? buttonText;
//   final VoidCallback? onButtonTap;

//   const OrderDelDetListComItemBar({
//     super.key,
//     this.alignRight,
//     this.title,
//     this.value,
//     this.subValue,
//     this.buttonText,
//     this.onButtonTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isRightAligned = alignRight == true;

//     // ⚠️ Special layout for delivery address
//     final bool isDeliveryAddress = title == Strings.deliveryAddress;
//     final double deliveryWidth = 1.sw * 0.6;

//     // 🔹 If a button text is provided, render as a button instead
//     if (buttonText != null) {
//       return CustomBtnWTxt(
//         isSmall: true,
//         outlined: true,
//         btnTxt: buttonText ?? '',
//         onTap: onButtonTap,
//         isLoading: false,
//       );
//     }

//     // 🔹 Main container for the title-value pair
//     return Container(
//       width: isDeliveryAddress ? deliveryWidth : null,
//       child: Column(
//         mainAxisSize: isDeliveryAddress ? MainAxisSize.min : MainAxisSize.max,
//         crossAxisAlignment: isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           // 🔹 Title text
//           Text(
//             (title ?? '').capEachWord(),
//             textAlign: isRightAligned ? TextAlign.right : TextAlign.left,
//             style: TxtStyle.interSemiB(fs: 13, w: 600, color: c.primary),
//           ),
//           Gap(1.sh * 0.005),

//           // 🔹 Value section
//           Align(
//             alignment: isRightAligned ? Alignment.centerRight : Alignment.centerLeft,
//             child: Row(
//               mainAxisSize: MainAxisSize.min, // Wraps content width
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // 🔹 Value + SubValue column
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Value text
//                     ConstrainedBox(
//                       constraints: BoxConstraints(maxWidth: deliveryWidth),
//                       child: isDeliveryAddress
//                           ? Text(
//                               (value ?? '').capEachWord(),
//                               style: TxtStyle.interSemiB(fs: 15, w: 700),
//                             )
//                           : Text((value ?? ''), style: TxtStyle.interSemiB(fs: 15, w: 600)),
//                     ),

//                     // Optional subValue text
//                     if (subValue != null) ...[
//                       Gap(4),
//                       ConstrainedBox(
//                         constraints: BoxConstraints(maxWidth: deliveryWidth),
//                         child: Text(subValue!, style: TxtStyle.inter(fs: 11, w: 600)),
//                       ),
//                     ],
//                   ],
//                 ),

//                 // 🔹 Optional "per litre" label for rate
//                 if (title == Strings.rate) ...[
//                   Gap(4),
//                   Text(Strings.perLitre, style: TxtStyle.inter(fs: 8, w: 700)),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
