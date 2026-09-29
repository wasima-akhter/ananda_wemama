import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../dialogs/popups.dart';
import '../loaders/shimmer_widget.dart';

/// Returns capitalized initials from the first two words of a name.
/// e.g. "sarah jane connor" -> "SJ", "maria" -> "M"
String getNameInitials(String? name) {
  if (name == null || name.trim().isEmpty) return '';

  final words = name.trim().split(RegExp(r'\s+'));
  final firstTwo = words.take(2);

  return firstTwo.map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
}

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
  final Color? bgColor;
  final bool? hasShadow;
  final String? name; // 👈 new
  final bool? solidPlaceholderCircle;

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
    this.bgColor,
    this.hasShadow,
    this.name,
    this.solidPlaceholderCircle,
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
          boxShadow: hasShadow == true
              ? boxShadowBottom(
                  color: Color(0xFF904224).withValues(alpha: 0.5),
                  blur: 4,
                )
              : null,
          shape: BoxShape.circle,
          border: hasBrdr == false
              ? null
              : Border.all(
                  color: solidPlaceholderCircle == true
                      ? c.primary
                      : c.inputBorder,
                ),
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
        color: bgColor ?? c.inputBackground,
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

    print("imageUrl in net widget : ${makeImageUrl(imageUrl: imageUrl ?? '')}");

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
    final fallbackIconColor = c.strokePrimary;
    final initials = getNameInitials(widget.name);
    final hasInitials = widget.isUser == true && initials.isNotEmpty;
    return Center(
      child: widget.solidPlaceholderCircle == true
          ? Container(
              width: size * 2,
              height: size * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.primary,
              ),
            )
          : hasInitials
          ? Text(
              initials,
              style: TxtStyle.poppinsSemiBold12Center(
                fs: size * 0.7,
                color: fallbackIconColor,
              ).copyWith(fontWeight: FontWeight.bold),
            )
          : widget.isUser == true
          ? Icon(
              Icons.person_2_rounded,
              size: ScreenSize.isSmallWidth ? size * 0.8 : size,
              color: fallbackIconColor,
            )
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
