import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';
import 'package:we_mama/features/auth/core/auth_form_fields_templates.dart';
import 'package:we_mama/features/auth/core/auth_scaffold.dart';
import 'package:we_mama/features/entry/onboard/modules/core/onboard_logo_header_row.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/themes/color/colors.dart';
import '../../../shared/subscription/subscription_upgrade/service/subscription_service.dart';
import '../../../shared/subscription/subscription_upgrade/type/offer_type.dart';
import '../controller/promo_code_controller.dart';

class FoundingMumCodeScreen extends StatelessWidget {
  const FoundingMumCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PromoCodeController.to;

    final mumStageFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(() {
        return AuthButton(
          isLoading: controller.isLoading,
          onTap: controller.onTapContinueFoundingMumScreen,
        ).mB(10);
      }),

      // appBar: CommonAppBarContent(title: Strings.mumsStage),
      child: Column(
        children: [
          OnboardLogoHeaderRow(
            height: (ScreenSize.isSmallWidth ? 60.h : 65.h),
          ).getcm,
          Gap(10.h),
          SafeAssetImage(
            assetPath: Assets.images.foundingMumCodeScreen.path,
            radius: 0,
            fit: BoxFit.fitWidth,
          ),

          if (kDebugMode || !kDebugMode) ...[
            Gap(itemGap * 2),

            TextButton(
              onPressed: () => Get.toNamed(RoutePaths.mainNav),

              child: const Text("Home"),
            ),

            Text(
              "DEBUG OFFER",
              style: TxtStyle.outfitSemiB(fs: 12, w: 700, color: Colors.red),
            ),

            Gap(10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _debugOfferButton(
                  title: "Normal",
                  offer: OfferType.none,
                  controller: controller,
                ),

                _debugOfferButton(
                  title: "Referral",
                  offer: OfferType.referral,
                  controller: controller,
                ),

                _debugOfferButton(
                  title: "Promo",
                  offer: OfferType.promo,
                  controller: controller,
                ),

                _debugOfferButton(
                  title: "Founding Mum",
                  offer: OfferType.foundingMum,
                  controller: controller,
                ),
              ],
            ),

            Gap(itemGap),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Gap(20),
                              Text(
                                "Enter your Founding Mum code",
                                textAlign: TextAlign.center,
                                style: TxtStyle.dmSerifDisplayRegular(
                                  fs: 23,
                                  ls: 0.1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //
                      ],
                    ),

                    Gap(itemGap),
                    Text(
                      "Use your unique code to unlock your \nFounding Mum access",
                      textAlign: TextAlign.center,
                      style: TxtStyle.outfitSemiBold12Center(w: 500),
                    ),
                  ],
                ),
              ),
            ],
          ).getcm,

          Gap(itemGap),

          Form(
            key: mumStageFormKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthFormNameField(
                  rad: 8,
                  nameCtrler: controller.referralCodeCtrl,
                  nameFocus: controller.referralCodeFocusNode,
                  hintText: "Enter Founding Mum Code",
                  hintColor: Colors.grey.shade400,
                ),
              ],
            ),
          ).getcm,
          Gap(itemGap),

          GestureDetector(
            onTap: () async {
              final data = await Clipboard.getData(Clipboard.kTextPlain);

              if (data?.text?.trim().isNotEmpty ?? false) {
                controller.referralCodeCtrl.text = data!.text!.trim();
                controller.unfocusAll();
              }
            },
            child: ContainerBordered(
              rad: 8,
              hasBrdr: true,
              brdrClr: Colors.grey.shade400,
              contClr: const Color(0xFFFDF4ED),
              vp: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(iconPath: Assets.icons.copyText, height: 18),
                  Gap(5),
                  Text(
                    "Paste From Clipboard",
                    style: TxtStyle.outfitSemiB(
                      color: appRed,
                      w: 600,
                      ls: 1.2,
                      fs: 12,
                    ),
                  ),
                ],
              ),
            ).getcm,
          ),
          Gap(itemGap * 1.5),
          GestureDetector(
            onTap: controller.onTapContinueFoundingMumScreen,
            child: Column(
              children: [
                Text(
                  "I don't have a code",
                  style: TxtStyle.outfitSemiB(
                    color: appRed,
                    w: 600,
                    ls: 1.2,
                    fs: 12,
                    h: 1,
                  ),
                ),
                Container(
                  color: appRed,
                  height: 1,
                  width: findTextWidth(
                    text: "I don't have a code",
                    style: TxtStyle.outfitSemiB(
                      color: appRed,
                      w: 600,
                      ls: 1.2,
                      fs: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(itemGap),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIcon(iconPath: Assets.icons.lockPrivacy, height: 18),
              Gap(5),
              Text(
                "Your Information is safe with us",
                style: TxtStyle.outfitSemiB(
                  w: 600,
                  fs: 11,
                  color: AppPalette.brown925,
                ),
              ),
            ],
          ),

          Gap(20),
        ],
      ),
    );
  }

  Widget _debugOfferButton({
    required String title,
    required OfferType offer,
    required PromoCodeController controller,
  }) {
    return ElevatedButton(
      onPressed: () async {
        controller.currentOffer.value = offer;
        controller.appliedCode.value = title;

        print("🟢 DEBUG OFFER = ${offer.name}");

        final eligibility = await SubscriptionService().getDiscountedPrice();

        if (eligibility == null) {
          Get.snackbar("Error", "Couldn't load subscription.");
          return;
        }

        Get.toNamed(
          RoutePaths.subscriptionConfirmScreen,
          arguments: eligibility,
        );
      },
      child: Text(title),
    );
  }
}
