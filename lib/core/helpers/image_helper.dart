import 'package:flutter/services.dart';

import '../../app/helper_widgets_export.dart';
import '../components/ui/media/image_error_builder.dart';
import '../components/ui/sheets/file_picker_bottom_sheet.dart';
import '../components/ui/sheets/image_picker_bottom_sheet.dart';

Image get mamaLogoWithoutTxtImage =>
    Image.asset(ImagesPath.weMamaLogoWithouTxtPng, height: S.w * 0.2);
Image get mamaLogoWithoutTxtImageSmall =>
    Image.asset(ImagesPath.weMamaLogoWithouTxtPng, height: S.w * 0.11);

ImageErrorBuilder defaultErrorBuilder({double? height, double? width}) =>
    ImageErrorBuilder(height: height, width: width);

Future<String> svgPathWNewWidth({required String iconPath, required double strokeWidth}) async {
  // 1️⃣ Load SVG as string
  String svgStr = await rootBundle.loadString(iconPath);

  // 2️⃣ Replace stroke-width with desired value
  String modifiedSvg = svgStr.replaceAll(
    RegExp(r'stroke-width="[^"]+"'),
    'stroke-width="$strokeWidth"',
  );

  return modifiedSvg;
}

Column get weMamaLogoWithTxt => Column(
  children: [
    Gap(itemGap * 3),
    Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.3),
  ],
);

CircleAvatar circledImageBgComponent({String? imagePath, Color? brdrClr, double? radius}) {
  return CircleAvatar(
    radius: (radius ?? 20).r,
    backgroundColor: c.inputBackground,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: brdrClr ?? c.secondary),
        image: DecorationImage(image: AssetImage(imagePath ?? ImagesPath.userDemoL)),
      ),
    ),
  );
}

Widget circledNetworkImageBgComponent({String? imagePath, Color? brdrClr, double? radius}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: brdrClr ?? c.secondary),
    ),
    child: NetworkImageWidget(imageUrl: imagePath, radius: radius ?? 20),
  );
}

Future<dynamic> showPickImageBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  final void Function()? onTapGallery,
  final void Function()? onTapCamera,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: Container(
        height: bSheetH * 0.5 * (heightFactor ?? 1),

        // width: 1.sw,
        child: PickImageBottomSheet(onTapGallery: onTapGallery, onTapCamera: onTapCamera),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}

Future<dynamic> showPickAnyFileBottomSheet({
  double? heightFactor,
  bool isScrollControlled = true,
  final void Function()? onTapGallery,
  final void Function()? onTapCamera,
  final void Function()? onTapFile,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),

      child: Container(
        height: bSheetH * 0.45 * (heightFactor ?? 1),

        // width: 1.sw,
        child: FilePickerBottomSheet(
          onTapFile: onTapFile,
          onTapGallery: onTapGallery,
          onTapCamera: onTapCamera,
        ),
      ).getBtmSheetM,
    ),

    isScrollControlled: isScrollControlled,
    backgroundColor: bgClr, // needed for rounded corners
  );
}
