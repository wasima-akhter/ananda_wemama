import '../../../../app/helper_widgets_export.dart';

class UpgradeNowModule extends StatelessWidget {
  final void Function()? onTapUgradeNow;
  final int? remainingCount;
  final int? dailyLimit;

  const UpgradeNowModule({
    super.key,
    this.onTapUgradeNow,
    this.remainingCount,
    this.dailyLimit,
  });

  @override
  Widget build(BuildContext context) {
    final hasCount = remainingCount != null && dailyLimit != null;

    final subtitle = !hasCount
        ? Strings
              .waveLimitDescription // fallback if caller doesn't pass counts
        : remainingCount == 0
        ? "You've used all $dailyLimit free waves for today."
        : "$remainingCount of $dailyLimit free waves left today.";

    return ContainerBordered(
      vp: 12,
      hp: 12,
      contClr: c.inputBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _makeChatUnlockMsges(
            title: Strings.dailyWaveLimit,
            subtitle: subtitle,
            iconPath: IconsPath.security,
          ),

          Gap(itemGap * 2),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBtnWTxt(
                isSmall: true,
                style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: bgClr),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                btnTxt: Strings.upgradeNow,
                isLoading: false,
                onTap: onTapUgradeNow,
                rad: 4,
              ),
            ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(iconPath: iconPath, height: 25),
            Gap(itemGap),
            Text(
              title,
              style: TxtStyle.interSemiB(
                fs: 13,
                w: 500,
                color: c.foregroundSecondary,
              ),
            ),
          ],
        ),
        Gap(6),
        Text(
          subtitle,
          style: TxtStyle.inter(fs: 11, color: c.foregroundSecondary),
        ),
      ],
    );
  }
}
