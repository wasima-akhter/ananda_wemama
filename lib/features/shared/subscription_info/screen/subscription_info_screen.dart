import 'package:mama_app/features/shared/subscription_info/widgets/subs_prefrence_card.dart';
import 'package:mama_app/features/shared/subscription_info/widgets/subscription_info_card.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/subscription_info_controller.dart';
import '../modules/preference_title.dart';

class SubscriptionInfoScreen extends StatelessWidget {
  const SubscriptionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scpc = Get.find<SubscriptionInfoController>();

    final chooseSubPlanFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.subscription),

      child: Form(
        key: chooseSubPlanFormKey,
        child: Column(
          children: [
            CurrentSubscriptionCard(
              planName: "Yearly Plan Activated",
              price: "₦5,000 / Month",
              expireDate: "10 January 2027",
              nextBillingDate: "10 January 2027",
              onManageBilling: () {},
              onViewReceipt: () {},
            ),

            Gap(20),

            PreferencesCard(
              children: [
                Obx(
                  () => PreferenceTile(
                    title: "Push Notification",
                    subtitle: "Receive alerts for matches and messages",
                    value: scpc.pushNotification.value,
                    onChanged: scpc.togglePushNotification,
                  ),
                ),

                Gap(16),

                Obx(
                  () => PreferenceTile(
                    title: "Community Updates",
                    subtitle: "Receive alerts for community activities you follow",
                    value: scpc.communityUpdates.value,
                    onChanged: scpc.toggleCommunityUpdates,
                  ),
                ),

                Gap(16),

                Obx(
                  () => PreferenceTile(
                    title: "Invisible Mode",
                    subtitle: "Hide your profile from matching queue",
                    value: scpc.invisibleMode.value,
                    onChanged: scpc.toggleInvisibleMode,
                  ),
                ),
              ],
            ),
          ],
        ).getcm,
      ),
    );
  }
}
