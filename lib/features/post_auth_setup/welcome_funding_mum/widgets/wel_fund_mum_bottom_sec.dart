import '../../../../app/helper_widgets_export.dart';
import '../controller/welcome_funding_mum_controller.dart';

class WelcomeFundingMumBottomSection extends StatelessWidget {
  final WelcomeFundingMumController controller;

  const WelcomeFundingMumBottomSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: itemGap * 2,
        children: [
          if (controller.isIntroPage) _IntroMessage(),

          if (controller.isConfirmationPage)
            Align(
              alignment: Alignment.centerLeft,
              child: _ConfirmationCheckbox(controller: controller),
            ),

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
    return Obx(
      () => CusGestureDetector(
        // ← wrap with Obx
        onTap: controller.toggleReady,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IgnorePointer(
                    // ← prevent checkbox eating the tap
                    child: CustomCheckBox(
                      value: controller.isReady.value,
                      onChanged: (_) {}, // ← no-op, parent handles it
                      borderColor: c.primary,
                      activeColor: c.primary,
                      checkColor: c.scaffoldBackground,
                    ),
                  ),
                  Gap(itemGap),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.readyToJoin.cap,
                        textAlign: TextAlign.left,
                        style: TxtStyle.urbanistSemiB(fs: 14, w: 500, color: c.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
