import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/buttons/small_nav_btn.dart';

class PastSessionsLibraryCard extends StatelessWidget {
  final VoidCallback? onTapSubscribe;

  const PastSessionsLibraryCard({super.key, this.onTapSubscribe});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 24,
      hp: 16,
      vp: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Library of Past Sessions", style: TxtStyle.outfitSmTitle),
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
                SvgIcon(iconPath: IconsPath.lock, height: 22),
                10.horizontalSpace,
                Expanded(
                  child: Text("Subscribe To Watch All Past Sessions", style: TxtStyle.outfitSmNor),
                ),
              ],
            ),
          ),

          16.verticalSpace,

          Center(
            child: SmallNavBtn(text: "Subscribe", onTap: onTapSubscribe),
          ),
        ],
      ),
    ).mB(itemGap);
  }
}
