import 'package:we_mama/core/helpers/date_helper.dart';
import 'package:we_mama/features/shared/subscription/subscription_info/widgets/subs_prefrence_card.dart';
import 'package:we_mama/features/shared/subscription/subscription_info/widgets/subscription_info_card.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/services/push_notification/push_notification_service.dart';
import '../controller/subscription_info_controller.dart';
import '../modules/preference_title.dart';

class SubscriptionInfoScreen extends StatelessWidget {
  const SubscriptionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scpc = SubscriptionInfoController.to;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.subscription),
      child: Obx(() {
        if (scpc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final info = scpc.subInfo.value;

        return Column(
          children: [
            // Text("For you to see if subscribed"),
            // CurrentSubscriptionCard(
            //   promoCodeTextController: scpc.promoCodeTextController,
            //   planName: 'WeMama Premium ',
            //   price: '\$9.99/month',
            //   expireDate: '31 Dec 2026',
            //   nextBillingDate: '31 Dec 2026',
            //   willRenew: true,
            //   onManageBilling: () {
            //     print('Manage Billing tapped');
            //   },
            //   onCancel: () {
            //     print('Cancel Subscription tapped');
            //   },
            //   onViewReceipt: () {
            //     print('View Receipt tapped');
            //   },
            // ),
            // Gap(30),

            ///
            ///
            ///
            ///
            Gap(10.h),
            if (info == null)
              _NoActiveSubscriptionCard(
                onSubscribe: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
              )
            else ...[
              CurrentSubscriptionCard(
                promoCodeTextController: scpc.promoCodeTextController,

                planName: scpc.activeProduct.value?.title ?? 'WeMama Premium',

                price: scpc.activeProduct.value?.priceString ?? '',

                expireDate: info.expiresAt != null
                    ? DateHelper()
                          .formatUTCtimestamp(info.expiresAt.toString())
                          .date
                    : '—',

                nextBillingDate: info.willRenew && info.expiresAt != null
                    ? DateHelper()
                          .formatUTCtimestamp(info.expiresAt.toString())
                          .date
                    : '',

                willRenew: info.willRenew,

                onManageBilling: scpc.onManageBilling,
                onCancel: scpc.onCancelSubscription,
                onViewReceipt: scpc.onViewReceipt,
              ),
              if (!info.willRenew)
                _CancellationNoticeBanner(expiresAt: info.expiresAt),

              Gap(20),

              TextButton.icon(
                onPressed: scpc.isRestoring.value
                    ? null
                    : scpc.onRestorePurchases,
                icon: scpc.isRestoring.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.restore, color: c.foregroundSecondary),
                label: Text(
                  'Restore Purchases',
                  style: TxtStyle.poppinsSemiB(
                    color: c.foregroundSecondary,
                    w: 600,
                  ),
                ),
              ),
            ],

            Gap(20),

            PreferencesCard(
              children: [
                Obx(
                  () => PreferenceTile(
                    title: "Push Notification",
                    subtitle: "Receive alerts for matches and messages",
                    value: PushNotificationService.to.isNotificationEnabled,
                    onChanged: scpc.togglePushNotification,
                  ),
                ),
                // Gap(16),
                // Obx(
                //   () => PreferenceTile(
                //     title: "Community Updates",
                //     subtitle:
                //         "Receive alerts for community activities you follow",
                //     value: scpc.communityUpdates.value,
                //     onChanged: scpc.toggleCommunityUpdates,
                //   ),
                // ),
                // Gap(16),
                // Obx(
                //   () => PreferenceTile(
                //     title: "Invisible Mode",
                //     subtitle: "Hide your profile from matching queue",
                //     value: scpc.invisibleMode.value,
                //     onChanged: scpc.toggleInvisibleMode,
                //   ),
                // ),
              ],
            ),
          ],
        ).getcm;
      }),
    );
  }
}

class _NoActiveSubscriptionCard extends StatelessWidget {
  final VoidCallback onSubscribe;
  const _NoActiveSubscriptionCard({required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 20,
      hp: 20,
      contClr: c.backgroundSecondary,
      child: Column(
        children: [
          const Icon(Icons.workspace_premium_outlined, size: 40),
          Gap(10),
          Text('No active subscription', style: TxtStyle.poppinsSemiB()),
          Gap(8),
          Text(
            'Subscribe to unlock premium features',
            textAlign: TextAlign.center,
            style: TxtStyle.poppinsSemiB(fs: 10),
          ),
          Gap(16),
          CusGestureDetector(
            onTap: onSubscribe,
            child: ContainerBordered(
              vp: 8,
              rad: 8,
              hasBrdr: true,
              child: Text(
                'View Plans',
                style: TxtStyle.poppinsSemiB(color: c.strokePrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancellationNoticeBanner extends StatelessWidget {
  final DateTime? expiresAt;
  const _CancellationNoticeBanner({this.expiresAt});

  @override
  Widget build(BuildContext context) {
    final timeModel = DateHelper().formatUTCtimestamp(expiresAt.toString());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 20),
          Gap(10),
          Expanded(
            child: Text(
              expiresAt != null
                  ? 'Your subscription is cancelled and will end on ${timeModel.date}, ${timeModel.time}.'
                  : 'Your subscription is cancelled and will not renew.',
              style: const TextStyle(fontSize: 12.5, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

/*
5. "View Receipt" — what's actually feasible
Neither store gives you a clean, in-app-displayable "receipt" object through RevenueCat's client SDK (it's raw platform receipt data, not meant for UI). The two real options:

Billing history from your own backend (recommended): since your webhook already records every INITIAL_PURCHASE/RENEWAL event with amount and date, expose a simple GET /subscription/billing-history endpoint and render it as a list — this is what "View Receipt" should point to.
Deep link to native purchase history as a fallback if you don't want to build that yet:
Future<void> onViewReceipt() async {
  final url = GetPlatform.isIOS
      ? 'https://apps.apple.com/account/subscriptions'
      : 'https://play.google.com/store/account/subscriptions';
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
*/
