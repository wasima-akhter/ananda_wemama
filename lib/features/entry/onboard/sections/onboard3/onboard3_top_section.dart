import '../../../../../app/helper_widgets_export.dart';
import '../../modules/core/onboard_heart_icon.dart';
import '../../modules/onboard3/onboard3_headline_section.dart';

class Onboard3TopSection extends StatelessWidget {
  const Onboard3TopSection({super.key});

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
          child: Onboard3HeadlineSection(),
        ),

        Container(
          // color: Colors.grey,
          child: OnboardHeartIcon(
            height: ScreenSize.isSmallWidth ? 22.h : 15.h,
          ),
        ),

        //
        Text(
          Strings.motherhoodFeelsAlone,
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center().copyWith(
            // letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
