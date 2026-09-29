import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/small_popup_dialog.dart';

class NewWavesReqAcceptPopup extends StatelessWidget {
  const NewWavesReqAcceptPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        children: [
          SvgIcon(iconPath: IconsPath.largeTick, height: S.w * 0.18),
          Gap(itemGap * 2),
          Text(
            Strings.reqAccepted,
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
            textAlign: TextAlign.center,
          ),
          Gap(4),
          Text(
            Strings.youCanStartChatting,
            style: TxtStyle.inter(fs: 12, color: c.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
