import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../helpers/shapes/container_bordered.dart';

class ContShimmer extends StatelessWidget {
  final double? h;
  final double? w;
  final double? rad;
  final Color? sclr;

  const ContShimmer({super.key, this.h, this.w, this.rad, this.sclr});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      h: h ?? 35,
      w: w ?? MediaQuery.of(context).size.width - 50,
      hp: 0,
      vp: 0,
      rad: rad ?? 10,
      // brdrClr: sclr ?? Colors.grey.shade300,
      hasBrdr: false,
      contClr: Colors.grey.shade200,
      child: Shimmer(
        color: Colors.grey.shade200,
        direction: ShimmerDirection.fromLTRB(),
        child: Container(
          height: h ?? 35,
          width: w ?? MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(rad ?? 10),
          ),
        ),
      ),
    );
  }
}
