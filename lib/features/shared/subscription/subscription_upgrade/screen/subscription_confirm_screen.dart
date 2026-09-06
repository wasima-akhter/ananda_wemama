// subscription_confirm_screen.dart
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/entry/onboard/modules/core/onboard_logo_header_row.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';
import '../service/purchase_service.dart';
import '../type/offer_type.dart';

class SubscriptionConfirmScreen extends StatelessWidget {
  const SubscriptionConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eligibility = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(eligibility));

    return AppScreenTemplate(
      // appBar: CommonAppBarContent(
      //   title: "Payment",
      //   onTapBack: () => Get.back(),
      // ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(10),

          Obx(() {
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
            ).getcm;
          }),

          Gap(10),
        ],
      ),

      child: Obx(() {
        if (ctrl.isLoadingOption.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final rows = ctrl.priceRows;

        final currentOffer = ctrl.currentOffer;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (kDebugMode || !kDebugMode) ...[
              const Gap(50),

              _ConfirmHeader(),
              const SizedBox(height: 18),

              _PremiumInfoCard(rows: rows),
              const SizedBox(height: 10),

              _CurrentOfferCard(currentOffer: currentOffer),
              const SizedBox(height: 20),

              _ConfirmedPaymentSummary(rows: rows),

              const Gap(8),
              _SecurepPaymentMessage(),

              const Gap(8),
              // _BottomIllustration(),
            ],

            Gap(itemGap * 2),

            if (ctrl.errorMessage.value.isNotEmpty) ...[
              Gap(itemGap * 2),

              _ErrorRetryBanner(
                message: ctrl.errorMessage.value,

                onRetry: ctrl.onConfirmPayment,
              ),
            ],
          ],
        );
      }),
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

Widget _priceRow(PriceRowData row) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          row.label,
          style: TxtStyle.outfit(
            fs: row.isBold ? 17 : 14,
            color: row.isDiscount ? Colors.deepPurple : null,
            w: row.isBold ? 700 : 500,
          ),
        ),
        Text(
          row.formattedPrice,
          style: TxtStyle.outfit(
            fs: row.isBold ? 17 : 14,
            w: row.isBold ? 700 : 500,
            color: row.isDiscount ? Colors.deepPurple : null,
          ),
        ),
      ],
    ),
  );
}

class _ConfirmHeader extends StatelessWidget {
  const _ConfirmHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(10),
        OnboardLogoHeaderRow(hasBack: true, height: S.h * 0.1),

        const SizedBox(height: 20),

        Text("Complete Your Payment", style: TxtStyle.outfit(fs: 20, w: 700)),

        const SizedBox(height: 6),

        Text(
          "You're one step away from your village.",
          style: TxtStyle.poppinsSemiBold12Center(
            w: 500,
            color: c.foregroundSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    ).getcm;
  }
}

class _PremiumInfoCard extends StatelessWidget {
  final List<PriceRowData> rows;
  const _PremiumInfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xffF9EFE7),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: Color(0xff8B5A2B),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Premium Membership",
                      style: TxtStyle.outfit(fs: 13, color: c.primary, w: 600),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Unlimited support, expert sessions, and so much more.",
                          style: TxtStyle.outfit(
                            fs: 13,
                            color: c.foregroundSecondary,
                          ),
                        ),
                      ),

                      Gap(10),

                      SizedBox(
                        width: 100.w, // your available price area width
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: rows.first.formattedPrice
                                      .split('/')
                                      .first,
                                  style: TxtStyle.outfit(fs: 18, w: 700),
                                ),
                                if (rows.first.formattedPrice.contains('/'))
                                  TextSpan(
                                    text:
                                        '\n/${rows.first.formattedPrice.split('/').last}',
                                    style: TxtStyle.outfit(fs: 14, w: 700),
                                  ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).getcm;
  }
}

class _CurrentOfferCard extends StatelessWidget {
  final OfferType currentOffer;
  const _CurrentOfferCard({super.key, required this.currentOffer});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.deepPurple.shade200,
      strokeWidth: 1.2,
      dashPattern: const [6, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple.shade50,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
              child: Icon(Icons.card_giftcard, color: Colors.deepPurple),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Offer",
                    style: TxtStyle.outfitSemiB(
                      fs: 13,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    currentOffer.name.cap,
                    style: TxtStyle.outfit(fs: 18, w: 700),
                  ),

                  Text(
                    currentOffer == OfferType.none
                        ? "Unlock special savings by applying a promo code"
                        : "Your exclusive offer is ready to enjoy",
                    style: TxtStyle.outfit(fs: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).getcm;
  }
}

class _ConfirmedPaymentSummary extends StatelessWidget {
  final List<PriceRowData> rows;
  const _ConfirmedPaymentSummary({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffFFFAF5), // warm cream like screenshot
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffF3E5DA), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TxtStyle.outfit(fs: 20, w: 700),
          ).mHV(12, 4),

          if (rows.length > 1) ...[
            ...rows.take(rows.length - 1).map(_priceRow),

            const Divider().mHV(10, 0),

            _priceRow(rows.last),
          ] else
            ...rows.map(_priceRow),
        ],
      ),
    ).getcm;
  }
}

class _SecurepPaymentMessage extends StatelessWidget {
  const _SecurepPaymentMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.verified_user_outlined, size: 18, color: Colors.brown),

        const SizedBox(width: 6),

        Text(
          "Your payment is secure and encrypted.",
          style: TxtStyle.outfit(fs: 13, color: Colors.grey),
        ),
      ],
    );
  }
}

class _BottomIllustration extends StatelessWidget {
  const _BottomIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafeAssetImage(
            assetPath: Assets.images.promoCodeImage.path,
            height: 120,
          ),

          const SizedBox(width: 14),
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
