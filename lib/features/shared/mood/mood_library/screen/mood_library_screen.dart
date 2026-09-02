import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';
import 'package:we_mama/features/shared/mood/mood_insights/controller/mood_insights_controller.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/models/ui/common_data_models.dart';
import '../controller/mood_library_controller.dart';
import '../widgets/mood_library_comp.dart';

// In MoodLibraryScreen, add this once:
class MoodLibraryScreen extends StatefulWidget {
  // change to StatefulWidget
  const MoodLibraryScreen({super.key});
  @override
  State<MoodLibraryScreen> createState() => _MoodLibraryScreenState();
}

class _MoodLibraryScreenState extends State<MoodLibraryScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ trigger load when screen opens normally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mlc = MoodLibraryController.to;
      mlc.ensureLoaded(mlc.selectedMood.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mlc = MoodLibraryController.to;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.moodLibrary,
        suffix: IconInCircleBrdr(
          iconPath: IconsPath.bookmarkOutlined,
          goToPath: RoutePaths.bookmark,
        ),
        onTapBack: () {
          Get.offAllNamed(RoutePaths.mainNav);
          MainNavController.to.goToTab(0);
        },
      ),
      onRefresh: mlc.refresh, // ✅ refresh images + content together
      child: Column(
        spacing: itemGap * 2,
        children: [
          /// Mood Tabs
          Obx(
            () => MoodTabSelector(
              selected: mlc.selectedMood.value,
              onTap: (mood) => mlc.setMood(mood, syncBack: true),
            ),
          ),

          /// Mood Image
          Obx(() {
            if (mlc.isMoodsImagesLoading) return LoadingPrimary();
            return MoodIllustrationCard(
              imageUrl: mlc.getMoodImage(mlc.selectedMood.value),
            );
          }),

          /// Mood Content
          Obx(() {
            if (mlc.isContentLoading) return LoadingPrimary();

            final items = mlc.moodReadingItems[mlc.selectedMood.value] ?? [];
            final currentMood = mlc.selectedMood.value;

            if (items.isEmpty) {
              return const EmptyNoSearchWidgetScrollable(
                title: "No content available",
              );
            }

            return Column(
              children: items.map((item) {
                return MoodTypeReadingItem(
                  title: item.title,
                  description: item.description,
                  onTapRead: () {
                    if (Get.isRegistered<MoodInsightsController>()) {
                      Get.delete<MoodInsightsController>();
                    }

                    Get.toNamed(
                      RoutePaths.moodInsight,

                      arguments: MoodInsightArgs(
                        moodType: currentMood,
                        itemId: item.id,
                        fromHome: true, // 👈 flag so back goes to moodLibrary
                      ),
                    );
                  },
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

  static const moods = [
    MoodType.calm,
    MoodType.tired,
    MoodType.anxious,
    MoodType.stressed,
  ];

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
                  rad: 6,
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
                    fs: 13,
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
