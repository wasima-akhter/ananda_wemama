import '../../../../app/helper_widgets_export.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';

class MumsStageHeader extends StatelessWidget {
  const MumsStageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandedHeaderSection(
          titleText: Strings.motherhoodJourneyTitle,
          subtitleText: '',
        ),

        Text(
          Strings.motherhoodJourneySubtitle.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(
            fs: 12,
            color: c.foregroundSecondary.withValues(alpha: 0.8),
          ),
        ),

        Gap(itemGap),

        Text(
          Strings.motherhoodStageQuestion.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(),
        ),

        Text(
          Strings.selectAllThatApply.capEachWord(),
          textAlign: TextAlign.center,
          style: TxtStyle.poppinsSemiBold12Center(
            fs: 12,
            color: c.foregroundSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
