import 'package:flutter/services.dart';

import '../../app/helper_widgets_export.dart';
import '../common_widgets/image_error_builder.dart';

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

CircleAvatar circledImageBgComponent({String? imagePath, double? radius}) {
  return CircleAvatar(
    radius: (radius ?? 20).r,
    backgroundColor: c.inputBackground,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: c.secondary),
        image: DecorationImage(image: AssetImage(imagePath ?? ImagesPath.userDemoL)),
      ),
    ),
  );
}
