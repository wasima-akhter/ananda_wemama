import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../core/enums/app_enums.dart';
import '../controller/mood_library_controller.dart';
import '../widgets/mood_library_comp.dart';

class MoodLibraryScreen extends StatelessWidget {
  const MoodLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mlc = Get.find<MoodLibraryController>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.moodLibrary,
        suffix: IconInCircleBrdr(
          iconPath: IconsPath.bookmarkOutlined,
          goToPath: RoutePaths.bookmark,
        ),
      ),
      onRefresh: mlc.refresh, // ✅ refresh images + content together
      child: Column(
        spacing: itemGap * 2,
        children: [
          /// Mood Tabs
          Obx(
            () => MoodTabSelector(
              selected: mlc.selectedMood.value,
              onTap: (mood) => mlc.setMood(mood),
            ),
          ),

          /// Mood Image
          Obx(() {
            if (mlc.isMoodsImagesloading) return LoadingPrimary();
            return MoodIllustrationCard(imageUrl: mlc.getMoodImage(mlc.selectedMood.value));
          }),

          /// Mood Content
          Obx(() {
            if (mlc.isContentLoading) return LoadingPrimary();

            final items = mlc.moodReadingItems[mlc.selectedMood.value] ?? [];
            final currentMood = mlc.selectedMood.value;

            if (items.isEmpty) {
              return const EmptyNoSearchWidgetScrollable(title: "No content available");
            }

            return Column(
              children: items.map((item) {
                return MoodTypeReadingItem(
                  title: item.title,
                  description: item.description,
                  onTapRead: () => Get.toNamed(
                    RoutePaths.moodInsight,
                    arguments: {'itemId': item.id, 'mood': currentMood},
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ).getcm,
    );
  }
}

class MoodTabSelector extends StatelessWidget {
  final MoodType selected;
  final void Function(MoodType)? onTap;

  const MoodTabSelector({super.key, required this.selected, this.onTap});

  static const moods = [MoodType.calm, MoodType.tired, MoodType.anxious, MoodType.stressed];

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardPrimary,
      rad: 8,
      hp: 0,
      vp: 0,
      hasBrdr: true,
      brdrClr: c.primary,
      child: Row(
        children: moods.map((mood) {
          final isSelected = mood == selected;

          final isFirst = mood == MoodType.calm;
          final isLast = mood == MoodType.stressed;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(mood),
              child: Container(
                padding: 10.pv,
                decoration: BoxDeco.decBrdrOneSideCustom(
                  rad: 8,
                  clr: isSelected ? c.primary : ctransp,
                  brdrClr: c.primary,
                  side: isLast ? null : BrdrSideType.right, // no border if last
                  radiusCorners: isFirst
                      ? [
                          BrdrCorner.topLeft,
                          BrdrCorner.bottomLeft,
                        ] // first item: left corners rounded
                      : isLast
                      ? [
                          BrdrCorner.topRight,
                          BrdrCorner.bottomRight,
                        ] // last item: right corners rounded
                      : [], // middle items: no radius
                ),
                child: Text(
                  mood.name.capEachWord(),
                  textAlign: TextAlign.center,
                  style: TxtStyle.interSemiB(
                    fs: 12,
                    w: isSelected ? 600 : 500,
                    color: isSelected ? c.textOnPrimary : c.primary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
