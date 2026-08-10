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
        border: Border.all(color: newBorderClr),
      ),
      child: Row(
        children: [
          SvgIcon(
            iconPath: icon,
            height: ScreenSizeX.isTablet
                ? 40
                : ScreenSize.isSmallWidth
                ? 38
                : 54,
          ),

          Gap(14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TxtStyle.poppinsSemiBold15(
                    fs: ScreenSizeX.isTablet
                        ? 11
                        : ScreenSize.isSmallWidth
                        ? 12
                        : 13,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),

                SizedBox(height: ScreenSize.isSmallWidth ? 4.h : 6.h),

                Text(
                  subtitle,
                  style: TxtStyle.poppinsMedium13(
                    fs: ScreenSizeX.isTablet
                        ? 10
                        : ScreenSize.isSmallWidth
                        ? 11
                        : 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
