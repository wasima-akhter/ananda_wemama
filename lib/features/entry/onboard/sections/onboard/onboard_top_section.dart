import '../../../../../app/helper_widgets_export.dart';
import '../../modules/onboard/onboard_headline_section.dart';
import '../../modules/onboard/onboard_logo_section.dart';
import '../../modules/onboard/onboard_women_only_badge.dart';
import '../../widgets/onboard/onboard_layout_config.dart';

class OnboardTopSection extends StatelessWidget {
  const OnboardTopSection({super.key, required this.cfg});

  final OnboardLayoutConfig cfg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   // flex: 9,
              //   child: Column(children: [OnboardLogoSection()]),
              // ),
              Column(
                children: [
                  Gap(MediaQuery.of(context).padding.top),
                  OnboardLogoSection(),
                ],
              ), // const Spacer(),
              // Expanded(
              //   // flex: 3,
              //   child: Column(children: [OnboardWomenOnlyBadge()]),
              // ),
              Gap(ScreenSize.isSmallWidth ? 0 : 12.h),
              Container(
                // color: Colors.green,
                child: OnboardWomenOnlyBadge(),
              ),
              Gap(ScreenSize.isSmallWidth ? 0 : 12.h),

              OnboardHeadlineSection(),
            ],
          ),
        ),
        // Expanded(
        //   child: Container(
        //     color: Colors.green,
        //     child: OnboardHeadlineSection(cfg: cfg),
        //   ),
        // ),
      ],
    );
  }
}
