import 'package:mama_app/core/helpers/image_helper.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/common_components/bg_image_container.dart';
import '../controller/onboard_controller.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = findCont<OnboardController>();

    return SafeArea(
      top: false,

      child: Scaffold(
        backgroundColor: bgClr,

        extendBodyBehindAppBar: true,

        body: BgImageContainer(
          child: BounceSingleChildScrollView(
            child: Column(
              spacing: itemGap,

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                weMamaLogoWithTxt,
                Gap(itemGap * 3),
                FittedBox(
                  child: Text(
                    Strings.motherhoodSupportLine,
                    textAlign: TextAlign.center,
                    style: 17.titleMclrCusFS,
                  ).mHV(20, 0),
                ),
                Text(
                  Strings.builtForMotherhoodStages,
                  textAlign: TextAlign.center,
                  style: 12.titleMclrCusFS,
                ).mHV(40, 0),

                Gap(itemGap * 5),

                Image.asset(ImagesPath.onboardingImage),

                Gap(itemGap * 3),

                CustomBtnWTxt(
                  w: S.w * 0.6,
                  btnTxt: Strings.getStarted,
                  isUppCase: true,
                  onTap: () {
                    Get.toNamed(RoutePaths.onboardScreen2);
                  },
                  isLoading: false,
                ),
                Gap(itemGap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(Strings.alreadyHaveAnAccount, style: TxtStyle.norTxt),
                    Gap(itemGap),
                    CusGestureDetector(
                      onTap: () {
                        //
                        Get.toNamed(RoutePaths.signin);
                      },
                      child: ContainerBordered(
                        child: Text(Strings.loginWithSpace.capEachWord(), style: 12.titleMclrCusFS),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
