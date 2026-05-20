import 'package:mama_app/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:mama_app/features/shared/mood/mood_check_in/mood_check_in_controller.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../main_tabs/home/controller/home_controller.dart';
import '../mood_library/controller/mood_library_controller.dart';

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
    /*
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
                    final isSelected =
                        mcc.selectedMood.value == dataModel.moodType;

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
*/

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mcc.moodDataList.map((dataModel) {
        return Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: itemGap * 0.25),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => mcc.selectMood(dataModel.moodType),
                  child: Obx(() {
                    final isSelected =
                        mcc.selectedMood.value == dataModel.moodType;

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
          ),
        );
      }).toList(),
    );
  }
}

class _OpenMoodLibrary extends StatelessWidget {
  const _OpenMoodLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();

    return Column(
      children: [
        itemGap.verticalSpace,
        GestureDetector(
          onTap: () async {
            final mlc = Get.isRegistered<MoodLibraryController>()
                ? Get.find<MoodLibraryController>()
                : Get.put(MoodLibraryController());

            // ✅ resolve once, non-null
            final selectedMood = hc.mcc.selectedMood.value ?? MoodType.calm;

            mlc.selectedMood.value = selectedMood;

            await mlc.ensureLoaded(selectedMood);

            // ✅ use the resolved non-null variable, not the nullable original
            final items = mlc.moodReadingItems[selectedMood] ?? [];

            log('🧪 selectedMood: $selectedMood');
            log('🧪 items count: ${items.length}');
            log(
              '🧪 all keys in moodReadingItems: ${mlc.moodReadingItems.keys}',
            );

            if (items.isEmpty) {
              Get.toNamed(RoutePaths.moodLibrary);
              return;
            }

            final firstItem = items.first;

            Get.toNamed(
              RoutePaths.moodInsight,
              arguments: MoodInsightArgs(
                moodType: selectedMood,
                itemId: firstItem.id,
                fromHome: true,
              ),
            );
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
    final mcc = MoodCheckInController.to;

    return Obx(() {
      final state = getUIStateDetail(isLoading: mcc.isLoading.value);
      final data = mcc.checkInResponseData.value;

      return UIStateHandler(
        state: state,

        loading: () => const CheckInStreakShimmer(),

        data: () {
          /// ✅ CASE 1: no data → show nothing
          if (data == null) {
            return const SizedBox.shrink();
          }

          final streakText =
              "${Strings.checkInStreakHeart}${data.streak ?? 0}${Strings.checkInStreak1}";
          final messageText = Strings.checkInStreak2 + (data.message ?? "");

          return ContainerBordered(
            contClr: c.cardMood,
            rad: 8,
            hp: 8,
            vp: 6,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: streakText,
                    style: TxtStyle.outfitSemiB(
                      fs: 9,
                      w: 500,
                      color: c.primary,
                    ),
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: messageText,
                    style: TxtStyle.outfit(fs: 9, color: c.secondary),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class CheckInStreakShimmer extends StatelessWidget {
  const CheckInStreakShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardMood,
      rad: 8,
      hp: 8,
      vp: 6,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerWidget.rectangular(
            width: 70,
            height: 10,
            shimmerClr: c.inputBorder.withOpacity(0.4),
          ),

          const SizedBox(width: 4),

          ShimmerWidget.rectangular(
            width: 90,
            height: 10,
            shimmerClr: c.inputBorder.withOpacity(0.25),
          ),
        ],
      ),
    );
  }
}

class MoodChip extends StatelessWidget {
  final String title;
  final double? hp;
  final bool isSelected;

  const MoodChip({
    super.key,
    required this.title,
    this.hp,
    this.isSelected = false,
  });

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
      child:
          // Text(
          //   title.cap,
          //   style: TxtStyle.outfitSemiB(
          //     fs: 11,
          //     w: 500,
          //     color: isSelected ? Colors.white : c.secondary,
          //   ),
          // ),
          Text(
            title.cap,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSemiB(
              fs: 11,
              w: 500,
              color: isSelected ? Colors.white : c.secondary,
            ),
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
