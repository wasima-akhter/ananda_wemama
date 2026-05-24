import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/layout/bg_image_container.dart';
import '../controller/onboard_controller.dart';
import '../widgets/onboard_layout_config.dart';
import '../widgets/security_text.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    findCont<OnboardController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: c.scaffoldBackground,
        extendBodyBehindAppBar: true,
        body: BgImageContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cfg = OnboardLayoutConfig(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              );

              return BounceSingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: cfg.height),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TopSection(cfg: cfg),

                      Container(
                        child: Image.asset(
                          ImagesPath.onboardingImage,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      _BottomSection(cfg: cfg),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top Section
// ─────────────────────────────────────────────

class _TopSection extends StatelessWidget {
  const _TopSection({required this.cfg});

  final OnboardLayoutConfig cfg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gap(itemGap),
        weMamaLogoWithTxt,
        Gap(itemGap * 1.5),
        SecurityText(
          iconPath: IconsPath.shieldFill,
          text: Strings.womenOnlySpace.toUpperCase(),
          fs: 10,
        ),
        Gap(itemGap),
        Container(
          child: Text(
            Strings.motherhoodSupportLine,
            textAlign: TextAlign.center,
            style: TxtStyle.interSemiB(fs: 22, w: 600, color: c.primary),
            // style: cfg.titleFs.titleMclrCusFS,
          ),
        ),
        // Gap(4.w),
        SafeAssetImage(
          assetPath: ImagesPath.onboardScreenHeart,
          width: S.w * 0.9,
          height: cfg.height * 0.05,
          fit: BoxFit.contain,
        ),
        Text(
          Strings.builtForMotherhoodStages,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(fs: 13, w: 400, color: c.primary),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Section
// ─────────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.cfg});

  final OnboardLayoutConfig cfg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomBtnWTxt(
          w: cfg.btnW,
          btnTxt: Strings.getStarted,
          isUppCase: true,
          isLoading: false,
          style: TxtStyle.outfitSemiB(fs: 14, w: 600, color: white),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          onTap: () => Get.toNamed(RoutePaths.onboardScreen2),
        ),
        Gap(itemGap * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.alreadyHaveAnAccount,
              style: TxtStyle.outfit(
                fs: cfg.isTablet ? 17 : 14,
                color: black,
                w: 400,
              ),
            ),
            Gap(itemGap),
            CusGestureDetector(
              onTap: () => Get.toNamed(RoutePaths.signin),
              child: ContainerBordered(
                child: Text(
                  Strings.loginWithSpace.capEachWord(),
                  style: cfg.loginFs.titleMclrCusFS,
                ),
              ),
            ),
          ],
        ),
        Gap(itemGap * 0.5),
        SecurityText(
          rad: 8,
          bgClr: c.inputBackground,
          fs: 11,
          iconH: 18,
          iconPath: IconsPath.shieldCheck,
          text: Strings.yourPrivacyIsOurPriority.capEachWord(),
        ),
        Gap(itemGap * 2),
      ],
    );
  }
}
