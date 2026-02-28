import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_widgets/image_error_builder.dart';
import '../constants/icon_and_image_paths.dart';
import '../utils/extension/context_extension.dart';

Image get mamaLogoWithoutTxtImage =>
    Image.asset(ImagesPath.weMamaLogoWithouTxtPng, height: S.w * 0.2);

defaultErrorBuilder({double? height, double? width}) =>
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
