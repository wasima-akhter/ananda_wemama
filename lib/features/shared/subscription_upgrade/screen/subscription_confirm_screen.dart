// subscription_confirm_screen.dart
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';

class SubscriptionConfirmScreen extends StatelessWidget {
  const SubscriptionConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eligibility = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(eligibility));

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: "Confirm Subscription",
        onTapBack: () => Get.back(),
      ),
      bottomWidget: Obx(
        () => AuthButton(
          btnText: "Confirm And Pay",
          isLoading: ctrl.isProcessing.value,
          onTap: (ctrl.isProcessing.value || ctrl.selectedOption.value == null)
              ? null
              : ctrl.onConfirmPayment,
        ),
      ),
      child: Obx(() {
        if (ctrl.isLoadingOption.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(itemGap * 2),
            ...ctrl.priceRows.map(_priceRow),
            if (ctrl.priceRows.length > 1) const Divider(),
            if (ctrl.errorMessage.value.isNotEmpty) ...[
              Gap(itemGap * 2),
              _ErrorRetryBanner(
                message: ctrl.errorMessage.value,
                onRetry: ctrl.onConfirmPayment,
              ),
            ],
          ],
        ).getcm;
      }),
    );
  }

  Widget _priceRow(PriceRowData row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.label,
            style: TxtStyle.outfit(fs: 14, w: row.isBold ? 700 : 500),
          ),
          Text(
            row.formattedPrice,
            style: TxtStyle.outfit(
              fs: row.isBold ? 18 : 14,
              w: row.isBold ? 700 : 500,
              color: row.isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorRetryBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetryBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          Gap(itemGap),
          Expanded(
            child: Text(
              message,
              style: TxtStyle.outfit(fs: 13, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: TxtStyle.outfit(color: c.foregroundPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
