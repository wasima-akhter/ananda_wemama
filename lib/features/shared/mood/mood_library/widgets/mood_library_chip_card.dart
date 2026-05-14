import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/buttons/small_nav_btn.dart';
import '../../mood_check_in/mood_chip_card.dart';
import '../../mood_check_in/mood_row_model.dart';

class MoodLibraryChipCard extends StatelessWidget {
  final List<MoodRowModel> moodDataList;
  final VoidCallback? onTapSubscribe;

  const MoodLibraryChipCard({super.key, required this.moodDataList, this.onTapSubscribe});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 20,
      hp: 14,
      vp: 16,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            children: [
              Text(Strings.moodChipLibrary, style: TxtStyle.outfitSemiB(fs: 14, color: c.primary)),
              const Spacer(),
              SvgIcon(iconPath: IconsPath.lock, height: 22),
            ],
          ),

          itemGap.verticalSpace,

          Divider(color: c.primary.withOpacity(.4)),

          itemGap.verticalSpace,

          /// Mood Chips + Icons (same pattern as MoodCheckInCard)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: itemGap * 0.4,
            children: [
              ...moodDataList.map((dataModel) {
                return Expanded(
                  child: Column(
                    children: [
                      /// Static chip (no selection)
                      MoodChip(title: dataModel.name, hp: dataModel.hp, isSelected: false),

                      /// Mood illustration
                      MoodChipAnimation(moodType: dataModel.moodType),
                    ],
                  ),
                );
              }),
            ],
          ),

          itemGap.verticalSpace,

          /// Subscribe Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgIcon(iconPath: IconsPath.lock, height: 16),
              Gap(itemGap * .5),
              Text(
                Strings.subscribeToAccessOurLibrary,
                style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.primary),
              ),
            ],
          ),

          itemGap.verticalSpace,

          /// Subscribe Button
          Center(
            child: SmallNavBtn(text: Strings.subscribe, onTap: onTapSubscribe),
          ),
        ],
      ),
    );
  }
}
