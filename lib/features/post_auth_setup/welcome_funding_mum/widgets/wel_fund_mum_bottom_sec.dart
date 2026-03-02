import '../../../../app/helper_widgets_export.dart';
import '../controller/welcome_funding_mum_controller.dart';

class WelcomeFundingMumBottomSection extends StatelessWidget {
  final WelcomeFundingMumController controller;

  const WelcomeFundingMumBottomSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        spacing: itemGap * 2,
        children: [
          if (controller.isIntroPage) _IntroMessage(),

          if (controller.isConfirmationPage) _ConfirmationCheckbox(controller: controller),

          if (controller.shouldShowButton)
            filledBtnWTxt(
              btnTxt: controller.getbtnText,
              isLoading: controller.isLoading,
              onTap: controller.onTapButton,
            ),
        ],
      );
    });
  }
}

class _IntroMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      Strings.firstMumsMessage.cap,
      textAlign: TextAlign.center,
      style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
    );
  }
}

class _ConfirmationCheckbox extends StatelessWidget {
  final WelcomeFundingMumController controller;

  const _ConfirmationCheckbox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: controller.toggleReady,
      child: ContainerBordered(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCheckBox(
              value: controller.isReady.value,
              onChanged: controller.setReady,
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
    );
  }
}
