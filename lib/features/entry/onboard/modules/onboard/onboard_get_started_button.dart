import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/buttons/custom_btn_w_icon.dart';

class OnboardGetStartedButton extends StatelessWidget {
  const OnboardGetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBtnWIcon(
      text: Strings.getStarted,
      // padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      bgColor: c.strokePrimary,
      iconPath: IconsPath.arrowRightLg,
      iconPosition: IconPosition.right,
      onTap: () => Get.toNamed(RoutePaths.onboardScreen2),
    );
  }
}
