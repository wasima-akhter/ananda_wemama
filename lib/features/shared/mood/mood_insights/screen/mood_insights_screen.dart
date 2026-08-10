import '../../../../../app/helper_widgets_export.dart';
import '../controller/mood_insights_controller.dart';
import '../widgets/mood_insights_content.dart';
import '../widgets/mood_insights_empty_view.dart';
import '../widgets/mood_insights_floating_bar.dart';
/*
class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = Get.find<MoodInsightsController>();
    final bc = Get.find<BookmarkController>();
    final mlc = Get.find<MoodLibraryController>(); // 👈 ADD THIS

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.moodInsights,
        onTapBack: mic.handleBack,
      ),
      isScrollable: false,

      floatingActionButton: Obx(() {
        if (mic.isLoading.value) {
          return const Center(child: LoadingPrimary());
        }

        final item = mic.item.value;

        if (item == null) {
          return SizedBox.shrink();
        }
        return Container(
          decoration: BoxDeco.decRadiusUp(12, clr: c.scaffoldBackground),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: CusGestureDetector(
                  onTap: () => goToMainNavWithTab(4),
                  child: ContainerBordered(
                    contClr: c.buttonPrimary,
                    rad: 30,
                    hp: 40,
                    vp: 8,
                    child: Text(
                      Strings.goToExpertCategory.capEachWord(),
                      style: TxtStyle.inter(
                        fs: 12,
                        w: 600,
                        color: c.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(itemGap),
              CusGestureDetector(
                onTap: () {
                  bc.toggleBookmark(
                    BookmarkItem(
                      id: item.id,
                      title: item.title,
                      description: item
                          .description, // ✅ update BookmarkItem too if needed
                      moodType: mic.passedMoodType,
                      imageUrl: mlc.getMoodImage(mic.passedMoodType),
                    ),
                  );
                },
                child: ContainerBordered(
                  contClr: c.primary,
                  rad: 18,
                  vp: 8,
                  hp: 12,
                  child: SvgIconColored(
                    iconPath: bc.isBookmarked(item.id)
                        ? IconsPath.bookmarkFilled
                        : IconsPath.bookmarkOutlined,
                    iconColor: white,
                  ),
                ),
              ),
            ],
          ),
        );
      }),

      child: Obx(() {
        if (mic.isLoading.value) {
          return const Center(child: LoadingPrimary());
        }

        final item = mic.item.value;

        // if (item == null) {
        //   return const EmptyWidgetScrollable(title: "No Data Found");

        // }
        if (item == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // reuse your existing empty/sad illustration if you have one
                  Image.asset(
                    ImagesPath.emptyList,
                    fit: BoxFit.contain,
                    height: S.w * 0.2,
                  ),
                  Gap(itemGap * 2),
                  Text(
                    "No insights available\nfor ${mic.passedMoodType.name} mood",
                    textAlign: TextAlign.center,
                    style: TxtStyle.interSemiB(
                      fs: 16,
                      w: 600,
                      color: c.primary,
                    ),
                  ),
                  Gap(itemGap),
                  Text(
                    "New content is added regularly. Check back soon!",
                    textAlign: TextAlign.center,
                    style: TxtStyle.inter(
                      fs: 13,
                      color: c.primary.withOpacity(0.6),
                    ),
                  ),
                  Gap(itemGap * 2),
                  CustomBtnWTxt(
                    isLoading: false,
                    btnTxt: "Browse Mood Library",
                    btnColor: c.primary,
                    txtClr: white,
                    rad: 12,
                    onTap: mic.handleBack, // ✅ back goes to library
                  ),
                ],
              ),
            ),
          );
        }
        final imageUrl = mlc.getMoodImage(mic.passedMoodType); // 👈 HERE

        return Column(
          children: [
            MoodIllustrationCard(imageUrl: imageUrl),

            Gap(itemGap),

            Expanded(
              child: MoodTypeInsightDesItem(
                id: item.id,
                title: item.title,
                description: item.description, // ✅ was bullets
                isBookmarked: bc.isBookmarked(item.id),
                onTapBookmark: () {
                  bc.toggleBookmark(
                    BookmarkItem(
                      id: item.id,
                      title: item.title,
                      description: item
                          .description, // ✅ update BookmarkItem too if needed
                      moodType: mic.passedMoodType,
                      imageUrl: mlc.getMoodImage(mic.passedMoodType),
                    ),
                  );
                },
                onTapExpertBtn: () => goToMainNavWithTab(4),
              ),
            ),
            Gap(S.viewPaddingBottom + 50),
          ],
        ).get10cm;
      }),
    );
  }
}
*/

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = MoodInsightsController.to;

    return AppScreenTemplate(
      appBar: CommonAppBarContent(
        title: Strings.moodInsights,
        onTapBack: mic.handleBack,
      ),
      isScrollable: false,

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const MoodInsightsFloatingBar()],
      ),

      child: Obx(() {
        if (mic.isLoading.value) {
          return const Center(child: LoadingPrimary());
        }

        if (mic.item.value == null) {
          return const MoodInsightsEmptyView();
        }

        return const MoodInsightsContent();
      }),
    );
  }
}
