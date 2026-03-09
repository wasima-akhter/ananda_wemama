import 'package:mama_app/core/common_widgets/back_arrow_in_circle.dart';
import 'package:mama_app/features/entry/onboard/widgets/mood_library_sample.dart';

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
        onTap: () => Get.toNamed(RoutePaths.signin),
        isLoading: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(itemGap * 5),
          Align(alignment: Alignment.centerLeft, child: BackArrowInCircle()),
          Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.3),
          Gap(itemGap * 2),
          FittedBox(
            child: Text(
              Strings.feelBetterTogether,
              textAlign: TextAlign.center,
              style: 17.titleMclrCusFS,
            ).mHV(20, 0),
          ),
          Gap(itemGap),
          Text(
            Strings.moodToolsExpertSessionsRealCommunity,
            textAlign: TextAlign.center,
            style: 13.norMclrCusFS,
          ).mHV(40, 0),
          Gap(itemGap * 2),
          MoodLibrarySample(moodDataList: oc.moodDataList),
          Gap(itemGap * 3),
          Container(
            decoration: BoxDeco.decRadAllBorderedAll(12, brdrClr: c.primary),
            child: Image.asset(ImagesPath.onboarding3),
          ),

          Gap(itemGap * 4),
        ],
      ).getcm,
    );
  }
}
