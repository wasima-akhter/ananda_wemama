import '../../../../../app/helper_widgets_export.dart';

class OnboardPrivacyBadge extends StatelessWidget {
  const OnboardPrivacyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: 8.brdrRad,
        color: c.backgroundSecondary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIconColored(iconPath: IconsPath.shieldCheck, height: 20),
          Gap(4),
          Text(
            Strings.yourPrivacyIsOurPriority.capEachWord(),
            style: TxtStyle.inter(
              fs: ScreenSize.isTallHeight ? 11 : 10,
              w: 400,
              h: 1.0,
              color: c.primary,
            ),
          ),
        ],
      ),
    );
  }
}
