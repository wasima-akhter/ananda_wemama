// subscription_confirm_screen.dart
import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class SubscriptionSuccess extends StatelessWidget {
  const SubscriptionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      floatingActionButton: Container(
        padding: 20.pa,
        color: c.buttonText,
        child: AuthButton(
          isLoading: false,
          btnText: "Explore premium",
          onTap: () => Get.offAllNamed(RoutePaths.mainNav),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.mainNav),
              child: Text("to home"),
            ),
            SafeAssetImage(assetPath: Assets.images.promoCodeImage.path),
            Gap(itemGap),
            SvgIcon(iconPath: Assets.icons.tickL, height: 30),
            Gap(itemGap),
            Text(
              "Payment Successful",
              style: TxtStyle.outfitSemiBold12Center(),
            ),
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
      ),
    );
  }
}
