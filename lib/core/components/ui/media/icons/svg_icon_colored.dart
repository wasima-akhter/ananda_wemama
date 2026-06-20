import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../loaders/shimmer_widget.dart';

class SvgIconCache {
  SvgIconCache._();

  static final Map<String, String> _svgRawCache = {};
  static final Map<String, Future<String>> _inFlight = {};

  /// Synchronous read if already cached — avoids FutureBuilder flicker on rebuilds
  static String? getSync(String path) => _svgRawCache[path];

  static Future<String> loadSvg(String path) {
    if (_svgRawCache.containsKey(path)) {
      return Future.value(_svgRawCache[path]);
    }
    // Avoid duplicate concurrent loads of the same asset
    return _inFlight[path] ??= rootBundle.loadString(path).then((svg) {
      _svgRawCache[path] = svg;
      _inFlight.remove(path);
      return svg;
    });
  }

  /// Call this for icons you know you'll need (e.g. in app init or screen init)
  static Future<void> preload(List<String> paths) async {
    await Future.wait(paths.map(loadSvg));
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

    // 👇 Fast path — already cached, render synchronously, no FutureBuilder rebuild
    final cached = SvgIconCache.getSync(iconPath);
    if (cached != null) {
      return _buildSvg(cached, size, shimmerWidget);
    }

    // Slow path — first time loading this asset
    return FutureBuilder<String>(
      future: SvgIconCache.loadSvg(iconPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return shimmerWidget;
        return _buildSvg(snapshot.data!, size, shimmerWidget);
      },
    );
  }

  Widget _buildSvg(String svgString, Size size, Widget shimmerWidget) {
    Widget svg = SvgPicture.string(
      svgString,
      width: width.w,
      height: height.h,
      placeholderBuilder: (_) => shimmerWidget,
      colorFilter: gradient == null && iconColor != null
          ? ColorFilter.mode(iconColor ?? c.strokePrimary, BlendMode.srcIn)
          : ColorFilter.mode(c.strokePrimary, BlendMode.srcIn),
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: width.w,
          color: iconColor ?? c.strokePrimary,
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
