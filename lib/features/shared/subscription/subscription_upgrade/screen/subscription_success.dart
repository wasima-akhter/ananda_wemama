// subscription_confirm_screen.dart
import 'package:google_fonts/google_fonts.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../entry/onboard/modules/core/onboard_logo_header_row.dart';

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
          onTap: () => Get.offAllNamed(RoutePaths.finishSettingProfile),
        ),
      ),
      child: SafeArea(
        /*
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
     */
        child: Column(
          children: [
            Gap(10),
            OnboardLogoHeaderRow(hasBack: false, height: S.h * 0.1).getcm,
            Gap(10),
            SafeAssetImage(
              assetPath: Assets.images.paySuccessWebp.path,
              height: S.h * 0.2,
            ).marginSymmetric(horizontal: 20),

            const Gap(10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffEAF5E5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xff6FAF52),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Payment Successful!",
                    style: TxtStyle.outfitSemiB(
                      fs: 14,
                      color: const Color(0xff4F7E38),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(12),

            Text(
              "Welcome to\nWeMama Premium!",
              textAlign: TextAlign.center,
              style: TxtStyle.dmSerifDisplayRegular(
                color: c.primary,
                height: 1.2,
              ),
            ),

            const Gap(10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "You now have full access to all premium \nfeatures and a community that's here \nfor you, every step of the way.",
                textAlign: TextAlign.center,
                style: TxtStyle.poppinsSemiBold12Center(
                  w: 500,
                  color: c.foregroundSecondary.withValues(alpha: 0.8),
                ),
                //  TxtStyle.outfit(color: greyLoc),
              ),
            ),

            const Gap(28),

            _PremiumBenefitsCard(),

            const Gap(40),
          ],
        ),
      ),
    );
  }
}

class _PremiumBenefitsCard extends StatelessWidget {
  const _PremiumBenefitsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: _BenefitItem(
                  Icons.workspace_premium_outlined,
                  "Expert\nSessions",
                ),
              ),
              _divider(),

              const Expanded(
                child: _BenefitItem(Icons.forum_outlined, "Real\nSupport"),
              ),
              _divider(),

              const Expanded(
                child: _BenefitItem(Icons.menu_book_outlined, "Mood\nLibrary"),
              ),
              _divider(),

              const Expanded(
                child: _BenefitItem(Icons.bookmark_border, "Save &\nTrack"),
              ),
              _divider(),

              const Expanded(
                child: _BenefitItem(
                  Icons.favorite_border,
                  "A Village\nThat Gets It",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You're not alone. You're home.",
                style: GoogleFonts.allura(fontSize: 24.sp, color: c.primary),
              ),
              const SizedBox(width: 6),
              Icon(Icons.favorite_border, size: 16.sp, color: c.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 1),
      color: const Color(0xFFE8E1DA),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BenefitItem(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: 45.w,
          // height: 45.w,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffFFF6F1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: c.primary, size: 28.w),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(fs: 11, color: c.primary),
        ),
      ],
    );
  }
}
