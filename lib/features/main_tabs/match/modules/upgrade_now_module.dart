import '../../../../app/helper_widgets_export.dart';

class UpgradeNowModule extends StatelessWidget {
  final void Function()? onTapUgradeNow;
  const UpgradeNowModule({super.key, this.onTapUgradeNow});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 12,
      hp: 12,
      contClr: c.inputBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _makeChatUnlockMsges(
            title: Strings.dailyWaveLimit,
            subtitle: Strings.waveLimitDescription,
            iconPath: IconsPath.security,
          ),

          Gap(itemGap * 2),

          IntrinsicWidth(
            child: CustomBtnWTxt(
              isSmall: true,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              btnTxt: Strings.upgradeNow,
              isLoading: false,
              onTap: onTapUgradeNow,
              rad: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeChatUnlockMsges({
    required String title,
    required String subtitle,
    required String iconPath,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(iconPath: iconPath, height: 25),

            Gap(itemGap),

            ///
            Text(title, style: TxtStyle.interSemiB(fs: 13, w: 500, color: c.primary)),
          ],
        ),

        Gap(6),
        Text(subtitle, style: TxtStyle.inter(fs: 12, color: c.secondary)),
      ],
    );
  }
}
