import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/helper_widgets_export.dart';

class OnboardFeatureCard extends StatelessWidget {
  const OnboardFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          SvgIcon(iconPath: icon, height: ScreenSize.isSmallWidth ? 45 : 60),

          Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: poppinsSemiBold18()),

                SizedBox(height: ScreenSize.isSmallWidth ? 4.h : 6.h),

                Text(subtitle, style: poppinsMedium16()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle poppinsMedium16({Color? color}) {
  return GoogleFonts.poppins(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: ScreenSize.isSmallWidth ? 1.4 : 1.6,
    letterSpacing: 0.0,
    color: color ?? c.foregroundSecondary.withValues(alpha: 0.8),
  );
}

TextStyle poppinsSemiBold18({Color? color}) {
  return GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0.0,
    color: color ?? c.foregroundSecondary,
  );
}
