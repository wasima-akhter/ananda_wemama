import '../../../../app/helper_widgets_export.dart';

class PastSessionsLibraryCard extends StatelessWidget {
  final VoidCallback? onTapSubscribe;

  const PastSessionsLibraryCard({super.key, this.onTapSubscribe});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: newCardClr,
      rad: 24,
      hp: 16,
      vp: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Past Sessions Library", style: TxtStyle.outfitSmTitle),
              const Spacer(),
              SvgIcon(iconPath: IconsPath.lock, height: 22),
            ],
          ),

          Gap(itemGap),

          ContainerBordered(
            contClr: c.cardPrimary.withOpacity(.5),
            rad: 16,
            hp: 12,
            vp: 12,
            child: Row(
              children: [
                Icon(Icons.lock_clock_rounded, color: c.primary, size: 22.w),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    "Unlock the full library of past sessions and revisit the conversations, guidance, and moments that matter to you.",
                    style: TxtStyle.outfitSmNor,
                  ),
                ),
              ],
            ),
          ),

          16.verticalSpace,

          Center(
            child: SmallNavBtn(text: "Unlock Library", onTap: onTapSubscribe),
          ),
        ],
      ),
    ).mB(itemGap);
  }
}
