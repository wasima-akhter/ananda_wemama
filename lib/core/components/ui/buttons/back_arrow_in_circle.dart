import 'package:flutter/material.dart';
import 'package:we_mama/core/constants/icon_and_image_paths.dart';

import '../../../utils/extension/context_extension.dart';
import '../media/icons/svg_icon.dart';

class BackArrowInCircle extends StatelessWidget {
  final VoidCallback? onTap;
  const BackArrowInCircle({super.key, this.onTap});

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
        // decoration: BoxDecoration(shape: BoxShape.circle, color: c.buttonPrimary),
        child: SvgIcon(
          width: 30,
          height: 30,
          iconPath: IconsPath.backNavArrow,
          // iconColor: c.textPrimary,
        ),
        // .pAll(14),
      ),
    );
  }
}
