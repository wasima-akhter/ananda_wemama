import '../../../../../app/helper_widgets_export.dart';
import '../controller/subscription_choose_plan_controller.dart';
import '../widgets/subscription_card.dart';

class SubscriptionChoosePlanScreen extends StatelessWidget {
  const SubscriptionChoosePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scpc = Get.find<SubscriptionChoosePlanController>();

    final chooseSubPlanFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.chooseYourPlan.capEachWord()),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerBordered(
            rad: 0,
            contClr: c.inputBackground,
            boxShadow: boxShadowTopOnly,
            vp: 14,
            child: Obx(
              () => IgnorePointer(
                ignoring: !scpc.hasSelectedPlan || scpc.isLoading,
                child: Opacity(
                  opacity: scpc.hasSelectedPlan ? 1 : 0.5,
                  child: filledBtnWTxt(
                    btnTxt: Strings.continueTxt,
                    isLoading: scpc.isLoading,
                    onTap: scpc.isLoading
                        ? null
                        : () => scpc.onTapContinue(chooseSubPlanFormKey),
                  ).getcm,
                ),
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
            // Text(
            //   ,
            //   textAlign: TextAlign.center,
            //   style: 22.titleMclrCusFSOutfit,
            // ),
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

            Gap(itemGap * 15),
          ],
        ).getcm,
      ),
    );
  }
}
