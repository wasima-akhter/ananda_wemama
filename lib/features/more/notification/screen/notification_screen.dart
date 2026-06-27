import 'package:mama_app/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../controller/notification_controller.dart';
import '../model/notifications_model.dart';
import '../router/notification_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  //

  final nc = Get.find<NotificationController>();
  // ───────────────────────── LIFECYCLE ─────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    nc.getNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🔍 [Lifecycle] state changed → $state');
    if (state == AppLifecycleState.resumed && mounted) {
      nc.getNotifications();
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: Strings.notification),
        backgroundColor: bgClrNew,
        resizeToAvoidBottomInset: true,
        body: Obx(() {
          final state = getUIStateList(
            isLoading: nc.isLoading_.value,
            list: nc.notifications.value,
          );

          return UIStateHandler(
            state: state,
            onRefresh: nc.getNotifications,

            // ─────────────────────────────
            // 🔹 Loading
            // ─────────────────────────────
            loading: () => const Center(child: LoadingPrimary()),

            // ─────────────────────────────
            // 🔹 Empty
            // ─────────────────────────────
            empty: () => Column(
              children: [
                EmptyNoSearchWidgetScrollable(
                  title: Strings.noNotificationFound,
                ),
              ],
            ),

            // ─────────────────────────────
            // 🔹 Data
            // ─────────────────────────────
            data: () => SingleChildScrollView(
              child: Column(
                children: [
                  ...nc.notifications.map((n) {
                    return NotificationItemCard(
                      n: n,
                      onTapNItem: (notificationId) async {
                        if (n.isSeen == true) {
                          await NotificationRouter.route(n);
                          return;
                        }

                        showLoading(
                          isupdateIsSeenLoading: nc.isupdateIsSeenLoading_,
                        );

                        await nc.updateIsSeen(notificationId: notificationId);

                        Get.back();

                        await Future.delayed(const Duration(milliseconds: 300));

                        await NotificationRouter.route(n);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        }).get10cm,
      ),
    );
  }
}

class NotificationItemCard extends StatelessWidget {
  final NotificationItemModel n;
  final void Function(String notificationId) onTapNItem;
  const NotificationItemCard({
    super.key,
    required this.n,
    required this.onTapNItem,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = getNotificationIconPath(notificationType: n.type ?? '');

    final createdAt = (n.createdAt ?? '').toString();

    final isSeen = n.isSeen ?? false;

    return CusGestureDetector(
      onTap: () => onTapNItem(n.id ?? ''),
      child: ContainerBordered(
        hp: 8,
        vp: 8,
        hasBrdr: true,
        brdrClr: !isSeen ? null : grey200,
        contClr: bgClrNew,

        // boxShadow: boxShadowAllSides,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─────────────────────────────
                  // 🔹 Description
                  // ─────────────────────────────
                  Row(
                    children: [
                      // ChatUserImage(imageUrl: '', name: ''),
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: c.inputBackground,
                        child: SvgIconColored(iconPath: iconPath),
                      ),
                      Gap(itemGap),

                      // ─────────────────────────────
                      // 🔹 Title
                      // ─────────────────────────────
                      Expanded(
                        child: Text(
                          n.title ?? Strings.notification,
                          style: TxtStyle.inter(fs: 13, w: 600),
                        ),
                      ),

                      Text(
                        DateHelper().formatTimeAgo(createdAt).date,
                        style: TxtStyle.outfit(
                          fs: 11,
                          w: 400,
                          color: c.secondary,
                        ),
                      ),
                    ],
                  ),

                  if ((n.description ?? '').isNotEmpty) ...[
                    Gap(itemGap * 0.5),
                    Text(
                      n.description ?? '',
                      style: TxtStyle.inter(fs: 12, w: 400, color: greyLoc),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ).mB(10).get10cm,
    );
  }

  // ─────────────────────────────
  // 🔹 Helpers
  // ─────────────────────────────
  String _formatNotificationTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day ago';
  }

  String _formatType(String? type) {
    if (type == null) return '';
    return type.replaceAll('_', ' ').toLowerCase().capitalizeFirst ?? type;
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'SENT_WAVE':
        return Colors.purple;
      case 'NEW_MESSAGE':
        return Colors.green;
      case 'SESSION_REMINDER':
        return Colors.orange;
      case 'COMMUNITY_POST':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
}

// SENT_MESSAGE
// SENT_WAVE
// ACCEPT_WAVE
// APPROVE_COMMUNITY

class NotificationStrings {
  const NotificationStrings();
  static const sentMessageStr = 'SENT_MESSAGE';
  static const sentWaveStr = 'SENT_WAVE';
  static const acceptWaveStr = 'ACCEPT_WAVE';
  static const approveCommunityStr = 'APPROVE_COMMUNITY';
}

String getNotificationIconPath({required String notificationType}) {
  switch (notificationType) {
    case NotificationStrings.sentMessageStr:
      return IconsPath.chat;

    case NotificationStrings.sentWaveStr:
    case NotificationStrings.acceptWaveStr:
      return IconsPath.handWave;
    case NotificationStrings.approveCommunityStr:
      return IconsPath.community;

    default:
      return IconsPath.notification;
  }
}
