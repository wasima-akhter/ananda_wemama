import '../../../../app/helper_widgets_export.dart';

class NewWavesReqAcceptPopup extends StatelessWidget {
const NewWavesReqAcceptPopup({ super.key });

  @override
  Widget build(BuildContext context){
    return  IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
        decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
        child: Column(
          children: [
            SvgIcon(iconPath: IconsPath.largeTick, height: S.w * 0.2),

            Gap(itemGap * 2),
            Text(
              Strings.reqAccepted,
              style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
            ),
            Gap(4),
            Text(
              Strings.youCanStartChatting,
              style: TxtStyle.inter(fs: 12, color: c.primary),
            ),
          ],
        ),
      ),
    ) 
  ;
  }
}