import 'package:mama_app/core/common_widgets/back_arrow_in_circle.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/community_spotlight.dart';
import '../controller/onboard_controller.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = findCont<OnboardController>();

    return AppScreenTemplate(
      bottomWidget: CustomBtnWTxt(
        btnTxt: Strings.continueTxt,
        isSmall: true,
        onTap: () => Get.toNamed(RoutePaths.onboardScreen3),
        isLoading: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(itemGap * 5),
          Align(alignment: Alignment.centerLeft, child: BackArrowInCircle()),
          Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.3),
          Gap(itemGap),
          FittedBox(
            child: Text(
              Strings.findMumsNearYou,
              textAlign: TextAlign.center,
              style: 17.titleMclrCusFS,
            ).mHV(20, 0),
          ),
          Gap(itemGap),
          Text(
            Strings.friendshipSupportUnderstanding,
            textAlign: TextAlign.center,
            style: 12.titleMclrCusFS,
          ).mHV(40, 0),
          Gap(itemGap),
          Image.asset(ImagesPath.onboarding2),
          Gap(itemGap * 2),
          CommunitySpotlight(isFromOnboardScreen: true),

          Gap(itemGap * 4),
        ],
      ).getcm,
    );
  }
}
