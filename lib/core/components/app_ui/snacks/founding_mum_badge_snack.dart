import '../../../../app/helper_widgets_export.dart';

class FoundingMumBadgeSnack extends StatelessWidget {
  final String title;
  final String message;
  const FoundingMumBadgeSnack({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: c.inputBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: S.w * 0.15,
                  child: SvgIcon(iconPath: IconsPath.leaf, height: 30),
                ),

                Gap(itemGap),

                Expanded(
                  child: Text.rich(
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Founding Mum ".capEachWord(),
                          style: TxtStyle.outfitSemiB(color: c.primary, fs: 15, w: 700),
                        ),
                        TextSpan(
                          text: "badge added to your profile".capEachWord(),
                          style: TxtStyle.outfitSemiB(color: c.primary, fs: 14, w: 500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Gap(itemGap * 2),

            Text(
              Strings.earlyMemberHelpingShape.capEachWord(),
              style: TxtStyle.outfitSemiB(color: c.primary, fs: 12, w: 500), // stronger
            ).get10cm,
          ],
        ),
      ),
    );
  }
}
