import '../../../../../app/helper_widgets_export.dart';
import '../onboard/onboard_logo_section.dart';

class OnboardLogoHeaderRow extends StatelessWidget {
  const OnboardLogoHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button (left aligned)
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SvgIconColored(iconPath: IconsPath.arrowBackSmall),
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
