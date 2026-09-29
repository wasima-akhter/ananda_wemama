import '../../../../app/helper_widgets_export.dart';

class WaveSentPopup extends StatelessWidget {
  final RxBool stopSearching;
  const WaveSentPopup({super.key, required this.stopSearching});

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
          Text(
            Strings.waveBackToChat,
            style: TxtStyle.inter(fs: 12, color: c.primary),
          ),

          Gap(itemGap * 2),
          Row(
            children: [
              Expanded(
                child: CustomBtnWTxt(
                  isLoading: false,
                  isSmall: true,
                  outlined: true,
                  btnTxt: Strings.stop.capEachWord(),
                  btnColor: ctransp,
                  txtClr: c.primary,
                  rad: 12,
                  padding: 12.pv,
                  onTap: () {
                    stopSearching.value = true;
                    Get.back();
                  }, // ← resolves the Future in showWaveSentDialog
                ),
              ),
              Gap(itemGap),
              Expanded(
                child: CustomBtnWTxt(
                  isLoading: false,
                  isSmall: true,
                  btnTxt: Strings.continueSearching.capEachWord(),
                  btnColor: c.primary,
                  txtClr: white,
                  rad: 12,
                  onTap: () =>
                      Get.back(), // ← resolves the Future in showWaveSentDialog
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
