import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import '../../../../../gen/assets.gen.dart';

class AlreadyPremiumPopup extends StatelessWidget {
  const AlreadyPremiumPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
      decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
      child: BounceSingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeAssetImage(
              assetPath: Assets.images.paymentSuccess.path,
            ).marginAll(10),

            Gap(itemGap),

            Text(
              "You're Already",
              style: TxtStyle.outfitSemiB(fs: 16, color: c.primary),
            ),

            Gap(itemGap),

            Text(
              "WeMama\nPremium",
              textAlign: TextAlign.center,
              style: TxtStyle.dmSerifDisplayRegular(
                color: c.primary,
                fs: ScreenSize.isSmallWidth ? 30 : 34,
              ),
            ),

            Gap(itemGap),

            Text(
              "Your premium membership is already active.",
              textAlign: TextAlign.center,
              style: TxtStyle.outfitSemiB(fs: 14, w: 600, color: c.primary),
            ),

            Gap(6),

            Text(
              "Enjoy unlimited access to all premium features.",
              textAlign: TextAlign.center,
              style: TxtStyle.outfitSemiB(
                fs: 13,
                color: c.primary.withValues(alpha: .75),
              ),
            ),

            Gap(itemGap * 2),

            CustomBtnWTxt(
              btnTxt: "Explore Premium",
              btnColor: c.primary,
              isLoading: false,
              rad: 12,
              onTap: () {
                Get.back();
                Get.offAllNamed(RoutePaths.mainNav);
              },
            ),

            Gap(itemGap),

            CustomBtnWTxt(
              outlined: true,
              borderClr: c.secondary,
              btnColor: ctransp,
              btnTxt: "Close",
              rad: 12,
              isLoading: false,
              style: TxtStyle.outfitSemiB(
                fs: 12,
                color: c.primary.withValues(alpha: .7),
                w: 500,
              ),
              onTap: Get.back,
            ),
          ],
        ).getcm,
      ),
    );
  }
}
