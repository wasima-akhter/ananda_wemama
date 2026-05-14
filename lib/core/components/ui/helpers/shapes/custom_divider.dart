import 'package:flutter/material.dart';

import '../../../../utils/extension/context_extension.dart';

class CustomDivider extends StatelessWidget {
  final double? w;
  final double? h;
  final Color? clr;
  final bool isFullWidth; // NEW
  final bool? isVer; // NEW

  const CustomDivider({super.key, this.w, this.h, this.clr, this.isFullWidth = false, this.isVer});

  @override
  Widget build(BuildContext context) {
    return isVer == true
        ? Container(
            height: isFullWidth ? double.infinity : (h ?? S.h * 0.05),
            width: w ?? 0.4,
            color: clr ?? c.primary,
          )
        : Container(
            width: isFullWidth ? double.infinity : (w ?? S.w * 0.35),
            height: h ?? 0.4,
            color: clr ?? c.primary,
          );
  }
}
