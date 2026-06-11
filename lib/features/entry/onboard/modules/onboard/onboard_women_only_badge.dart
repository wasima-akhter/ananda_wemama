import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';

class OnboardWomenOnlyBadge extends StatelessWidget {
  const OnboardWomenOnlyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    double getIconH() {
      if (ScreenSize.isSmallWidth) {
        if (ScreenSize.isTallHeight) return 23;
        if (ScreenSize.isMediumHeight || ScreenSize.isSmallHeight) return 18;
      }
      return 23;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSize.isTallHeight ? 4.h : 2.h,
        horizontal: 14.w,
      ),
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        borderRadius: 30.brdrRad,
        color: const Color(0xFFFDECE4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgIcon(iconPath: Assets.icons.shieldFill, height: getIconH()),
          Gap(4),
          Text(
            Strings.womenOnlySpace.toUpperCase(),
            style: TxtStyle.inter(fs: ScreenSize.isTallHeight ? 10 : 9),
          ),
        ],
      ),
    );
  }
}
