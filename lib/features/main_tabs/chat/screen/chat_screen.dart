import 'package:we_mama/core/components/ui/inputs/cus_search_bar.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/socket/socket_status_banner.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_ui_models.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      isScrollable: false,
      appBar: CommonAppBarContent(
        title: Strings.chat,
        hasBackNavArrow: false,
        suffix: CusCircleIconButton(
          onTap: cc.onTapHandWave,
          child: SvgIcon(iconPath: IconsPath.handWave, height: 22),
        ),
      ),
      child: Obx(() {
        final showSearch = cc.showSearchedTag.value;

        return Column(
          children: [
            CusSearchBar(
              controller: cc.searchController,
              focusNode: cc.searchFocus,
              onEditingComplete: () async {
                cc.showSearchedTag.value = true;
                cc.searchedTxt.value = cc.searchController.text;
                await cc.getSearchedChatList();
              },
            ).get10cm,

            Gap(itemGap * 1.5),

            Expanded(
              child: showSearch
                  ? _buildSearchResult(cc)
                  : _buildChatList(cc, chatRefreshKey),
            ),
          ],
        ).mR(0);
      }),
    );
  }

  Widget _buildSearchResult(ChatController cc) {
    final list = [...cc.searchedChatList];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔖 Search tag
        Row(
          children: [
            ContainerBordered(
              vp: 0,
              hp: 12,
              rad: 30,
              contClr: c.secondary.withOpacity(0.3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFit(
                    cc.searchedTxt.value,
                    style: TxtStyle.urbanistSemiB(
                      fs: 14,
                      w: 600,
                      color: c.primary,
                    ),
                  ),
                  Gap(8),
                  CusGestureDetector(
                    onTap: () {
                      cc.showSearchedTag.value = false;
                      cc.clearAll();
                    },
                    child: Container(
                      // color: Colors.amber,
                      padding: 9.pv,
                      child: SvgIconColored(
                        iconPath: IconsPath.closeCircle,
                        iconColor: c.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ).get10cm,
          ],
        ),

        Gap(itemGap),

        // 📦 State handling
        Expanded(
          child: Obx(() {
            if (cc.isSearchLoading_.value) {
              return Column(children: [LoadingPrimary()]).get10cm;
            }
            if (list.isEmpty) {
              return CusRefreshIndicator(
                onRefresh: () async {
                  await cc.getChatList();
                  cc.showSearchedTag.value = false;
                },
                child: EmptyNoSearchWidgetScrollable(
                  assetPath: Assets.images.noChatIcon.path,
                  title: "No conversations found",
                  subTitle:
                      "We couldn't find anyone matching your search.\n"
                      "Try searching with a different name.",
                ).getcm,
              );
            }

            return Container(
              // color: Colors.amber,
              // height: S.h * 0.7,
              child: ListView.builder(
                controller: cc.chatScrollCtrl,
                itemCount: list.length,
                itemBuilder: (_, index) {
                  final e = list[index];

                  return ChatListItem(
                    chatModel: FakeChatModel(
                      isblocked: e.isBlocked ?? false,
                      name: e.otherUser?.name ?? '',
                      lastMessage: e.lastMessage ?? '',
                      time: DateHelper().formatTimeAgo(e.time.toString()).date,
                      imageUrl: e.otherUser?.profileImage ?? '',
                      id: e.id ?? '',
                    ),
                  ).get10cm.mR(10);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildChatList(
    ChatController cc,
    GlobalKey<RefreshIndicatorState> refreshKey,
  ) {
    return Obx(() {
      final list = cc.realChatList;

      if (cc.isLoading_.value && list.isEmpty) {
        return Column(children: [LoadingPrimary()]);
      }

      if (list.isEmpty) {
        return CusRefreshIndicator(
          key: refreshKey,
          onRefresh: cc.getChatList,
          child: EmptyNoSearchWidgetScrollable(
            assetPath: Assets.images.noCommentIcon.path,
            title: "No conversations yet",
            subTitle:
                "Start by finding a match and sending a wave 👋\n"
                "When your wave is accepted, you can start chatting.\n\n"
                "You can also accept incoming wave requests to begin a conversation.",
          ).getcm,
        );
      }
      for (var e in list) {
        print("chatList id and name : ${e.id} , ${e.lastMessage}");
      }
      // ✅ RefreshIndicator lives here — direct parent of ListView, no Column in between
      return CusRefreshIndicator(
        key: refreshKey,
        onRefresh: cc.getChatList,
        child: ListView.builder(
          controller: cc.chatScrollCtrl,
          physics: const AlwaysScrollableScrollPhysics(), // ✅ must have
          itemCount: list.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) return const SocketStatusBanner();

            final e = list[index - 1];

            print(' is blocked in chatscreen: ${e.isBlocked}');

            final timeAgo = DateHelper().formatTimeAgo(e.time?.toString());

            final bool isNewMatch = timeAgo.date == 'N/A';
            return ChatListItem(
              chatModel: FakeChatModel(
                name: e.otherUser?.name ?? '',
                isblocked: e.isBlocked ?? false,
                lastMessage: isNewMatch
                    ? 'You can message each other now'
                    : (e.lastMessage ?? ''),
                time: isNewMatch ? '' : timeAgo.date,
                isNewMatch: isNewMatch,
                // if N/A, then
                // show the last Message: --> "you can message each other now" and the color woul dbe grey.
                imageUrl: e.otherUser?.profileImage ?? '',
                id: e.id ?? '',
              ),
            ).get10cm.mR(10);
          },
        ),
      );
    });
  }
}
