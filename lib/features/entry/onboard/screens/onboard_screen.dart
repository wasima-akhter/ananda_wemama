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
            child: BounceSingleChildScrollView(
              child: Column(
                spacing: itemGap,

                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(itemGap * 3),

                  weMamaLogoWithTxt,
                  Gap(itemGap),

                  SecurityText(iconPath: IconsPath.shieldFill, text: Strings.womenOnlySpace),

                  Gap(itemGap),
                  FittedBox(
                    child: Text(
                      Strings.motherhoodSupportLine,
                      textAlign: TextAlign.center,
                      style: 17.titleMclrCusFS,
                    ).mHV(20, 0),
                  ),
                  Text(
                    Strings.builtForMotherhoodStages,
                    textAlign: TextAlign.center,
                    style: 12.titleMclrCusFS,
                  ).mHV(40, 0),

                  Gap(itemGap),

                  Image.asset(ImagesPath.onboardingImage),

                  Gap(itemGap),

                  CustomBtnWTxt(
                    w: S.w * 0.6,
                    btnTxt: Strings.getStarted,
                    isUppCase: true,
                    onTap: () {
                      Get.toNamed(RoutePaths.onboardScreen2);
                    },
                    isLoading: false,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        Strings.alreadyHaveAnAccount,
                        style: TxtStyle.outfit(fs: 15, color: black, w: 500),
                      ),
                      Gap(itemGap),
                      CusGestureDetector(
                        onTap: () {
                          //
                          Get.toNamed(RoutePaths.signin);
                        },
                        child: ContainerBordered(
                          child: Text(
                            Strings.loginWithSpace.capEachWord(),
                            style: 12.titleMclrCusFS,
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
    return IntrinsicWidth(
      child: ContainerBordered(
        vp: 2,
        hp: 10,
        rad: 30,
        contClr: c.primary.withOpacity(0.05),
        child: Row(
          children: [
            SvgIcon(iconPath: iconPath, height: 28),

            Gap(4),
            Expanded(
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TxtStyle.inter(fs: 12, color: c.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
