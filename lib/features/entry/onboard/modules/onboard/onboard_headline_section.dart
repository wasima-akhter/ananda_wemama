import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/safe_asset_image/safe_image_asset.dart';

class OnboardHeadlineSection extends StatelessWidget {
  const OnboardHeadlineSection({super.key});

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
            Strings.motherhoodSupportLine,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: ScreenSizeX.isTablet
                  ? 22.sp
                  : ScreenSize.isTallHeight
                  ? 35.sp
                  : 32.sp,
              letterSpacing: -0.1,
              color: c.foregroundSecondary,
              fontWeight: FontWeight.w400,
              height: ScreenSize.isTallHeight ? 1.3 : 1.2,
            ),
          ),
        ),

        Container(
          // color: Colors.orange,
          child: SafeAssetImage(
            assetPath: ImagesPath.onboardScreenHeart,
            width: S.w * 0.9,
            // height: cfg.height * 0.04,
            fit: BoxFit.contain,
          ),
        ),

        Container(
          // color: Colors.white,
          margin: EdgeInsets.only(bottom: ScreenSize.isTallHeight ? 10.h : 0.h),
          child: Text(
            Strings.builtForMotherhoodStages,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: ScreenSizeX.isTablet
                  ? 12.sp
                  : ScreenSize.isTallHeight
                  ? 13.5.sp
                  : 12.5.sp,
              height: 1.3,
              letterSpacing: 0.64,
              color: c.foregroundSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
