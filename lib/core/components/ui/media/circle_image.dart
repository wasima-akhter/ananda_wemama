import 'package:we_mama/app/helper_widgets_export.dart';

import '../../../../gen/assets.gen.dart';

class CircleImage extends StatelessWidget {
  final double? radius;
  const CircleImage({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: (radius ?? 20).r,
      backgroundImage: Assets.images.userDemoL.image().image,
    );
  }
}

class IconInCircleBrdr extends StatelessWidget {
  final String iconPath;
  final String goToPath;
  final double? radius;
  const IconInCircleBrdr({
    super.key,
    required this.iconPath,
    required this.goToPath,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: () {
        Get.toNamed(goToPath);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c.secondary),
          color: c.inputBackground,
        ),
        child: CircleAvatar(
          radius: radius ?? 17.r,
          backgroundColor: c.inputBackground,
          child: SvgIcon(iconPath: iconPath),
        ),
      ),
    );
  }
}
