import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../loaders/shimmer_widget.dart';

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
