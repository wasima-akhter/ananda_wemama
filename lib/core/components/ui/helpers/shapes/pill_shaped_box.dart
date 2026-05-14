import 'package:flutter/material.dart';

import 'custom_paint.dart';

class PillShapedBox extends StatelessWidget {
  final double? h;
  final double? w;
  final String text;
  final Color paintBrdrClr;
  final Color fillColor;
  final TextStyle style;
  final double? hp;
  final double? vp;
  final bool isLeftRound;
  const PillShapedBox({
    super.key,
    this.h,
    this.w,
    required this.text,
    required this.paintBrdrClr,
    required this.style,
    this.hp,
    this.vp,
    required this.fillColor,
    required this.isLeftRound,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: isLeftRound
          ? LeftRoundRightCutPainter(
              borderColor: paintBrdrClr,
              fillColor: fillColor,
              borderWidth: 1.2,
            )
          : RightRoundLeftCutPainter(
              borderColor: paintBrdrClr,
              fillColor: fillColor,
              borderWidth: 1.2,
            ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hp ?? 5, vertical: vp ?? 5),
        height: h,
        width: w,
        child: Center(child: Text(text, style: style)),
      ),
    );
  }
}
