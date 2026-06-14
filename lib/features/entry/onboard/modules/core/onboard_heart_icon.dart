import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';

class OnboardHeartIcon extends StatelessWidget {
  final double? height;
  const OnboardHeartIcon({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SvgIconColored(
      iconPath: Assets.icons.heartBlack,
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFFF8221E), Color(0xFFFF9191)],
        stops: [0.0, 0.88],
      ),
      height: height ?? (ScreenSize.isSmallWidth ? 38.h : 28.h),
    );
  }
}
