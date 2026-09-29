import '../../../../app/helper_widgets_export.dart';
import '../../ui/dialogs/small_popup_dialog.dart';

class DailyLimitPopup extends StatelessWidget {
  const DailyLimitPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgIcon(iconPath: IconsPath.info, height: 22),

                Gap(itemGap),
                Text(
                  Strings.dailyWaveLimitReached.capEachWord(),
                  style: TxtStyle.interSemiB(fs: 14, w: 700, color: c.primary),
                ),
              ],
            ),
            Gap(4),
            Text(
              Strings.waveResetAtMidnight,
              style: TxtStyle.inter(fs: 12, color: c.primary),
            ),

            Text(
              Strings.getPremiumUnlimitedWaves,
              style: TxtStyle.inter(fs: 12, color: c.primary),
            ),
          ],
        ),
      ),
    );
  }
}
