import 'package:we_mama/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:we_mama/features/shared/mood/mood_check_in/mood_check_in_controller.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../main_tabs/home/controller/home_controller.dart';
import '../mood_library/controller/mood_library_controller.dart';
import 'mood_greeting.dart';

class MoodCheckInCard extends StatelessWidget {
  final MoodCheckInController mcc;
  const MoodCheckInCard({super.key, required this.mcc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MoodGreeting(),
        Gap(6.h),

        // how are you feeling card
        ContainerBordered(
          // contClr: c.cardOngoing,
          contClr: newCardClr,
          rad: 20,
          hp: 10,
          vp: 12,
          boxShadow: boxShadowBottom(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.howAreYourFeeling.capEachWord(),
                style: TxtStyle.outfitSemiB(fs: 18),
              ),
              itemGap.verticalSpace,

              _SelectMoodANdIllustration(mcc: mcc),

              (itemGap * 2).verticalSpace,

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mcc.moodDataList.map((dataModel) {
        return Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: itemGap * 0.25),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      mcc.selectMood(dataModel.moodType, fromHome: true),
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
            final selectedMood = hc.mcc.selectedMood.value ?? MoodType.calm;
            final mlc = Get.find<MoodLibraryController>();

            mlc.setMood(selectedMood);
            await mlc.ensureLoaded(selectedMood);

            final items = mlc.moodReadingItems[selectedMood] ?? [];

            print('🧪 selectedMood: $selectedMood');
            print('🧪 items count: ${items.length}');

            if (items.isNotEmpty) {
              Get.toNamed(
                RoutePaths.moodInsight,
                arguments: MoodInsightArgs(
                  moodType: selectedMood,
                  itemId: items.first.id,
                  fromHome: true,
                ),
              );
              return;
            }

            // fallback only if API truly has no content
            Get.toNamed(RoutePaths.moodLibrary);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.openMoodLibrary,
                style: TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.primary),
              ),
              Gap(itemGap),
              Icon(Icons.arrow_forward_ios, size: 13.h),
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
          final msg = data.message.toString() == "null"
              ? ""
              : data.message ?? '';
          final messageText = msg.isEmpty
              ? ''
              : Strings.checkInStreak2 + (data.message ?? "");

          // if (messageText.isEmpty) return const SizedBox.shrink();

          return ContainerBordered(
            contClr: c.cardMood.withValues(alpha: 0.8),
            rad: 8,
            hp: 8,
            vp: 5,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: streakText,
                    style: TxtStyle.outfitSemiB(
                      fs: 13,
                      w: 600,
                      color: c.strokePrimary,
                    ),
                  ),
                  const TextSpan(text: " "),
                  if (messageText.isNotEmpty)
                    TextSpan(
                      text: messageText,
                      style: TxtStyle.outfit(fs: 13, color: c.secondary),
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
      rad: 30,
      hp: 0,
      mv: 2,
      vp: ScreenSize.isSmallWidth ? 6 : 5,
      hasBrdr: true,
      brdrClr: isSelected ? c.strokePrimary : newBorderClr2_30,
      brdrW: 1,
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
              fs: 12,
              w: 600,
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
