import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/bg_image_container.dart';
import '../controller/onboard_controller.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = findCont<OnboardController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: c.scaffoldBackground,
        extendBodyBehindAppBar: true,
        body: BgImageContainer(
          child: Container(
            color: c.scaffoldBackground,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                final isTablet = w >= 600;
                final isLarge = w >= 900;

                final hPadding = isLarge
                    ? w * 0.25
                    : isTablet
                    ? w * 0.15
                    : 0.0;
                final logoScale = isTablet ? 1.3 : 1.0;
                final titleFs = isTablet ? 22.0 : 17.0;
                final subFs = isTablet ? 15.0 : 12.0;
                final btnW = isTablet ? w * 0.4 : S.w * 0.6;
                final imageH = isTablet ? h * 0.35 : null;

                return BounceSingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPadding),
                    child: Column(
                      spacing: itemGap,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(itemGap * 3),

                        Transform.scale(scale: logoScale, child: weMamaLogoWithTxt),

                        Gap(itemGap),

                        SecurityText(iconPath: IconsPath.shieldFill, text: Strings.womenOnlySpace),

                        Gap(itemGap),

                        FittedBox(
                          child: Text(
                            Strings.motherhoodSupportLine,
                            textAlign: TextAlign.center,
                            style: (titleFs).titleMclrCusFS,
                          ).mHV(20, 0),
                        ),

                        Text(
                          Strings.builtForMotherhoodStages,
                          textAlign: TextAlign.center,
                          style: subFs.titleMclrCusFS,
                        ).mHV(isTablet ? 80.0 : 40.0, 0),

                        Gap(itemGap),

                        imageH != null
                            ? Image.asset(
                                ImagesPath.onboardingImage,
                                height: imageH,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(ImagesPath.onboardingImage),

                        Gap(itemGap),

                        CustomBtnWTxt(
                          w: btnW,
                          btnTxt: Strings.getStarted,
                          isUppCase: true,
                          onTap: () => Get.toNamed(RoutePaths.onboardScreen2),
                          isLoading: false,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.alreadyHaveAnAccount,
                              style: TxtStyle.outfit(fs: isTablet ? 17 : 15, color: black, w: 500),
                            ),
                            Gap(itemGap),
                            CusGestureDetector(
                              onTap: () => Get.toNamed(RoutePaths.signin),
                              child: ContainerBordered(
                                child: Text(
                                  Strings.loginWithSpace.capEachWord(),
                                  style: (isTablet ? 14.0 : 12.0).titleMclrCusFS,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SecurityText(
                          iconPath: IconsPath.shieldCheck,
                          text: Strings.yourPrivacyIsOurPriority,
                        ),

                        Gap(itemGap * 3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SecurityText extends StatelessWidget {
  final String iconPath;
  final String text;
  const SecurityText({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
      decoration: BoxDecoration(borderRadius: 30.brdrRad, color: c.primary.withOpacity(0.05)),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          SvgIcon(iconPath: iconPath, height: 28),
          Text(text.toUpperCase(), style: TxtStyle.inter(fs: 12, color: c.secondary)),
        ],
      ),
    );
  }
}
