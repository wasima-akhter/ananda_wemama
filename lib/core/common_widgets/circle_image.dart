import 'package:flutter/material.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

import '../../gen/assets.gen.dart';

class CircleImage extends StatelessWidget {
  final double? radius;
  const CircleImage({Key? key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: (radius ?? 20).r,
      backgroundImage: Assets.images.splash1Image.image().image,
    );
  }
}
