import '../../../../app/helper_widgets_export.dart';
import '../controller/bookmark_controller.dart';
import '../model/bookmark_model.dart';
import '../modules/bookmark_reading_item.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nc = Get.find<BookmarkController>();

    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.bookmark),

      child: Column(
        children: [
          ...nc.bookmarks.map((b) {
            return MoodBookMarkReadingItem(
              title: b.title,
              onTapRead: () => Get.toNamed(
                RoutePaths.moodInsight,
                arguments: {
                  'mood': MoodType.anxious,
                  'item': "item", // ← pass the specific item
                },
              ),
              bullets: b.bullets,
            );
          }).toList(),
        ],
      ).getcm,
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
