import '../../../../../app/helper_widgets_export.dart';
import '../../modules/onboard/onboard_get_started_button.dart';
import '../../modules/onboard/onboard_login_section.dart';
import '../../modules/onboard/onboard_privacy_badge.dart';
import '../../widgets/onboard/onboard_layout_config.dart';

class OnboardBottomSection extends StatelessWidget {
  const OnboardBottomSection({super.key, required this.cfg});

  final OnboardLayoutConfig cfg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ScreenSize.isSmallWidth ? Gap(2) : const SizedBox.shrink(),
        OnboardGetStartedButton(),
        Gap(ScreenSize.isSmallWidth ? 6.h : 12.h),

        OnboardLoginSection(),
        Gap(ScreenSize.isSmallWidth ? 4.h : 12.h),

        OnboardPrivacyBadge(),
      ],
    ).mHV(18, 0);
  }
}
