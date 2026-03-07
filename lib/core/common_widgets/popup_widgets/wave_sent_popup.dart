import 'package:mama_app/core/common_widgets/small_popup_dialog.dart';

import '../../../app/helper_widgets_export.dart';

class WaveSentPopup extends StatelessWidget {
  const WaveSentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        children: [
          SvgIcon(iconPath: IconsPath.largeTick, height: S.w * 0.18),

          Gap(itemGap * 2),
          Text(
            Strings.waveSent.capEachWord(),
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
          ),
          Gap(4),
          Text(Strings.waveBackToChat, style: TxtStyle.inter(fs: 12, color: c.primary)),
        ],
      ),
    );
  }
}
