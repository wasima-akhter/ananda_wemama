import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/buttons/custom_btn_w_icon.dart';

class OnboardGetStartedButton extends StatelessWidget {
  const OnboardGetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBtnWIcon(
      text: Strings.getStarted,
      bgColor: c.strokePrimary,
      textColor: c.backgroundPrimary,
      iconPath: IconsPath.arrowRightLg,
      iconPosition: IconPosition.right,
      onTap: () => Get.toNamed(RoutePaths.onboardScreen2),
    );
  }
}
