import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/helper_widgets_export.dart';

class SvgIconColored extends StatelessWidget {
  final String iconPath;
  final Color? iconColor;
  final double width;
  final double height;

  const SvgIconColored({
    super.key,
    required this.iconPath,
    this.iconColor,
    this.width = 16,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor_ = iconColor ?? Colors.white;
    return SvgPicture.asset(
      iconPath,
      colorFilter: ColorFilter.mode(iconColor_, BlendMode.srcIn),
      width: width.w, // responsive width
      height: height.h, // responsive height
    );
  }
}
