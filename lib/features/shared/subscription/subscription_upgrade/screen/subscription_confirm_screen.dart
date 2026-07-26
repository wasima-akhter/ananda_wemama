// subscription_confirm_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';
import '../service/purchase_service.dart';

class SubscriptionConfirmScreen extends StatelessWidget {
  const SubscriptionConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eligibility = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(eligibility));

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: "Payment",
        onTapBack: () => Get.back(),
      ),
      bottomWidget: Obx(() {
        if (ctrl.isWaitingForRedemption.value) {
          return Column(
            children: [
              const Text(
                "Complete your redemption in the App Store, then come back here.",
              ),

              Gap(itemGap),

              TextButton(
                onPressed: () => PurchaseService.to.refreshCustomerInfo(),

                child: const Text("I've redeemed it — Check now"),
              ),
            ],
          );
        }

        return AuthButton(
          btnText: ctrl.confirmButtonText,

          isLoading: ctrl.isProcessing.value || ctrl.isLoadingOption.value,

          onTap:
              (ctrl.isProcessing.value ||
                  ctrl.isPurchaseBlocked ||
                  ctrl.isLoadingOption.value)
              ? null
              : ctrl.onConfirmPayment,
        );
      }),

      child: Obx(() {
        if (ctrl.isLoadingOption.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final rows = ctrl.priceRows;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (kDebugMode || !kDebugMode) ...[
              TextButton(
                onPressed: () => Get.toNamed(RoutePaths.mainNav),

                child: const Text("Home"),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 20),

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [
                    Text(
                      "Current Offer",
                      style: TxtStyle.outfit(fs: 13, w: 600),
                    ),

                    Gap(itemGap),

                    Text(
                      ctrl.currentOffer.name,

                      style: TxtStyle.outfit(
                        fs: 18,
                        w: 700,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(itemGap),

              // DEBUG TEST CODES
              // Wrap(
              //   alignment: WrapAlignment.center,
              //   spacing: 8,

              //   children: [
              //     _debugCodeButton("ref"),

              //     _debugCodeButton("promo"),

              //     _debugCodeButton("mum"),
              //   ],
              // ),
            ],

            Gap(itemGap * 2),

            ...rows.map(_priceRow),

            if (rows.length > 1) const Divider(),

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

  Widget _debugCodeButton(String code) {
    return TextButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: code));

        Get.snackbar(
          "Copied",
          "Code $code copied",
          snackPosition: SnackPosition.BOTTOM,
        );
      },

      child: Text(code),
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
