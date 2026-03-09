import '../../../../app/helper_widgets_export.dart';

class SessionComponent extends StatelessWidget {
  const SessionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      w: S.w * 0.4,
      contClr: Color(0xFFE6D6CD),
      rad: 14,
      hp: 8,

      vp: 12,
      child: Column(
        children: [
          /// doctor row
          ///
          NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 20),
          Gap(10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr. Rama Akchukwu",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TxtStyle.outfit(fs: 13, w: 600, color: c.textPrimary),
              ),
              Text("Sleep Specialist", style: TxtStyle.outfit(fs: 12, color: c.textSecondary)),

              Gap(10),

              /// session title
              Text(
                "Baby Deep Sleep Session",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.textPrimary),
              ),

              Gap(6),

              /// date
              Text("20 March 2025", style: TxtStyle.outfit(fs: 11, color: c.secondary)),
            ],
          ),
        ],
      ),
    ).mR(8);
  }
}
