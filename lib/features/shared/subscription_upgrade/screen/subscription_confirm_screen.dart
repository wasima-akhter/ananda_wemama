// subscription_confirm_screen.dart
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';

class SubscriptionConfirmScreen extends StatelessWidget {
  const SubscriptionConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final priceModel = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(priceModel));

    final discountAmount =
        (priceModel.originalPrice * priceModel.discount) / 100;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: "Confirm Subscription",
        onTapBack: () => Get.back(),
      ),
      bottomWidget: Obx(
        () => AuthButton(
          btnText: "Confirm And Pay",
          isLoading: ctrl.isProcessing.value,
          onTap: ctrl.isProcessing.value ? null : ctrl.onConfirmPayment,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap(itemGap * 2),
          _priceRow('Original Price', priceModel.originalPrice),
          if (priceModel.discount > 0)
            _priceRow(
              'Discount',
              discountAmount,
              isDiscount: true,
              isPercentage: true,
              percentage: priceModel.discount,
            ),

          const Divider(),
          _priceRow('Total', priceModel.finalPrice, isBold: true),
          Gap(itemGap * 3),
          Obx(() {
            if (ctrl.errorMessage.value.isEmpty) return const SizedBox.shrink();
            return _ErrorRetryBanner(
              message: ctrl.errorMessage.value,
              onRetry: ctrl.onConfirmPayment,
            );
          }),
        ],
      ).getcm,
    );
  }

  Widget _priceRow(
    String label,
    double value, {
    bool isDiscount = false,
    bool isBold = false,
    bool isPercentage = false,
    double? percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isPercentage
                ? "$label (${percentage?.toStringAsFixed(0)}%) "
                : label,
            style: TxtStyle.outfit(fs: 14, w: isBold ? 700 : 500),
          ),
          Text(
            isPercentage
                ? '-₦${value.toStringAsFixed(2)}'
                : '${isDiscount ? '-' : ''}₦${value.abs().toStringAsFixed(2)}',
            style: TxtStyle.outfit(
              fs: isBold ? 18 : 14,
              w: isBold ? 700 : 500,
              color: isDiscount ? Colors.green : null,
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
