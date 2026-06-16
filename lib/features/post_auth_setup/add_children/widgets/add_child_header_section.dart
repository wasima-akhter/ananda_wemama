import '../../../../app/helper_widgets_export.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';

class AddChildrenHeaderSection extends StatelessWidget {
  const AddChildrenHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedHeaderSection(
      titleText: Strings.tellUsAboutChildren,
      subtitleText: Strings.sharingAboutChildren,
      subtitleTextColor: c.foregroundSecondary.withValues(alpha: 0.8),
    );
  }
}
