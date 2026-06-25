import 'package:mama_app/core/components/ui/dialogs/popups.dart';
import 'package:mama_app/core/components/ui/loaders/empty_widget.dart';
import 'package:mama_app/features/main_tabs/chat/widgets/chat_inbox_security_alert.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/socket/socket_status_banner.dart';
import '../controller/chat_inbox_controller.dart';
import '../model/chat_inbox_msg_item_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_row.dart';
import '../widgets/chat_screen_template.dart';
import '../widgets/chat_ui_models.dart';

class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cic = Get.find<ChatInboxController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

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
            child: SvgIconColored(iconPath: IconsPath.moreVertical),
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
          : ChatInputRow(cic: cic).get10cm,
      child: CusRefreshIndicator(
        refreshKey: chatRefreshKey,
        onRefresh: () async => cic.emitGetMessages(),
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
                // 1. Loading state — data hasn't arrived from socket yet
                if (cic.isLoading_.value) {
                  return SizedBox(
                    height: S.h * 0.5,
                    child: const Center(child: LoadingPrimary()),
                  );
                }

                // 2. Empty state — data arrived but no messages
                if (cic.messages.isEmpty) {
                  return SizedBox(
                    height: S.h * 0.4,
                    child: const EmptyWidget(title: "No messages yet!"),
                  );
                }

                // 3. Message list — use cic.messages (RxList), not realChatInboxMsgItem
                final grouped = cic.groupMessagesByDate();

                return Column(
                  children: [
                    const SocketStatusBanner(),

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
