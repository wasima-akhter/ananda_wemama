import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../loaders/shimmer_widget.dart';

class SvgIconCache {
  SvgIconCache._();

  static final Map<String, String> _svgRawCache = {};

  static Future<String> loadSvg(String path) async {
    return _svgRawCache[path] ??= await rootBundle.loadString(path);
  }
}

class SvgVariantCache {
  SvgVariantCache._();

  static final Map<String, String> _cache = {};

  static String key(String path, Color? color, Gradient? gradient) {
    return '$path|${color?.value}|${gradient?.hashCode}';
  }

  static String get(String key) => _cache[key] ?? '';

  static void set(String key, String value) {
    _cache[key] = value;
  }

  static bool contains(String key) => _cache.containsKey(key);
}

class SvgIconEngine {
  SvgIconEngine._();

  static Future<String> getSvg({
    required String path,
    Color? color,
    Gradient? gradient,
  }) async {
    final key = SvgVariantCache.key(path, color, gradient);

    if (SvgVariantCache.contains(key)) {
      return SvgVariantCache.get(key);
    }

    String svg = await SvgIconCache.loadSvg(path);

    // Apply color fallback if needed
    if (color != null && gradient == null) {
      svg = svg.replaceAll(
        RegExp(r'fill="[^"]+"'),
        'fill="#${color.value.toRadixString(16).substring(2)}"',
      );

      svg = svg.replaceAll(
        RegExp(r'stroke="[^"]+"'),
        'stroke="#${color.value.toRadixString(16).substring(2)}"',
      );
    }

    SvgVariantCache.set(key, svg);
    return svg;
  }
}

class SvgIconColored extends StatelessWidget {
  final String iconPath;
  final Color? iconColor;
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

    final shimmerWidget = ShimmerWidget.rectangular(
      width: width.w,
      height: height.h,
      shimmerClr: c.inputBorder.withOpacity(0.3),
    );

    return FutureBuilder<String>(
      future: SvgIconEngine.getSvg(
        path: iconPath,
        color: iconColor,
        gradient: gradient,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return shimmerWidget;
        }

        final svgString = snapshot.data!;

        Widget svg = SvgPicture.string(
          svgString,
          width: width.w,
          height: height.h,
          placeholderBuilder: (_) => shimmerWidget,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              fallbackIcon,
              size: width.w,
              color: iconColor ?? c.primary,
            );
          },
        );

        if (gradient != null) {
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) {
              return gradient!.createShader(
                Rect.fromLTWH(0, 0, size.width, size.height),
              );
            },
            child: svg,
          );
        }

        return svg;
      },
    );
  }
}

/*
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

    late final Widget shimmerWidget = ShimmerWidget.rectangular(
      width: width.w,
      height: height.h,
      shimmerClr: c.inputBorder.withOpacity(0.3),
    );
    final svg = SvgPicture.asset(
      iconPath,
      width: width.w,
      height: height.h,
      placeholderBuilder: (_) => shimmerWidget,
      errorBuilder: (context, error, stackTrace) {
        return Icon(fallbackIcon, size: width.w, color: iconColor ?? c.primary);
      },
      colorFilter: gradient == null
          ? ColorFilter.mode(iconColor ?? c.primary, BlendMode.srcIn)
          : null,
    );

    if (gradient != null) {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (rect) {
          return gradient!.createShader(
            Rect.fromLTWH(0, 0, size.width, size.height),
          );
        },
        child: svg,
      );
    }

    return svg;
  }
}
*/
