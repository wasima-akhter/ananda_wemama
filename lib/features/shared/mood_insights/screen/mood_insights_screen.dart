import '../../../../app/helper_widgets_export.dart';
import '../../mood_library/widgets/mood_library_comp.dart';
import '../controller/mood_insights_controller.dart';
import '../model/mood_insights_model.dart';

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mic = Get.find<MoodInsightsController>();

    final refreshKey = GlobalKey<RefreshIndicatorState>();

    final imageUrl = mic.moodImages[mic.passedMoodType]!;
    final items = mic.moodReadingItems[mic.passedMoodType]!;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: Strings.moodLibrary),
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: CusRefreshIndicator(
            refreshKey: refreshKey,
            onRefresh: () async {
              await mic.loadNotifications();
            },
            child:
                // Obx(() {
                // if (mic.isLoading) {
                //   return const Center(child: Loading());
                // }
                // if (mic.notifications.isEmpty) {
                //   return EmptyWidgetScrollable(title: Strings.noNotificationFound);
                // }
                // return
                //
                SingleChildScrollView(
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
                    .get10cm,
          ),
        ),
      ),
    );
  }
}

class NotificationItemCard extends StatelessWidget {
  final NotificationsDataModel n;
  final void Function(String notificationId) onTapNItem;
  const NotificationItemCard({super.key, required this.n, required this.onTapNItem});

  @override
  Widget build(BuildContext context) {
    final isSeen = (n.isSeen == true);
    return CusGestureDetector(
      onTap: () => onTapNItem(n.id ?? ''),
      child: ContainerBordered(
        hp: 16,
        vp: 18,
        hasBrdr: true,
        brdrClr: !isSeen ? Colors.blue : null,
        boxShadow: boxShadowAllSides,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 5.w,
                            backgroundColor: !isSeen ? Colors.blue : greyLoc,
                          ),

                          Gap(itemGap),
                          //
                          if (isSeen)
                            Text(
                              Strings.seen,
                              style: TxtStyle.inter(fs: 11, w: 600, color: greyLoc),
                            )
                          else
                            Text(
                              Strings.unSeen,
                              style: TxtStyle.inter(fs: 11, w: 600, color: Colors.blue),
                            ),
                        ],
                      ),
                      Text(formatNotificationTime(n.createdAt)),
                    ],
                  ),
                  Gap(itemGap),

                  Text(n.title ?? Strings.notification, style: TxtStyle.inter(fs: 12)),
                ],
              ),
            ),
            Gap(itemGap),
          ],
        ),
      ).mB(10).get10cm,
    );
  }

  String formatNotificationTime(DateTime? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} day ago";
  }
}
