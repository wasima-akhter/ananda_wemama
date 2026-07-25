import '../../../../../app/helper_widgets_export.dart';
import '../controller/billing_history_controller.dart';

// billing_history.dart
class BillingHistory extends StatelessWidget {
  const BillingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BillingHistoryController());

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: 'Billing History'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(40),
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: c.foregroundSecondary,
          ),
          Gap(16),
          Text(
            'View your full billing history',
            style: TxtStyle.poppinsSemiB(),
          ),
          Gap(8),
          Obx(
            () => Text(
              controller.isAppStore
                  ? 'Purchase receipts and billing history are managed by the App Store.'
                  : 'Purchase receipts and billing history are managed by Google Play.',
              textAlign: TextAlign.center,
              style: TxtStyle.poppinsSemiB(
                fs: 12,
                color: c.foregroundSecondary,
              ),
            ),
          ),
          Gap(24),
          CusGestureDetector(
            onTap: controller.openStorePurchaseHistory,
            child: ContainerBordered(
              vp: 12,
              hp: 20,
              rad: 8,
              hasBrdr: true,
              child: Obx(
                () => Text(
                  controller.isAppStore
                      ? 'Open App Store History'
                      : 'Open Play Store History',
                  style: TxtStyle.poppinsSemiB(color: c.strokePrimary),
                ),
              ),
            ),
          ),
        ],
      ).getcm,
    );
  }
}
