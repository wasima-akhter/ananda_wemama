import 'package:flutter/material.dart';
import 'package:mama_app/core/helpers/color_helper.dart';

import '../../../../utils/extension/context_extension.dart';

enum AssetImageShape { circle, rounded, free }

class SafeAssetImage extends StatelessWidget {
  final String assetPath;

  final double? width;
  final double? height;
  final double radius;

  final AssetImageShape shape;
  final BoxFit fit;

  const SafeAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.radius = 12,
    this.shape = AssetImageShape.rounded,
    this.fit = BoxFit.cover,
  });

  bool get _isCircle => shape == AssetImageShape.circle;

  @override
  Widget build(BuildContext context) {
    final fallback = SafeIconPlaceholder(
      shape: _isCircle
          ? PlaceholderShape.circle
          : shape == AssetImageShape.rounded
          ? PlaceholderShape.rounded
          : PlaceholderShape.free,
      width: width,
      height: height,
    );

    Widget imageWidget;

    try {
      imageWidget = Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );
    } catch (_) {
      imageWidget = fallback;
    }

    final clipped = ClipRRect(
      borderRadius: BorderRadius.circular(_isCircle ? 999 : radius),
      child: imageWidget,
    );

    final shapedWidget = _isCircle ? ClipOval(child: clipped) : clipped;

    return _AssetShimmerWrapper(
      width: width,
      height: height,
      child: shapedWidget,
    );
  }
}

class _AssetShimmerWrapper extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const _AssetShimmerWrapper({required this.child, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: child);
  }
}

enum PlaceholderShape { circle, rounded, free }

class SafeIconPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final PlaceholderShape shape;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const SafeIconPlaceholder({
    super.key,
    this.width,
    this.height,
    this.radius = 12,
    this.shape = PlaceholderShape.rounded,
    this.icon = Icons.image_outlined,
    this.iconColor,
    this.backgroundColor,
  });

  bool get _isCircle => shape == PlaceholderShape.circle;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? ctransp;
    final ic = iconColor ?? c.primary.withValues(alpha: 0.5);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(_isCircle ? 999 : radius),
      ),
      child: Center(
        child: Icon(
          icon,
          color: ic,
          size: (width != null && width! < 60) ? 20 : 30,
        ),
      ),
    );
  }
}
