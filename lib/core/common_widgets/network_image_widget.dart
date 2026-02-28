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
    final double fallbackRadius = radius ?? 45.r;
    final double size = fallbackRadius * 2;

    /// ------------------ CIRCLE MODE ------------------
    if (isCircle) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c.inputBorder),
          color: c.inputBackground, // background for placeholders & errors
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildCircleContent(fallbackRadius),
      );
    }

    /// ------------------ NORMAL RECT MODE ------------------
    if (imageUrl == null || imageUrl!.isEmpty || !isImageUrl(imageUrl!)) {
      return Container(
        width: width ?? 30.w,
        height: height ?? 30.w,
        padding: EdgeInsets.all(8.w), // surrounding padding
        decoration: BoxDecoration(
          color: c.inputBackground,
          image: DecorationImage(
            image: Assets.images.imagePlaceholder.image().image,
            colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      decoration: 0.circle(),
      child: Image.network(
        imageUrl!,
        width: width ?? 30.w,
        height: height ?? 30.w,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(shape: BoxShape.circle, color: c.inputBackground),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: c.inputBackground,
              child: Padding(padding: EdgeInsets.all(12.0.w), child: Loading()),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              color: c.inputBackground,
              image: DecorationImage(
                image: Assets.images.imagePlaceholder.image().image,
                colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds everything that appears INSIDE the circle
  Widget _buildCircleContent(double fallbackRadius) {
    if (imageUrl == null || imageUrl!.isEmpty || !isImageUrl(imageUrl!)) {
      return Container(
        padding: EdgeInsets.all(4.w), // surrounding padding
        decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          color: c.inputBackground,
          image: DecorationImage(
            image: Assets.images.imagePlaceholder.image().image,
            colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            fit: BoxFit.cover,
          ),
        ),
      ).mAll(30);
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(shape: BoxShape.circle, color: c.inputBackground),
          child: CircleAvatar(
            radius: 20.r,
            backgroundColor: c.inputBackground,
            child: Padding(padding: EdgeInsets.all(12.0.w), child: Loading()),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            color: c.inputBackground,
            image: DecorationImage(
              image: Assets.images.imagePlaceholder.image().image,
              colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
