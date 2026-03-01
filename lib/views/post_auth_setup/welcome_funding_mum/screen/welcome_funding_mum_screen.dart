import 'package:mama_app/core/common_widgets/app_screen_template.dart';
import 'package:mama_app/core/helpers/image_helper.dart';
import 'package:mama_app/views/post_auth_setup/welcome_funding_mum/widgets/wel_fund_mum_page1.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_check_box.dart';
import '../controller/welcome_funding_mum_controller.dart';

class WelcomeFundingMumScreen extends StatelessWidget {
  const WelcomeFundingMumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wfmc = Get.find<WelcomeFundingMumController>();
    final welcomeFundMumFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      isScrollable: false,
      bottomWidget:
          /// Bottom continue button
          Obx(() {
            final isIntro = wfmc.isIntroPage;
            final isConfirm = wfmc.isConfirmationPage;
            final showBtn = wfmc.shouldShowButton;
            return Column(
              spacing: itemGap * 2,
              children: [
                if (isIntro)
                  Text(
                    Strings.firstMumsMessage.cap,
                    textAlign: TextAlign.center,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
                  ),
                if (isConfirm)
                  CusGestureDetector(
                    onTap: wfmc.toggleReady,
                    child: ContainerBordered(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCheckBox(
                            value: wfmc.isReady.value,
                            onChanged: wfmc.setReady,
                            borderColor: c.primary,
                            activeColor: c.primary,
                            checkColor: c.scaffoldBackground,
                          ),
                          Gap(itemGap),

                          IntrinsicWidth(
                            child: Text(
                              Strings.firstMumsMessage.cap,
                              textAlign: TextAlign.center,
                              style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (showBtn)
                  filledBtnWTxt(
                    btnTxt: wfmc.getbtnText,
                    isLoading: wfmc.isLoading,
                    onTap: wfmc.onTapButton,
                  ),
              ],
            );
          }),
      child: Form(
        key: welcomeFundMumFormKey,
        child: Column(
          spacing: itemGap,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(itemGap * 5),
            weMamaLogoWithTxt,
            Gap(itemGap * 3),

            /// Paged content
            Expanded(
              child: PageView(
                // physics: const NeverScrollableScrollPhysics(),
                physics: const BouncingScrollPhysics(),
                controller: wfmc.pageController,
                onPageChanged: wfmc.onPageChanged,
                children: [
                  WelFundMumPage1(wfmc: wfmc),
                  WelFundMumPage2(wfmc: wfmc),
                  WelFundMumPage3(wfmc: wfmc),
                  WelFundMumPage4(wfmc: wfmc),
                  WelFundMumPage5(wfmc: wfmc),
                ],
              ),
            ),

            Gap(itemGap * 3),
          ],
        ).getcm,
      ),
    );
  }
}
