import 'package:mama_app/features/main_tabs/match/controller/match_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/subscription_upgrade_controller.dart';
import '../widgets/subscription_card.dart';

class SubscriptionUpgradeScreen extends StatelessWidget {
  const SubscriptionUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scpc = Get.find<SubscriptionUpgradeController>();

    final chooseSubPlanFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.subscriptionUpgrade,
        onTapBack: () async {
          Get.back(result: true);
          MatchController.to.resetState();
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Container(
              padding: 20.pa,
              color: c.buttonText,
              child: filledBtnWTxt(
                btnTxt: Strings.continueTxt,
                isLoading: scpc.isLoading,
                onTap: () => scpc.onTapContinue(chooseSubPlanFormKey),

                //  await scpc.onTapSignup(chooseSubPlanFormKey),
              ),
            ),
          ),
        ],
      ),
      child: Form(
        key: chooseSubPlanFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.chooseYourPlan.capEachWord(),
              textAlign: TextAlign.center,
              style: 22.titleMclrCusFSOutfit,
            ),
            Text(
              Strings.supportConnectionGuidance.capEachWord(),
              textAlign: TextAlign.center,
              style: TxtStyle.outfit(fs: 14, w: 600, color: c.primary),
            ),

            Gap(itemGap * 3),

            // here will two sections of subscription model.
            // one is free  another one is paid.
            // will be  reactive and changes bgColor, textColor if selected
            Obx(() {
              final isSelected = scpc.isPlanSelected(0);

              return GestureDetector(
                onTap: () => scpc.selectPlan(0),

                child: FreeSubCard(isSelected: isSelected),
              );
            }),

            Gap(itemGap * 2.5),
            Obx(() {
              final isSelected = scpc.isPlanSelected(1);

              return GestureDetector(
                onTap: () => scpc.selectPlan(1),

                child: PaidSubCard(isSelected: isSelected),
              );
            }),

            Gap(itemGap * 2.5),
          ],
        ).getcm,
      ),
    );
  }
}
