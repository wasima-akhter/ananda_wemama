import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'svg_icon_colored.dart';

class SvgIcon extends StatelessWidget {
  final String iconPath;
  final double width;
  final double height;

  const SvgIcon({
    super.key,
    required this.iconPath,
    this.width = 16,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SvgIconCache.loadSvg(iconPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: width, height: height);
        }

        return SvgPicture.string(
          snapshot.data!,
          width: width.w,
          height: height.h,
        );
      },
    );
  }
}
