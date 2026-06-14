import '../../../../../app/helper_widgets_export.dart';
import '../../modules/core/onboard_heart_icon.dart';
import '../../modules/onboard2/onboard2_headline_section.dart';

class Onboard2TopSection extends StatelessWidget {
  const Onboard2TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10.h,
      children: [
        // OnboardLogoHeaderRow(),
        Container(
          //color: Colors.blue,
          child: Onboard2HeadlineSection(),
        ),

        Container(
          // color: Colors.grey,
          child: OnboardHeartIcon(),
        ),
      ],
    );
  }
}
