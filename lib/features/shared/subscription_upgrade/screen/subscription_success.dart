// subscription_confirm_screen.dart
import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/subscription_confirm_controller.dart';
import '../model/subscription_price_model.dart';

class SubscriptionSuccess extends StatelessWidget {
  const SubscriptionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final priceModel = Get.arguments as SubscriptionPriceModel;
    final ctrl = Get.put(SubscriptionConfirmController(priceModel));

    return AppScreenTemplate(
      // appBar: CommonAppBarContent(title: "", onTapBack: () => Get.back()),
      floatingActionButton: Obx(
        () => Container(
          padding: 20.pa,
          color: c.buttonText,
          child: AuthButton(
            btnText: "Explore premium",
            isLoading: ctrl.isProcessing.value,
            onTap: ctrl.isProcessing.value ? null : ctrl.onConfirmPayment,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeAssetImage(assetPath: Assets.images.promoCodeImage.path),

          Gap(itemGap),
          SvgIcon(iconPath: Assets.icons.tickL, height: 30),

          Gap(itemGap),
          Text("Payment Successful", style: TxtStyle.outfitSemiBold12Center()),
          Gap(itemGap),
          Text(
            "Welcome to WeMama Premium",
            style: TxtStyle.outfitSemiBold12Center(fs: 22),
          ),
          Gap(itemGap),
          Text(
            "You have now access to all premium features.",
            style: TxtStyle.outfitSemiBold12Center(fs: 22),
          ),
          Gap(itemGap * 2),
        ],
      ).getcm,
    );
  }
}
