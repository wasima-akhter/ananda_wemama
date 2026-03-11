import 'package:mama_app/core/common_widgets/small_popup_dialog.dart';

import '../../../app/helper_widgets_export.dart';

class DailyLimitPopup extends StatelessWidget {
  const DailyLimitPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(iconPath: IconsPath.info, height: 22),

              Gap(itemGap * 2),
              Text(
                Strings.dailyWaveLimitReached.capEachWord(),
                style: TxtStyle.interSemiB(fs: 14, w: 700, color: c.primary),
              ),
            ],
          ),
          Gap(4),
          Text(Strings.waveResetAtMidnight, style: TxtStyle.inter(fs: 12, color: c.primary)),

          Text(Strings.getPremiumUnlimitedWaves, style: TxtStyle.inter(fs: 12, color: c.primary)),
        ],
      ),
    );
  }
}
