import '../../../../../app/helper_widgets_export.dart';
import '../../mood_check_in/mood_chip_card.dart';
import '../../mood_check_in/mood_row_model.dart';

class MoodLibraryChipCard extends StatefulWidget {
  final List<MoodRowModel> moodDataList;
  final VoidCallback? onTapSubscribe;

  const MoodLibraryChipCard({
    super.key,
    required this.moodDataList,
    this.onTapSubscribe,
  });

  @override
  State<MoodLibraryChipCard> createState() => _MoodLibraryChipCardState();
}

class _MoodLibraryChipCardState extends State<MoodLibraryChipCard> {
  MoodRowModel? selectedMood;

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardOngoing,
      rad: 20,
      hp: 14,
      vp: 12,
      boxShadow: boxShadowBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Strings.moodChipLibrary,
                style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
              ),
              const Spacer(),
              SvgIcon(iconPath: IconsPath.lock, height: 22),
            ],
          ),

          // 5.verticalSpace,
          Divider(color: c.primary.withOpacity(.4)),
          2.verticalSpace,
          Text(
            Strings.howAreYourFeeling.capEachWord(),
            style: TxtStyle.outfitSemiB(fs: 16),
          ),
          itemGap.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: itemGap * .4,
            children: [
              ...widget.moodDataList.map((dataModel) {
                final isSelected = selectedMood?.name == dataModel.name;

                return Expanded(
                  child: Column(
                    children: [
                      CusGestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedMood?.name == dataModel.name) {
                              selectedMood = null; // unselect
                            } else {
                              selectedMood = dataModel; // select new mood
                            }
                          });
                        },
                        child: MoodChip(
                          title: dataModel.name,
                          hp: dataModel.hp,
                          isSelected: isSelected,
                        ),
                      ),

                      MoodChipAnimation(moodType: dataModel.moodType),
                    ],
                  ),
                );
              }),
            ],
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: selectedMood == null
                ? const SizedBox()
                : GestureDetector(
                    key: const ValueKey("open_library"),
                    onTap: widget.onTapSubscribe,
                    child: Column(
                      children: [
                        itemGap.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Open Mood Library",
                              style: TxtStyle.outfitSemiB(
                                fs: 11,
                                w: 500,
                                color: c.primary,
                              ),
                            ),

                            Gap(itemGap * .5),
                            SvgIconColored(
                              iconPath: IconsPath.arrowRightLg,
                              height: 16,
                            ),
                            Gap(itemGap * .5),
                            SvgIcon(iconPath: IconsPath.lock, height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
