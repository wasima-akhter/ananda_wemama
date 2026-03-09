import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/empty_widget.dart';
import '../../../../core/common_widgets/popups.dart';
import '../controller/notification_controller.dart';
import '../model/notifications_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nc = Get.find<NotificationController>();

    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: Strings.notification),
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: CusRefreshIndicator(
            refreshKey: refreshKey,
            onRefresh: () async {
              // await nc.loadNotifications();
            },
            child: Obx(() {
              if (nc.isLoading) {
                return const Center(child: Loading());
              }

              if (nc.notifications.isEmpty) {
                return EmptyWidgetScrollable(title: Strings.noNotificationFound);
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ...nc.notifications.map((n) {
                      return NotificationItemCard(
                        n: n,
                        onTapNItem: (notificationId) async {
                          if (n.isSeen == true) return;

                          // Show loading popup
                          showLoading(isupdateIsSeenLoading: nc.isupdateIsSeenLoading_);

                          await nc.updateIsSeen(notificationId: notificationId);

                          // update the seen logic
                          // In the UI

                          // Close popup AFTER update finishes

                          Get.back();
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            }).get10cm,
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
