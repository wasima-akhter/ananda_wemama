// subscription_confirm_screen.dart
import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';

class SubscriptionPending extends StatelessWidget {
  const SubscriptionPending({super.key});

  @override
  Widget build(BuildContext context) {
    final priceModel = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(priceModel));

    return AppScreenTemplate(
      floatingActionButton: Obx(
        () => Container(
          padding: 20.pa,
          color: c.buttonText,
          child: AuthButton(
            btnText: "Check Payment Status",
            isLoading: ctrl.isProcessing.value,
            onTap: ctrl.isProcessing.value ? null : ctrl.onConfirmPayment,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeAssetImage(assetPath: Assets.images.promoCodeImage.path),

          Gap(itemGap * 2),

          const Center(
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            ),
          ),

          Gap(itemGap * 2),

          Text(
            "Payment Pending",
            style: TxtStyle.outfitSemiBold12Center(fs: 22),
          ),

          Gap(itemGap),

          Text(
            "We're waiting for your payment confirmation.",
            style: TxtStyle.outfit(fs: 12),
          ),

          Gap(itemGap / 2),

          Text(
            "This usually takes a few moments. Please don't close the app. "
            "You can also tap the button below to check your payment status.",
            style: TxtStyle.outfit(fs: 12),
          ),

          Gap(itemGap * 2),
        ],
      ).getcm,
    );
  }
}
