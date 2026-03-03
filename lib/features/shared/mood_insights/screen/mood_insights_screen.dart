import '../../../../app/helper_widgets_export.dart';
import '../../mood_library/widgets/mood_library_comp.dart';
import '../controller/mood_insights_controller.dart';

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = Get.find<MoodInsightsController>();

    final refreshKey = GlobalKey<RefreshIndicatorState>();

    final imageUrl = mic.moodImages[mic.passedMoodType]!;
    final items = mic.moodReadingItems[mic.passedMoodType]!;

    return AppScreenTemplate(
          refreshKey: refreshKey,
          onRefresh: () async {
            print("refreshed");
          },
          appBar: CommonAppBarContent(title: Strings.moodLibrary),
          child: Column(
            children: [
              /// ✅ Reactive Mood Illustration
              MoodIllustrationCard(imageUrl: imageUrl),

              /// ✅ Reactive Reading Items
              Column(
                children: items.map((texts) {
                  print("Type of argument: ${mic.passedMoodType}");

                  final currentMood = mic.passedMoodType; // ✅ capture outside map

                  return MoodTypeReadingItem(
                    title: currentMood?.name.capEachWord() ?? '',
                    bullets: texts,
                    onTapRead: () {},
                  );
                }).toList(),
              ),
            ],
          ),
        )
        // })
        .get10cm;
  }
}
