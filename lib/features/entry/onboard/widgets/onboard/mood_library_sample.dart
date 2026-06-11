import '../../../../../app/helper_widgets_export.dart';
import '../../../../shared/mood/mood_check_in/mood_chip_card.dart';
import '../../../../shared/mood/mood_check_in/mood_row_model.dart';

class MoodLibrarySample extends StatelessWidget {
  final List<MoodRowModel> moodDataList;
  const MoodLibrarySample({super.key, required this.moodDataList});

  @override
  Widget build(BuildContext context) {
    return
    /// Mood Chips + Icons (same pattern as MoodCheckInCard)
    ContainerBordered(
      contClr: c.cardOngoing,
      rad: 20,
      hp: 14,
      vp: 16,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.howAreYourFeeling.capEachWord(),
            style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
          ),
          itemGap.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: itemGap * 0.4,
            children: [
              ...moodDataList.map((dataModel) {
                return Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      /// Static chip (no selection)
                      MoodChip(
                        title: dataModel.name,
                        hp: dataModel.hp,
                        isSelected: false,
                      ),

                      /// Mood illustration
                      MoodChipAnimation(moodType: dataModel.moodType),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
