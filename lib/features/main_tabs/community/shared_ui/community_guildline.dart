import '../../../../app/helper_widgets_export.dart';

class CommunityGuildline extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onTapAction;
  final bool? hasButton;

  const CommunityGuildline({
    super.key,
    required this.isLoading,
    required this.onTapAction,
    this.hasButton,
  });

  @override
  Widget build(BuildContext context) {
    final lsitOfInfo = [
      _InfoRow(
        title: Strings.womenOnlySpace,
        description: Strings.womenOnlySpaceDesc,
      ),
      _InfoRow(
        title: Strings.respectfulConduct,
        description: Strings.respectfulConductDesc,
      ),
      _InfoRow(
        title: Strings.privacyControl,
        description: Strings.privacyControlDesc,
      ),
      _InfoRow(
        title: Strings.activeModeration,
        description: Strings.activeModerationDesc,
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      decoration: BoxDeco.decRadiusAll(20, clr: bgClrNew),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(itemGap * 2),

            Text(
              Strings.communityGuideline.capEachWord(),
              style: TxtStyle.outfitLarTitle,
            ),

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
                            SvgIconColored(
                              iconPath: IconsPath.info,
                              height: 18,

                              iconColor: c.foregroundPrimary,
                            ),
                            Gap(itemGap),
                            Expanded(
                              child: Text(
                                item.title.capEachWord(),
                                style: TxtStyle.outfit(fs: 14),
                              ),
                            ),
                          ],
                        ),

                        Gap(itemGap),

                        Text(
                          item.description.capEachWord(),
                          style: TxtStyle.outfit(fs: 12, color: c.primary),
                        ),
                      ],
                    ),
                  );
                }),

                Gap(itemGap),
              ],
            ),

       if (hasButton==null)
            // decline and accept buttons
            ...[
              Gap(itemGap * 3),
              CustomBtnWTxt(
                isSmall: true,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                btnColor: c.primary,
                style: TxtStyle.outfit(fs: 11, color: white),
                rad: 12,
                btnTxt: Strings.agreeWithGuidelines,
                isLoading: isLoading,
                onTap: onTapAction,
              ).mHV(20, 0),
            ],

            Gap(itemGap * 3),
          ],
        ),
      ),
    );
  }
}

class _InfoRow {
  final String title;
  final String description;

  _InfoRow({required this.title, required this.description});
}
