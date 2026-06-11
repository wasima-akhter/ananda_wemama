import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/helper_widgets_export.dart';

class Onboard2HeadlineSection extends StatelessWidget {
  const Onboard2HeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 2.h,
      children: [
        Container(
          // color: Colors.grey,
          child: Text(
            Strings.builtForWomen,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: ScreenSize.isTallHeight ? 32.sp : 30.sp,
              letterSpacing: -0.1,
              color: c.foregroundSecondary,
              fontWeight: FontWeight.w400,
              height: ScreenSize.isTallHeight ? 1.4 : 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
