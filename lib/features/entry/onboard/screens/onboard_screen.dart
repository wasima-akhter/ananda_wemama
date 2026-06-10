import 'package:google_fonts/google_fonts.dart';
import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/buttons/custom_btn_w_icon.dart';
import '../../../../core/components/ui/helpers/shapes/custom_divider.dart';
import '../../../../core/components/ui/layout/bg_image_container.dart';
import '../controller/onboard_controller.dart';
import '../widgets/onboard_layout_config.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    findCont<OnboardController>();

    return SafeArea(
      top: false,
      bottom: false,
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

                      SafeAssetImage(
                        assetPath: ImagesPath.onboardingImage,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
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
        weMamaLogoWithTitle,
        Gap(2),
        Text(
          Strings.motherhoodTogether,
          textAlign: TextAlign.center,
          style: TxtStyle.outfitSemiB(
            fs: 11,
            w: 500,
            color: c.foregroundPrimary,
            ls: 0.56,
            h: 1.0,
          ),
        ),

        Gap(itemGap * 2),

        Container(
          padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 14.w),
          decoration: BoxDecoration(
            borderRadius: 30.brdrRad,
            // color: c.backgroundSecondary,
            color: Color(0xFFFDECE4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIcon(iconPath: Assets.icons.shieldFill, height: 22),
              Gap(4),
              Text(
                Strings.womenOnlySpace.toUpperCase(),
                style: TxtStyle.inter(fs: 10),
              ),
            ],
          ),
        ),
        Gap(itemGap * 2),
        Text(
          Strings.motherhoodSupportLine,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 32.sp,
            color: c.foregroundSecondary,
            fontWeight: FontWeight.w400,
            height: 1.2, // line-height: 100%
            letterSpacing: 0.0,
          ),
        ),
        Gap(4),
        SafeAssetImage(
          assetPath: ImagesPath.onboardScreenHeart,
          width: S.w * 0.9,
          height: cfg.height * 0.05,
          fit: BoxFit.contain,
        ),
        Container(
          // color: Colors.amber,
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            Strings.builtForMotherhoodStages,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 12.5.sp,
              height: 1.3,
              letterSpacing: 0.64,
              color: c.foregroundSecondary,
            ),
          ),
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
        CustomBtnWIcon(
          text: Strings.getStarted,
          bgColor: c.strokePrimary,
          textColor: c.backgroundPrimary,
          iconPath: IconsPath.arrowRightLg,
          iconPosition: IconPosition.right,
          onTap: () => Get.toNamed(RoutePaths.onboardScreen2),
        ),
        Gap(itemGap * 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.alreadyHaveAnAccount,
              style: TxtStyle.outfitSemiB(
                fs: 14,
                // w: 400,
                h: 1.0,
                ls: 0,
                color: Colors.black,
              ),
            ),
            CusGestureDetector(
              onTap: () => Get.toNamed(RoutePaths.signin),
              child: ContainerBordered(
                child: Column(
                  children: [
                    Text(
                      Strings.loginWithSpace.capEachWord(),
                      style: TxtStyle.outfitSemiB(
                        fs: 14,
                        w: 600,
                        h: 1.0,
                        ls: 0,
                        color: c.primary,
                        // dec: TextDecoration.underline,
                      ),
                    ),
                    CustomDivider(w: 50, h: 1, clr: c.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(itemGap * 1),

        Container(
          padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: 8.brdrRad,
            color: c.backgroundSecondary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgIconColored(
                iconPath: IconsPath.shieldCheck, // iconPath
                height: 22, // iconH
              ),
              Gap(4), // spacing
              Text(
                Strings.yourPrivacyIsOurPriority.capEachWord(), // text
                style: TxtStyle.inter(
                  fs: 10,
                  w: 400,
                  h: 1.0,
                  ls: 0,
                  color: c.primary,
                ),
              ),
            ],
          ),
        ),
        Gap(itemGap),
      ],
    ).mHV(18, 0);
  }
}
