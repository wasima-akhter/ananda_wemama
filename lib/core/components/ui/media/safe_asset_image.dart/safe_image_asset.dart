import 'package:flutter/material.dart';
import 'package:we_mama/core/helpers/color_helper.dart';

import '../../../../utils/extension/context_extension.dart';

enum AssetImageShape { circle, rounded, free }

class SafeAssetImage extends StatelessWidget {
  final String assetPath;

  final double? width;
  final double? height;
  final double radius;

  final AssetImageShape shape;
  final BoxFit fit;
  final Alignment alignment;

  const SafeAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.radius = 12,
    this.shape = AssetImageShape.rounded,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  bool get _isCircle => shape == AssetImageShape.circle;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_isCircle ? 999 : radius);

    final image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      cacheWidth: _cacheWidth(),
      cacheHeight: _cacheHeight(),
      errorBuilder: (_, _, _) =>
          SafeIconPlaceholder(shape: _mapShape(), width: width, height: height),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: _isCircle ? ClipOval(child: image) : image,
    );
  }

  int? _cacheWidth() {
    if (width == null || !width!.isFinite)
      return null; // 👈 guard against Infinity/NaN
    return (width! * 2).toInt();
  }

  int? _cacheHeight() {
    if (height == null || !height!.isFinite) return null; // 👈 same guard
    return (height! * 2).toInt();
  }

  PlaceholderShape _mapShape() {
    return shape == AssetImageShape.circle
        ? PlaceholderShape.circle
        : shape == AssetImageShape.rounded
        ? PlaceholderShape.rounded
        : PlaceholderShape.free;
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
