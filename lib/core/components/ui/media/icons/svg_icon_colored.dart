import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../loaders/shimmer_widget.dart';
/*
class SvgIconColored extends StatelessWidget {
  final String iconPath;
  final Color? iconColor;
  final double width;
  final double height;
  final IconData fallbackIcon;

  const SvgIconColored({
    super.key,
    required this.iconPath,
    this.iconColor,
    this.width = 16,
    this.height = 16,
    this.fallbackIcon = Icons.broken_image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? c.primary;

    return SvgPicture.asset(
      iconPath,

      /// color handling
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),

      width: width.w,
      height: height.h,

      /// ✔ SHIMMER WHILE LOADING
      placeholderBuilder: (_) => _shimmer(),

      /// ✔ SAFE FALLBACK
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: width.w, color: color);
      },
    );
  }

  ///────────────────────────────────────────
  /// SHIMMER PLACEHOLDER
  ///────────────────────────────────────────
  Widget _shimmer() {
    return ShimmerWidget.rectangular(
      width: width.w,
      height: height.h,
      shimmerClr: c.inputBorder.withOpacity(0.3),
    );
  }
}
*/

class SvgIconColored extends StatelessWidget {
  final String iconPath;

  final Color? iconColor;

  /// NEW: gradient support
  final Gradient? gradient;

  final double width;
  final double height;

  final IconData fallbackIcon;

  const SvgIconColored({
    super.key,
    required this.iconPath,
    this.iconColor,
    this.gradient,
    this.width = 16,
    this.height = 16,
    this.fallbackIcon = Icons.broken_image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final size = Size(width.w, height.h);

    Widget svg = SvgPicture.asset(
      iconPath,
      width: width.w,
      height: height.h,
      placeholderBuilder: (_) => _shimmer(),
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: width.w, color: c.primary);
      },
    );

    /// CASE 1: GRADIENT
    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (rect) {
          return gradient!.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          );
        },
        blendMode: BlendMode.srcIn,
        child: svg,
      );
    }

    /// CASE 2: SINGLE COLOR
    return SvgPicture.asset(
      iconPath,
      colorFilter: ColorFilter.mode(iconColor ?? c.primary, BlendMode.srcIn),
      width: width.w,
      height: height.h,
      placeholderBuilder: (_) => _shimmer(),
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: width.w, color: iconColor ?? c.primary);
      },
    );
  }

  Widget _shimmer() {
    return ShimmerWidget.rectangular(
      width: width.w,
      height: height.h,
      shimmerClr: c.inputBorder.withOpacity(0.3),
    );
  }
}
