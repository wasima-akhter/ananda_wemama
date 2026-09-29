import 'package:flutter/rendering.dart';
import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/core/components/ui/loaders/empty_widget.dart';
import 'package:we_mama/features/main_tabs/chat/widgets/chat_inbox_security_alert.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/socket/socket_status_banner.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/chat_inbox_controller.dart';
import '../model/chat_inbox_msg_item_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_row.dart';
import '../widgets/chat_screen_template.dart';
import '../widgets/chat_ui_models.dart';

class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({super.key});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  final cic = Get.find<ChatInboxController>();
  final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

  bool _isUserTouching = false;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    // cic.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // cic.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  double _lastPixels = 0;
  void _handlePagination(ScrollMetrics pos) async {
    if (!_isUserTouching) return;
    if (_isFetchingMore) return;
    if (cic.isLoading) return;
    if (!cic.messagesPaginator.hasMore.value) return;

    // ✅ TOP detection (chat older messages)

    // must be near top
    final atTop = pos.pixels <= 80;
    if (!atTop) return;

    _isFetchingMore = true;

    try {
      print('cic.loadMoreMessages() called  ');
      await cic.loadMoreMessages();
    } finally {
      _isFetchingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenTemplate(
      appBar: CommonAppBarContent(
        titleInLeft: true,
        title: '',
        expandTitle: true,
        titleWidget: Obx(() {
          final peerUser = cic.realChatInboxMsgItem.value.receiver;
          final peerUserId = peerUser?.id ?? '';
          return CusGestureDetector(
            onTap: () {
              if (peerUserId.isNotEmpty) {
                chatUserDetailsDialog(
                  isLoading: cic.isgetUserProfileLoading_,
                  isSeeMore: cic.isSeeMore,
                  onTapSeeMoreTxt: cic.toggleSeeMore,
                  user: cic.chatUserProfileData,
                );

                cic.getUserProfile(userId: peerUserId);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NetworkImageWidget(
                  imageUrl: peerUser?.profileImage ?? '',
                  isCircle: true,
                  isUser: true,
                  radius: 16,
                  // enablePreview: true,
                ),
                Gap(itemGap),
                Flexible(
                  child: Text(
                    peerUser?.name ?? Strings.chat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: 18.titleMclrCusFSOutfit,
                  ),
                ),
              ],
            ).mL(6),
          );
        }),
        suffix: Obx(() {
          final user = cic.realChatInboxMsgItem.value.receiver;

          return CusFlexibleDropdown(
            items: [
              CusDropdownItem(
                title: cic.isBlockedRx.value ? Strings.unblock : Strings.block,
                onTap: () {
                  cic.isBlockedRx.value
                      ? cic.onTapUnBlock(userId: user?.id ?? '')
                      : cic.onTapBlocked(userId: user?.id ?? '');
                },
              ),
              CusDropdownItem(
                title: Strings.reportUser,
                onTap: () {
                  cic.onTapReportUser(userId: user?.id ?? '');
                },
              ),
            ],
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: bgClrNew,
              child: SvgIconColored(iconPath: IconsPath.moreVertical),
            ),
          );
        }),
      ),

      inputRow: cic.isBlocked
          ? ContainerBordered(
              contClr: c.componentFill.withValues(alpha: 0.5),
              child: Text(
                "You have blocked this user",
                style: TxtStyle.outfit(),
              ),
            ).mHV(10, 20)
          : ChatInputRow(cic: cic).get10cm.mB(10),
      child: CusRefreshIndicator(
        refreshKey: chatRefreshKey,
        // ✅ Full reload from page 1 via REST now, not a socket emit
        onRefresh: () async {
          // await cic.getMessages();
          cic.scrollToLast();
        },
        child: NotificationListener<ScrollNotification>(
          // onNotification: (notification) {
          //   // ✅ user starts scrolling
          //   if (notification is UserScrollNotification) {
          //     if (notification.direction != ScrollDirection.idle) {
          //       _isUserTouching = true;
          //       cic.autoScrolling.value = false;
          //     }
          //   }

          //   // ✅ user stops scrolling
          //   if (notification is ScrollEndNotification) {
          //     _isUserTouching = false;
          //   }

          //   // ✅ ONLY react to real user scroll
          //   if (notification is ScrollUpdateNotification) {
          //     if (_isUserTouching) {
          //       _handlePagination(notification.metrics);
          //     }
          //   }

          //   return false;
          // },
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              final current = notification.metrics.pixels;

              // detect direction
              final isScrollingUp = current < _lastPixels;

              _lastPixels = current;

              if (_isUserTouching && isScrollingUp) {
                _handlePagination(notification.metrics);
              }
            }

            if (notification is UserScrollNotification) {
              if (notification.direction != ScrollDirection.idle) {
                _isUserTouching = true;
                cic.autoScrolling.value = false;
              }
            }

            if (notification is ScrollEndNotification) {
              _isUserTouching = false;
            }

            return false;
          },

          child: SingleChildScrollView(
            controller: cic.scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => ChatInboxSecurityAlert(
                    name: cic.realChatInboxMsgItem.value.receiver?.name ?? '',
                  ),
                ),
                Gap(itemGap * 2),

                Obx(() {
                  // 1. Initial loading state — first page hasn't arrived yet
                  if (cic.isLoading_.value && cic.messages.isEmpty) {
                    return SizedBox(
                      height: S.h * 0.5,
                      child: const Center(child: LoadingPrimary()),
                    );
                  }

                  // 2. Empty state — data arrived but no messages
                  if (cic.messages.isEmpty) {
                    return SizedBox(
                      height: S.h * 0.4,
                      child: EmptyNoSearchWidgetScrollable(
                        title: "No messages yet",
                        assetPath: Assets.images.noCommentIcon.path,
                        subTitle:
                            "Be the first to say hello! \nStart the conversation and connect with other mums.",
                      ),
                    );
                  }

                  // 3. Message list
                  final grouped = cic.groupMessagesByDate();

                  return Column(
                    children: [
                      const SocketStatusBanner(),

                      // Small spinner while an older page loads in
                      if (cic.isLoading_.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: LoadingPrimary(),
                            ),
                          ),
                        ),

                      ...grouped.map((item) {
                        if (item is String) {
                          return DateDivider(item: item);
                        }

                        final msg = item as Message;

                        return ChatBubbleCont(
                          cic: cic,
                          message: FakeMsgItemData(
                            msg: msg.text ?? '',
                            time: DateHelper()
                                .formatUTCtimestamp(
                                  msg.createdAt?.toString() ?? '',
                                )
                                .time,
                            isSentByMe: msg.sender == currentProfileId(),

                            /// NEW
                            attachments: msg.attachments ?? [],
                          ),
                        );
                      }),
                    ],
                  );
                }),

                Gap(itemGap * 2),
              ],
            ).getcm,
          ),
        ),
      ),
    );
  }
}

class DateDivider extends StatelessWidget {
  final String item;
  const DateDivider({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dateVerLine(),
        Padding(
          padding: 10.ph,
          child: Text(
            item,
            style: TxtStyle.outfitSemiB(fs: 12, color: c.strokePrimary),
          ),
        ),
        _dateVerLine(),
      ],
    ).mOnly(bottom: 12, top: 12);
  }

  Widget _dateVerLine() {
    return Flexible(child: Container(height: 0.2, color: c.strokePrimary));
  }
}
