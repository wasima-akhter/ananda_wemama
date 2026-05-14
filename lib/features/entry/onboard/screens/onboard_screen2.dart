import 'package:mama_app/core/components/ui/buttons/back_arrow_in_circle.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../shared/community_spotlight/community_spotlight.dart';
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
      child: Stack(
        children: [
          Positioned(
            top: itemGap * 5,
            left: itemGap * 3,
            child: Align(alignment: Alignment.centerLeft, child: BackArrowInCircle()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Gap(itemGap * 7),
              Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.28),
              Gap(itemGap * 2),
              FittedBox(
                child: Text(
                  Strings.findMumsNearYou,
                  textAlign: TextAlign.center,
                  style: 15.titleMclrCusFS,
                ).mHV(20, 0),
              ),
              Gap(itemGap * 0.5),
              Text(
                Strings.friendshipSupportUnderstanding,
                textAlign: TextAlign.center,
                style: TxtStyle.outfitSemiB(fs: 12, w: 400, color: c.primary),
              ).mHV(40, 0),
              Gap(itemGap * 2),
              Image.asset(ImagesPath.onboarding2),
              Gap(itemGap * 2),
              CommunitySpotlight(isFromOnboardScreen: true),

              Gap(itemGap * 2),
            ],
          ).getcm,
        ],
      ),
    );
  }
}
