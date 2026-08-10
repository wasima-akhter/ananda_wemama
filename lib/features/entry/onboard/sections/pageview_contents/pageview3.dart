import '../../../../../app/helper_widgets_export.dart';
import '../onboard4/onboard4_top_section.dart';
import '../onboard4/onboard_expert_guidance_section.dart';

class Pageview3 extends StatelessWidget {
  const Pageview3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [OnboardLogoHeaderRow()],
        // ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(
                ScreenSizeX.isTablet
                    ? 5.h
                    : ScreenSize.isSmallWidth
                    ? 10.h
                    : 20.h,
              ),
              const Onboard4TopSection(),
              Gap(ScreenSize.isSmallWidth ? 15.h : 18.h),
              const OnboardExpertGuidanceSection(),
            ],
          ),
        ),
      ],
    );
  }
}
