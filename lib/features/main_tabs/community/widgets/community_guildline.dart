import '../../../../app/helper_widgets_export.dart';

class CommunityGuildline extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onTapAction;

  const CommunityGuildline({super.key, required this.isLoading, required this.onTapAction});

  @override
  Widget build(BuildContext context) {
    final lsitOfInfo = [
      _InfoRow(title: Strings.womenOnlySpace, description: Strings.womenOnlySpaceDesc),
      _InfoRow(title: Strings.respectfulConduct, description: Strings.respectfulConductDesc),
      _InfoRow(title: Strings.privacyControl, description: Strings.privacyControlDesc),
      _InfoRow(title: Strings.activeModeration, description: Strings.activeModerationDesc),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      decoration: BoxDeco.decRadiusAll(20, clr: bgClr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(itemGap * 2),

          Text(Strings.communityGuideline.capEachWord(), style: TxtStyle.outfitLarTitle),

          Gap(itemGap * 3),
          // location text, ttc, interest text section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...lsitOfInfo.map((item) {
                return ContainerBordered(
                  vp: 12,
                  hp: 14,
                  mv: 4,
                  contClr: c.inputBackground,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgIconColored(iconPath: IconsPath.info, height: 18),
                          Gap(itemGap),
                          Expanded(
                            child: Text(
                              item.title.capEachWord(),
                              style: TxtStyle.outfitSemiB(fs: 15, w: 500),
                            ),
                          ),
                        ],
                      ),

                      Gap(itemGap),

                      Text(
                        item.description.capEachWord(),
                        style: TxtStyle.outfit(fs: 12, color: c.secondary),
                      ),
                    ],
                  ),
                );
              }),

              Gap(itemGap),
            ],
          ),

          Gap(itemGap * 3),

          // decline and accept buttons
          CustomBtnWTxt(
            isSmall: true,
            btnColor: c.secondary,
            style: TxtStyle.outfit(fs: 11, color: white),
            rad: 12,
            btnTxt: Strings.agreeWithGuidelines,
            isLoading: isLoading,
            onTap: onTapAction,
          ).mHV(20, 0),

          Gap(itemGap * 3),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String title;
  final String description;

  _InfoRow({required this.title, required this.description});
}
