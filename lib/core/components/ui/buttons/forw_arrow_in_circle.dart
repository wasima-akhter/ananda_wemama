import 'package:flutter/material.dart';
import 'package:we_mama/core/constants/icon_and_image_paths.dart';
import 'package:we_mama/core/helpers/sizes_helper.dart';

import '../../../helpers/color_helper.dart';
import '../../../utils/extension/context_extension.dart';
import '../../../utils/extension/int_extension.dart';
import '../media/icons/svg_icon_colored.dart';

class ForwArrowInCircle extends StatelessWidget {
  final VoidCallback? onTap;
  const ForwArrowInCircle({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap!(); // call the callback
        } else {
          GNav.pop(); // fallback
        }
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: c.textPrimary),
        child: SvgIconColored(
          width: forArrowSvgSize,
          height: forArrowSvgSize,
          iconPath: IconsPath.arrowForwardSmall,
          iconColor: bgClr,
        ).pAll(8),
      ),
    );
  }
}
