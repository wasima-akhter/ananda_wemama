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
      return Container(
        width: size,
        height: size,
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
      return Container(
        decoration: BoxDecoration(
          color: c.inputBackground,
          image: DecorationImage(
            image: Assets.images.imagePlaceholder.image().image,
            colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            fit: BoxFit.cover,
          ),
          borderRadius: isCircle ? null : radius.brdrRad,
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
        return Container(
          decoration: BoxDecoration(
            color: c.inputBackground,
            image: DecorationImage(
              image: Assets.images.imagePlaceholder.image().image,
              colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
              fit: BoxFit.cover,
            ),
            borderRadius: isCircle ? null : radius.brdrRad,
          ),
        );
      },
    );
  }
}
