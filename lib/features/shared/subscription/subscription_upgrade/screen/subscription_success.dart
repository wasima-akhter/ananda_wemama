// subscription_confirm_screen.dart
import 'package:flutter/foundation.dart';
import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/features/auth/core/auth_button_templates.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';

class SubscriptionSuccess extends StatelessWidget {
  const SubscriptionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: ''),
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
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            SafeAssetImage(
              assetPath: Assets.images.paySuccess.path,
            ).marginAll(15),

            Gap(itemGap),
            Text(
              "Payment Successful",
              style: TxtStyle.outfitSemiB(fs: 16, color: c.primary),
            ),
            Gap(itemGap),
            Text(
              "Welcome to \nWeMama Premium",
              textAlign: TextAlign.center,
              style: TxtStyle.dmSerifDisplayRegular(
                color: c.primary,
                fs: ScreenSize.isSmallWidth ? 32 : 35,
              ),
            ),
            Gap(itemGap),
            Text(
              "You have now access to all premium features.",
              style: TxtStyle.outfitSemiB(fs: 14, w: 600, color: c.primary),
            ),
            Gap(itemGap * 2),
            if (kDebugMode)
              TextButton(
                onPressed: () => Get.toNamed(RoutePaths.mainNav),
                child: Text("to home"),
              ),
          ],
        ).getcm,
      ),
    );
  }
}
