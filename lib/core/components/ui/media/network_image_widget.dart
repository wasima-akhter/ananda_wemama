import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../loaders/shimmer_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final bool isCircle;
  final bool? isSmall;
  final double? radius;
  final bool? isUser;
  final Animation<double>? opacity;
  final bool? hasBrdr;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.isCircle = false,
    this.radius,
    this.opacity,
    this.hasBrdr,
    this.isSmall,
    this.isUser,
  });

  bool isImageUrl(String url) {
    return RegExp(r'\.(jpg|jpeg|png|webp)$', caseSensitive: false).hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    final double fallbackRadius = (radius ?? 12).r;

    if (isCircle) {
      final double circleSize = fallbackRadius * 2;
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: hasBrdr == false ? null : Border.all(color: c.inputBorder),
          color: c.inputBackground,
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildImageContent(isCircle: true, radius: fallbackRadius),
      );
    }

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
    // Scale placeholder icon relative to circle size when isCircle is true
    final double placeholderSize = isCircle
        ? (radius * 0.7).clamp(8.0, 22.0) // 70% of radius, clamped between 8–22
        : (isSmall == true ? 12.w : 22.w);

    if (imageUrl == null || imageUrl!.isEmpty || !isImageUrl(imageUrl!)) {
      return Center(
        child: isUser == false
            ? Assets.images.imagePlaceholder.image(
                width: placeholderSize,
                height: placeholderSize,
                color: c.primary,
              )
            : Assets.images.userPlaceholder.image(
                width: placeholderSize,
                height: placeholderSize,
                color: c.primary,
              ),
      );
    }

    print("imageUrl in net widget : ${makeImageUrl(imageUrl: imageUrl ?? '')}");

    return Image.network(
      makeImageUrl(
        imageUrl: (imageUrl ?? '').startsWith('/')
            ? (imageUrl ?? '').substring(1)
            : (imageUrl ?? ''),
      ),
      opacity: opacity ?? const AlwaysStoppedAnimation(1.0),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return isCircle
            ? ShimmerWidget.circular(
                width: double.infinity,
                height: double.infinity,
                shimmerClr: c.inputBorder.withOpacity(0.4),
              )
            : ShimmerWidget.rectangular(
                width: double.infinity,
                height: double.infinity,
                shimmerClr: c.inputBorder.withOpacity(0.4),
              );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: isUser == false
              ? Assets.images.imagePlaceholder.image(
                  width: placeholderSize,
                  height: placeholderSize,
                  color: c.primary,
                )
              : Assets.images.userPlaceholder.image(
                  width: placeholderSize,
                  height: placeholderSize,
                  color: c.primary,
                ),
        );
      },
    );
  }
}
