import '../../../../app/helper_widgets_export.dart';
import '../controller/onboard_controller.dart';
import '../modules/core/onboard_logo_header_row.dart';
import '../sections/onboard2/onboard2_bottom_section.dart';
import '../sections/onboard3/onboard3_top_section.dart';
import '../sections/onboard3/onboard_expert_guidance_section.dart';

/*
class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = findCont<OnboardController>();

    return AppScreenTemplate(
      bottomWidget: CustomBtnWTxt(
        btnTxt: Strings.continueTxt,
        isSmall: true,
        onTap: () => Get.toNamed(RoutePaths.onboardScreen3),
        isLoading: false,
      ),
      child: Stack(
        children: [
          Positioned(
            top: itemGap * 5,
            left: itemGap * 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SvgIconColored(
                iconPath: IconsPath.arrowBackSmall,
                iconColor: c.strokePrimary,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Gap(itemGap * 7),
              Image.asset(ImagesPath.weMamaLogoPng, height: S.w * 0.28),
              Gap(itemGap * 2),
              FittedBox(
                child: Text(
                  Strings.findMumsNearYou,
                  textAlign: TextAlign.center,
                  style: 15.titleMclrCusFS,
                ).mHV(20, 0),
              ),
              Gap(itemGap * 0.5),
              Text(
                Strings.friendshipSupportUnderstanding,
                textAlign: TextAlign.center,
                style: TxtStyle.outfitSemiB(fs: 12, w: 400, color: c.primary),
              ).mHV(40, 0),
              Gap(itemGap * 2),
              Image.asset(ImagesPath.onboarding2),
              Gap(itemGap * 2),
              CommunitySpotlight(isFromOnboardScreen: true),

              Gap(itemGap * 2),
            ],
          ).getcm,
        ],
      ),
    );
  }
}
*/
class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    findCont<OnboardController>();

    int getImageFlex() {
      if (ScreenSize.isTallHeight) {
        if (ScreenSize.isSmallWidth) return 12;
        if (ScreenSize.isMediumWidth || ScreenSize.isLargeWidth) return 9;
      }
      return 13;
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 20,
          backgroundColor: bgClrNew,
          leading: Container(),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ScreenSize.isSmallWidth ? 8.h : 20.h,
              ),
              child: Onboard2BottomSection().getcm,
            ),
          ],
        ),
        body: Container(
          // color: Colors.amber,
          child: Column(
            children: [
              // pageview builder 1st part
              //[
              // Expanded(flex: 13, child: Onboard2TopSection()),
              // Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),

              // Expanded(
              //   flex: ScreenSize.isSmallWidth ? 14 : 12,
              //   child:
              //       // pageview builder this part
              //       Onboard2FeaturesSection(),
              // ),
              //]

              // // pageview builder 2nd part
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [OnboardLogoHeaderRow()],
              // ),

              // Expanded(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),
              //       Onboard3TopSection(),
              //       Gap(20.h),
              //       Column(
              //         children: [
              //           Onboard3MapSection(),
              //           Gap(ScreenSize.isSmallWidth ? 14.h : 16.h),
              //           Onboard3BottomSection(),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              // // pageview builder 3rd part
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [OnboardLogoHeaderRow()],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),

                    const Onboard3TopSection(),

                    Gap(12.h),

                    const OnboardExpertGuidanceSection(),
                  ],
                ),
              ),
            ],
          ),
        ).getcm,
      ),
    );
  }
}
