import '../../../../../app/helper_widgets_export.dart';
import '../onboard/onboard_logo_section.dart';

class OnboardLogoHeaderRow extends StatelessWidget {
  final void Function()? onTap;
  const OnboardLogoHeaderRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button (left aligned)
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: CusGestureDetector(
              onTap:
                  onTap ??
                  () {
                    Get.back();
                  },
              child: SvgIconColored(
                iconPath: IconsPath.arrowBackSmall,
                height: 14,
              ),
            ),
          ),
        ),

        // Center logo
        const Expanded(flex: 5, child: OnboardLogoSection()),

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
