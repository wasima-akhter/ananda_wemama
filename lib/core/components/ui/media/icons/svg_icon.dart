import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String iconPath;
  double width;
  double height;
  SvgIcon({super.key, required this.iconPath, this.width = 16, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(iconPath, width: width, height: height);
  }
}
