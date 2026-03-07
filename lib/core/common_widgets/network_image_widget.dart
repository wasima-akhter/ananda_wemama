import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/gen/assets.gen.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final bool isCircle;
  final double? radius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.isCircle = false,
    this.radius,
  });

  bool isImageUrl(String url) {
    return RegExp(r'\.(jpg|jpeg|png|webp)$', caseSensitive: false).hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    final double fallbackRadius = radius ?? 12.r;
    final double size = fallbackRadius * 2;

    /// ------------------ CIRCLE MODE ------------------
 if (isCircle) {
  final double circleSize = width ?? height ?? 60.w;

  return Container(
    width: circleSize,
    height: circleSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: c.inputBorder),
      color: c.inputBackground,
    ),
    clipBehavior: Clip.antiAlias,
    child: _buildImageContent(isCircle: true, radius: fallbackRadius),
  );
}
    /// ------------------ NORMAL RECT MODE ------------------
    return Container(
      width: width ?? 30.w,
      height: height ?? 30.w,
      decoration: BoxDecoration(color: c.inputBackground, borderRadius: fallbackRadius.brdrRad),
      clipBehavior: Clip.antiAlias,
      child: _buildImageContent(isCircle: false, radius: fallbackRadius),
    );
  }

  /// Builds image content, circle or rect
Widget _buildImageContent({required bool isCircle, required double radius}) {
  if (imageUrl == null || imageUrl!.isEmpty || !isImageUrl(imageUrl!)) {
    if (isCircle) {
      return Center(
        child: Assets.images.imagePlaceholder.image(
          width: 22.w,
          height: 22.w,
          color: c.primary,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: c.inputBackground,
        borderRadius: radius.brdrRad,
      ),
      child: Center(
        child: Assets.images.imagePlaceholder.image(
          width: 22.w,
          height: 22.w,
          color: c.primary,
        ),
      ),
    );
  }

  return Image.network(
    imageUrl!,
    fit: BoxFit.cover,
    width: isCircle ? null : double.infinity,
    height: isCircle ? null : double.infinity,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: SizedBox(width: 24.r, height: 24.r, child: Loading()),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Center(
        child: Assets.images.imagePlaceholder.image(
          width: 22.w,
          height: 22.w,
          color: c.primary,
        ),
      );
    },
  );
}


}
