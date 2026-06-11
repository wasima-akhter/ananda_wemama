import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../modules/onboard2/onboard2_feature_card.dart';

class Onboard3TopSection extends StatelessWidget {
  const Onboard3TopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      spacing: 6.h,
      children: [
        Text(
          "Expert Guidance",
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 26.sp,
            fontWeight: FontWeight.w400,
            color: c.foregroundSecondary,
          ),
        ),

        Text(
          "Join live sessions with trusted experts.",
          textAlign: TextAlign.center,
          style: poppinsMedium16(),
        ),
      ],
    );
  }
}

TextStyle poppinsSemiBold16Center({Color? color}) {
  return GoogleFonts.poppins(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.04 * 16, // 4% = 0.64px
    textBaseline: TextBaseline.alphabetic,
    color: color ?? c.foregroundPrimary,
  );
}
