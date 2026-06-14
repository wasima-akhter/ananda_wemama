import '../../../../../app/helper_widgets_export.dart';
import '../onboard2/onboard2_features_section.dart';
import '../onboard2/onboard2_top_section.dart';

class Pageview1 extends StatelessWidget {
  const Pageview1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),
        // Expanded(flex: 7, child: Onboard2TopSection()),
        Onboard2TopSection(),
        Gap(ScreenSize.isSmallWidth ? 10.h : 20.h),
        Onboard2FeaturesSection(),
        // Expanded(
        //   flex: ScreenSize.isSmallWidth ? 14 : 12,
        //   child: Onboard2FeaturesSection(),
        // ),
      ],
    );
  }
}
