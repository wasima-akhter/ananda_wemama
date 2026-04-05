import 'package:mama_app/core/components/ui/buttons/back_arrow_in_circle.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/welcome_funding_mum_controller.dart';
import '../widgets/wel_fund_mum_bottom_sec.dart';
import '../widgets/wel_fund_mum_page1.dart';

class WelcomeFundingMumScreen extends StatelessWidget {
  const WelcomeFundingMumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WelcomeFundingMumController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      isScrollable: false,

      bottomWidget: WelcomeFundingMumBottomSection(controller: controller),
      child: WelcomeFundingMumBody(controller: controller, formKey: formKey),
    );
  }
}

class WelcomeFundingMumBody extends StatelessWidget {
  final WelcomeFundingMumController controller;
  final GlobalKey<FormState> formKey;

  const WelcomeFundingMumBody({super.key, required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        // no MainAxisSize.min 👈
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(itemGap * 5),
          Align(alignment: Alignment.centerLeft, child: BackArrowInCircle()).getcm,
          Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.3),
          Gap(itemGap * 1.5),

          Expanded(
            // 👈 works because AppScreenTemplate isScrollable:false gives bounded height
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                WelFundMumPage1(wfmc: controller),
                WelFundMumPage2(wfmc: controller),
                WelFundMumPage3(wfmc: controller),
                WelFundMumPage4(wfmc: controller),
                WelFundMumPage5(wfmc: controller),
              ],
            ),
          ),

          Gap(itemGap * 3),
        ],
      ).getcm,
    );
  }
}
