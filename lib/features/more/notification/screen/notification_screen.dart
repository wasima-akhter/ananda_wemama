import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../core/themes/color/colors.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/notification_controller.dart';
import '../helper/notification_ui_helper.dart';
import '../model/notifications_model.dart';
import '../router/notification_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  final nc = Get.find<NotificationController>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    nc.getNotifications();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (!nc.paginator.hasMore.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      nc.loadMoreNotifications();
    }
  }
  // ───────────────────────── LIFECYCLE ─────────────────────────

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('🔍 [Lifecycle] state changed → $state');
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
                  assetPath: Assets.images.noticationPlaceholder.path,
                  title: "No notifications yet",
                  subTitle:
                      "You're all caught up!\n"
                      "We'll keep you posted when something comes up.",
                ),
              ],
            ),

            // ─────────────────────────────
            // 🔹 Data
            // ─────────────────────────────
            data: () => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: nc.notifications.length,
                    itemBuilder: (_, index) {
                      final n = nc.notifications[index];

                      return NotificationItemCard(
                        n: n,
                        onTapNItem: (notificationId) async {
                          if (n.isSeen == true) {
                            NotificationRouter.routeFromModel(n);
                            return;
                          }

                          showLoading(
                            isupdateIsSeenLoading: nc.isupdateIsSeenLoading_,
                          );

                          await nc.updateIsSeen(notificationId: notificationId);

                          Get.back();

                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          NotificationRouter.routeFromModel(n);
                        },
                      );
                    },
                  ),
                ),

                Obx(() {
                  if (!nc.isLoadingMore.value) {
                    return const SizedBox();
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: LoadingPrimary()),
                  );
                }),
              ],
            ),
          );
        }).get10cm.mT(10),
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
    final notificationUi = NotificationUiHelper.get(n.type ?? '');

    final createdAt = (n.createdAt ?? '').toString();

    final isSeen = n.isSeen ?? false;

    final notificationTime = DateHelper().formatNotificationTime(createdAt);

    return CusGestureDetector(
      onTap: () => onTapNItem(n.id ?? ''),
      child: ContainerBordered(
        hp: 8,
        vp: 8,
        hasBrdr: true,
        brdrClr: !isSeen ? c.bottomSheetBackground : grey200,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: notificationUi.color.withOpacity(.1),
                        child: Icon(
                          notificationUi.icon,
                          size: 16.r,
                          color: notificationUi.color.withOpacity(.8),
                        ),
                      ),

                      Gap(itemGap),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            (n.title ?? Strings.notification).cap,
                            style: TxtStyle.outfit(
                              fs: 14,
                              color: AppPalette.textPrimary,
                              w: 600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (notificationTime.time.isNotEmpty &&
                                notificationTime.date !=
                                    notificationTime.display)
                              Text(
                                notificationTime.time,
                                style: TxtStyle.outfit(
                                  fs: 9,
                                  w: 400,
                                  color: AppPalette.textTertiary,
                                ),
                              ),
                            Text(
                              notificationTime.date,
                              style: TxtStyle.outfit(
                                fs: 9,
                                w: 400,
                                color: AppPalette.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if ((n.description ?? '').isNotEmpty) ...[
                    Gap(itemGap * 0.5),
                    Text(
                      n.description ?? '',
                      style: TxtStyle.outfit(
                        fs: 12,
                        w: 400,
                        color: AppPalette.textSecondary,
                      ),
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
}
