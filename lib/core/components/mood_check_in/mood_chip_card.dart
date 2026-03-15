import 'package:mama_app/core/components/mood_check_in/mood_check_in_controller.dart';

import '../../../../app/helper_widgets_export.dart';

class MoodCheckInCard extends StatelessWidget {
  final MoodCheckInController mcc;
  const MoodCheckInCard({super.key, required this.mcc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Strings.goodEveningAda.capEachWord(),
              style: TxtStyle.outfitSemiB(fs: 14, w: 600, color: c.primary),
            ),
            Gap(4),

            SvgIcon(iconPath: IconsPath.leaf),
          ],
        ).mL(4),
        Gap(6.h),

        // how are you feeling card
        ContainerBordered(
          contClr: c.cardOngoing,
          rad: 20,
          hp: 14,
          vp: 12,
          boxShadow: boxShadowBottom(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.howAreYourFeeling.capEachWord(),
                style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
              ),
              itemGap.verticalSpace,

              _SelectMoodANdIllustration(mcc: mcc),

              itemGap.verticalSpace,

              _CheckInStreakRow(),

              // open mood library link
              Obx(() {
                if (mcc.selectedMood.value == null) {
                  return const SizedBox();
                }

                return _OpenMoodLibrary();
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectMoodANdIllustration extends StatelessWidget {
  final MoodCheckInController mcc;
  const _SelectMoodANdIllustration({super.key, required this.mcc});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      spacing: itemGap * 0.5,
      children: [
        ...mcc.moodDataList.map((dataModel) {
          return Expanded(
            flex: 1,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => mcc.selectMood(dataModel.moodType),
                  child: Obx(() {
                    final isSelected = mcc.selectedMood.value == dataModel.moodType;

                    return MoodChip(
                      title: dataModel.name,
                      hp: dataModel.hp,
                      isSelected: isSelected,
                    );
                  }),
                ),

                MoodChipAnimation(moodType: dataModel.moodType),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _OpenMoodLibrary extends StatelessWidget {
  const _OpenMoodLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        itemGap.verticalSpace,
        GestureDetector(
          onTap: () {
            // Navigate to mood library here

            Get.toNamed(RoutePaths.moodLibrary);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.openMoodLibrary,
                style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.primary),
              ),
              Gap(itemGap),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckInStreakRow extends StatelessWidget {
  const _CheckInStreakRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardMood,
      rad: 8,
      hp: 8,
      vp: 6,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: Strings.checkInStreak1.capEachWord(),
              style: TxtStyle.outfitSemiB(fs: 9, w: 500, color: c.primary),
            ),
            TextSpan(text: ""),
            TextSpan(
              text: Strings.checkInStreak2.capEachWord(),
              style: TxtStyle.outfit(fs: 9, color: c.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodChip extends StatelessWidget {
  final String title;
  final double? hp;
  final bool isSelected;

  const MoodChip({super.key, required this.title, this.hp, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: isSelected ? c.primary : c.moodTagBackground,
      rad: 20,
      hp: hp ?? 10,
      mv: 2,
      vp: 5,
      hasBrdr: true,
      brdrClr: isSelected ? c.primary : c.textPrimary,
      brdrW: 0.3,
      child: Text(
        title.cap,
        style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: isSelected ? Colors.white : c.secondary),
      ),
    );
  }
}

class MoodChipAnimation extends StatelessWidget {
  final MoodType moodType;
  const MoodChipAnimation({super.key, required this.moodType});

  @override
  Widget build(BuildContext context) {
    final path = () {
      switch (moodType) {
        case MoodType.calm:
          return ImagesPath.calm;
        case MoodType.tired:
          return ImagesPath.tired;
        case MoodType.anxious:
          return ImagesPath.anxious;
        case MoodType.stressed:
          return ImagesPath.stressed;
      }
    }();

    return ImageDotAsset(path: path);
  }
}
