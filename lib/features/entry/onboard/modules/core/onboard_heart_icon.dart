import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';

class OnboardHeartIcon extends StatelessWidget {
  final double? height;
  final Color? startColor;
  final Color? endColor;
  const OnboardHeartIcon({
    super.key,
    this.height,
    this.startColor,
    this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return SvgIconColored(
      iconPath: Assets.icons.heartBlack,
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          startColor ?? Color(0xFFF8221E),
          endColor ?? Color(0xFFFF9191),
        ],
        stops: [0.0, 0.88],
      ),
      height:
          height ??
          (ScreenSizeX.isTablet
              ? 20.h
              : ScreenSize.isSmallWidth
              ? 38.h
              : 28.h),
    );
  }
}
