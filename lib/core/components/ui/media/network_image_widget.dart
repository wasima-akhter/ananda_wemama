import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../dialogs/popups.dart';
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
  final bool? enablePreview;

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
    this.enablePreview,
  });

  bool isImageUrl(String url) {
    return RegExp(
      r'\.(jpg|jpeg|png|webp)$',
      caseSensitive: false,
    ).hasMatch(url);
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
      decoration: BoxDecoration(
        color: c.inputBackground,
        borderRadius: fallbackRadius.brdrRad,
      ),
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

    log("imageUrl in net widget : ${makeImageUrl(imageUrl: imageUrl ?? '')}");

    final validImage =
        imageUrl != null &&
        (imageUrl ?? '').isNotEmpty &&
        (imageUrl ?? '').startsWith('http');

    return CusGestureDetector(
      onTap: (!(enablePreview == true) || imageUrl == null || imageUrl!.isEmpty)
          ? null
          : () {
              showImageViewer(
                context: Get.context!,
                imageSource: makeImageUrl(
                  imageUrl: (imageUrl ?? '').startsWith('/')
                      ? (imageUrl ?? '').substring(1)
                      : (imageUrl ?? ''),
                ),
              );
            },
      child: isCircle
          ? ClipOval(
              child: Image.network(
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

                  return _ShimmerWidget(isCircle: isCircle);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _FallbackWidget(widget: this);
                },
              ),
            )
          : Image.network(
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

                return _ShimmerWidget(isCircle: isCircle);
              },
              errorBuilder: (context, error, stackTrace) {
                return _FallbackWidget(widget: this);
              },
            ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget({required this.isCircle});

  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    if (isCircle) {
      return ShimmerWidget.circular(
        width: double.infinity,
        height: double.infinity,
        shimmerClr: c.inputBorder.withOpacity(0.4),
      );
    }

    return ShimmerWidget.rectangular(
      width: double.infinity,
      height: double.infinity,
      shimmerClr: c.inputBorder.withOpacity(0.4),
    );
  }
}

///────────────────────────────────────────
class _FallbackWidget extends StatelessWidget {
  const _FallbackWidget({required this.widget});

  final NetworkImageWidget widget;

  @override
  Widget build(BuildContext context) {
    final double size = widget.isCircle
        ? ((widget.radius ?? 16))
        : (widget.isSmall == true ? 18 : 22);
    final fallbackIconColor = c.primary;
    return Center(
      child: widget.isUser == true
          ? Icon(Icons.person_2_rounded, size: size, color: fallbackIconColor)
          // SvgIconColored(
          //     iconPath: Assets.icons.userIconOutlined,
          //     width: size,
          //     height: size,
          //     iconColor: fallbackIconColor,
          //     fallbackIcon: Icons.person,
          //   )
          : Assets.images.imagePlaceholder.image(
              width: size,
              height: size,
              fit: BoxFit.contain,
              color: fallbackIconColor,
            ),
    );
  }
}

///
