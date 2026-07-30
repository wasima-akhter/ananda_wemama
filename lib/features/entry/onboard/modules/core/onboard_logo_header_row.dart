import '../../../../../app/helper_widgets_export.dart';
import '../onboard/onboard_logo_section.dart';

class OnboardLogoHeaderRow extends StatelessWidget {
  final void Function()? onTap;
  final double? height;
  final bool hasBack;
  const OnboardLogoHeaderRow({
    super.key,
    this.onTap,
    this.height,
    this.hasBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button (left aligned)
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: hasBack
                ? CusGestureDetector(
                    onTap:
                        onTap ??
                        () {
                          Get.back();
                        },
                    child: Container(
                      // color: Colors.amber,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      child: SvgIconColored(
                        iconPath: IconsPath.arrowBackSmall,
                        height: 14,
                      ),
                    ),
                  )
                : SizedBox(width: 14),
          ),
        ),

        // Center logo
        Expanded(flex: 5, child: OnboardLogoSection(height: height)),

        // Right spacer (for balance)
        const Expanded(child: SizedBox(width: 48)),
      ],
    );
  }
}

class LogoPartHeader extends StatelessWidget {
  const LogoPartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [OnboardLogoHeaderRow()],
    );
  }
}

class BrandedHeaderSection extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final Color? subtitleTextColor;
  const BrandedHeaderSection({
    super.key,
    required this.titleText,
    required this.subtitleText,
    this.subtitleTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OnboardLogoHeaderRow(),
        Gap(10.h),
        // Welcome tetxt
        Text(
          titleText.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.dmSerifDisplayRegular(),
        ),

        Gap(itemGap),
        if (subtitleText.isNotEmpty)
          Text(
            subtitleText.capEachWord(),
            textAlign: TextAlign.center,
            style: TxtStyle.poppinsSemiBold12Center(color: subtitleTextColor),
          ),
      ],
    );
  }
}
