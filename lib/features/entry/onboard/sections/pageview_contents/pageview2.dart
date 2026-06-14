import '../../../../../app/helper_widgets_export.dart';
import '../onboard3/onboard3_bottom_section.dart';
import '../onboard3/onboard3_map_overlay_item.dart';
import '../onboard3/onboard3_top_section.dart';

class Pageview2 extends StatelessWidget {
  const Pageview2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),
              Onboard3TopSection(),
              Gap(20.h),
              Column(
                children: [
                  Onboard3MapSection(),
                  Gap(ScreenSize.isSmallWidth ? 14.h : 16.h),
                  Onboard3BottomSection(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
