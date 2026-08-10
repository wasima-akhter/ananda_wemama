import '../../../../../app/helper_widgets_export.dart';
import '../controller/mood_insights_controller.dart';
import 'mood_insights_bookmark_button.dart';

class MoodInsightsFloatingBar extends StatelessWidget {
  const MoodInsightsFloatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = MoodInsightsController.to;

    return Obx(() {
      if (mic.isLoading.value || mic.item.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        decoration: BoxDeco.decRadiusUp(12, clr: c.scaffoldBackground),

        padding: const EdgeInsets.all(15),

        child: Row(
          children: [
            Expanded(
              child: CusGestureDetector(
                onTap: () => goToMainNavWithTab(4),

                child: ContainerBordered(
                  contClr: c.buttonPrimary,
                  rad: 30,
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

            const MoodInsightsBookmarkButton(),
          ],
        ),
      );
    });
  }
}
