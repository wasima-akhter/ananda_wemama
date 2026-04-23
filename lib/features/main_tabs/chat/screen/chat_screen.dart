import 'package:mama_app/core/components/ui/inputs/cus_search_bar.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../core/components/ui/scroll/cus_scrollbar_widget.dart';
import '../../../../core/helpers/date_helper.dart';
import '../../../../core/services/socket/socket_status_banner.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_list_item.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: chatRefreshKey,
      isScrollable: false,
      onRefresh: () async {
        print("chat refreshed");
        cc.getChatList();
      },
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
              // color: Colors.amber,
              // height: S.h * 0.8,
              child: showSearch ? _buildSearchResult(cc) : _buildChatList(cc),
            ),
          ],
        ).mR(10);
      }),
    );
  }

  Widget _buildSearchResult(ChatController cc) {
    final list = [
      ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
      // ...cc.searchedChatList,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔖 Search tag
        Row(
          children: [
            ContainerBordered(
              vp: 6,
              hp: 12,
              rad: 30,
              contClr: c.secondary.withOpacity(0.3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFit(
                    cc.searchedTxt.value,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary),
                  ),
                  Gap(8),
                  CusGestureDetector(
                    onTap: () {
                      cc.showSearchedTag.value = false;
                      cc.clearAll();
                    },
                    child: SvgIconColored(iconPath: IconsPath.closeCircle, iconColor: c.primary),
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
              return Column(children: [LoadingPrimary()]);
            }

            if (list.isEmpty) {
              return CusRefreshIndicator(
                onRefresh: () async {
                  await cc.getChatList();
                  cc.showSearchedTag.value = false;
                },
                child: const EmptyWidgetScrollable(title: "No chats found"),
              );
            }

            return Container(
              // color: Colors.amber,
              // height: S.h * 0.7,
              child: CusScrollbarWidget(
                controller: cc.chatScrollCtrl,
                child: ListView.builder(
                  controller: cc.chatScrollCtrl,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final e = list[index];

                    return ChatListItem(
                      chatModel: FakeChatModel(
                        name: e.otherUser?.name ?? '',
                        lastMessage: e.lastMessage ?? '',
                        time: DateHelper().formatTimeAgo(e.time.toString()).date,
                        imageUrl: e.otherUser?.profileImage ?? '',
                        id: e.id ?? '',
                      ),
                    ).get10cm.mR(10);
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildChatList(ChatController cc) {
    final list = [
      ...cc.realChatList,
      // ...cc.realChatList,
      // ...cc.realChatList,
      // ...cc.realChatList,
      // ...cc.realChatList,
    ];

    return Obx(() {
      if (cc.isLoading_.value) {
        return LoadingPrimary();
      }

      if (list.isEmpty) {
        return const EmptyWidget(title: "No Conversations yet..!");
      }

      return Column(
        children: [
          const SocketStatusBanner(),

          Expanded(
            child: CusRefreshIndicator(
              onRefresh: () async {
                await cc.getChatList();
              },
              child: CusScrollbarWidget(
                controller: cc.chatScrollCtrl,
                child: ListView.builder(
                  controller: cc.chatScrollCtrl,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final e = list[index];

                    return ChatListItem(
                      chatModel: FakeChatModel(
                        name: e.otherUser?.name ?? '',
                        lastMessage: e.lastMessage ?? '',
                        time: DateHelper().formatTimeAgo(e.time.toString()).date,
                        imageUrl: e.otherUser?.profileImage ?? '',
                        id: e.id ?? '',
                      ),
                    ).get10cm.mR(10);
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
