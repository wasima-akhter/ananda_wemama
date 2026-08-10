import 'package:we_mama/core/components/ui/buttons/back_arrow_in_circle.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/onboard_controller.dart';

class OnboardScreen3 extends StatelessWidget {
  const OnboardScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = findCont<OnboardController>();

    return AppScreenTemplate(
      bottomWidget: CustomBtnWTxt(
        btnTxt: Strings.continueTxt,
        isSmall: true,
        onTap: () => oc.finishOnboarding(),
        isLoading: false,
      ),
      child: Stack(
        children: [
          Positioned(
            top: itemGap * 5,
            left: itemGap * 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: BackArrowInCircle(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Gap(itemGap * 7),
              Image.asset(ImagesPath.weMamaLogo, height: S.w * 0.26),
              Gap(itemGap * 1.5),
              FittedBox(
                child: Text(
                  Strings.feelBetterTogether,
                  textAlign: TextAlign.center,
                  style: 15.titleMclrCusFS,
                ).mHV(20, 0),
              ),
              Gap(itemGap),
              Text(
                Strings.moodToolsExpertSessionsRealCommunity,
                textAlign: TextAlign.center,
                style: 12.norMclrCusFS,
              ),
              Gap(itemGap * 2),
              // MoodLibrarySample(moodDataList: oc.moodDataList),
              Gap(itemGap * 1.5),
              Container(
                decoration: BoxDeco.decRadAllBorderedAll(
                  12,
                  brdrClr: c.primary,
                ),
                child: Image.asset(ImagesPath.onboarding3),
              ),

              Gap(itemGap * 2),
            ],
          ).getcm,
        ],
      ),
    );
  }
}
