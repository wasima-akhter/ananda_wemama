import '../../../../../app/helper_widgets_export.dart';
import '../controller/mood_insights_controller.dart';

class MoodInsightsEmptyView extends StatelessWidget {
  const MoodInsightsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = MoodInsightsController.to;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Image.asset(ImagesPath.emptyList, height: S.w * 0.2),

            Gap(itemGap * 2),

            Text(
              "No insights available\nfor ${mic.passedMoodType.name} mood",

              textAlign: TextAlign.center,

              style: TxtStyle.interSemiB(fs: 16, w: 600, color: c.primary),
            ),

            Gap(itemGap),

            Text(
              "New content is added regularly. Check back soon!",

              textAlign: TextAlign.center,

              style: TxtStyle.inter(fs: 13, color: c.primary.withOpacity(.6)),
            ),

            Gap(itemGap * 2),

            CustomBtnWTxt(
              isLoading: false,
              btnTxt: "Browse Mood Library",
              btnColor: c.primary,
              txtClr: white,
              rad: 12,
              onTap: mic.handleBack,
            ),
          ],
        ),
      ),
    );
  }
}
