import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

class SvgIconWNewStroke extends StatelessWidget {
  final String iconPath;
  final Color? iconColor;
  final double? size;
  final double? strokeWidth;

  const SvgIconWNewStroke({
    super.key,
    required this.iconPath,
    this.iconColor,

    this.strokeWidth,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor_ = iconColor ?? c.textPrimary;
    return FutureBuilder(
      future: svgPathWNewWidth(iconPath: iconPath, strokeWidth: strokeWidth ?? 2),
      builder: (context, asyncSnapshot) {
        final modifiedSvg = asyncSnapshot.data;
        return SvgPicture.string(
          modifiedSvg.toString(),
          height: size ?? 16,
          width: size ?? 16,
          colorFilter: ColorFilter.mode(iconColor_, BlendMode.srcIn),
        );
      },
    );
  }
}
