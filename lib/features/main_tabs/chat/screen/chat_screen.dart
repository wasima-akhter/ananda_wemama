import 'package:mama_app/core/components/ui/inputs/cus_search_bar.dart';
import 'package:mama_app/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CusSearchBar(controller: cc.searchController, focusNode: cc.searchFocus),
          Gap(itemGap * 1.5),

          Obx(() {
            if (cc.isLoading_.value) {
              return LoadingPrimary();
            }
            final list_ = cc.realChatList;
            // final list = [...list_, ...list_, ...list_];
            final list = [...list_];

            if (list.isEmpty) {
              return const EmptyWidget(title: "No Conversations yet..!");
            }

            return Column(
              children: [
                const SocketStatusBanner(),
                ...list.map((e) {
                  return ChatListItem(
                    chatModel: FakeChatModel(
                      name: e.otherUser?.name ?? '',
                      lastMessage: e.lastMessage ?? '',
                      time: DateHelper().formatTimeAgo(e.time.toString()).date,
                      imageUrl: e.otherUser?.profileImage ?? '',
                      id: e.id ?? '',
                    ),
                  );
                }).toList(),
              ],
            );
          }),

          // Gap(itemGap * 2),
          // ...cc.realChatList.map((e) {
          //   return ChatListItem(chatModel: e);
          // }),
        ],
      ).getcm,
    );
  }
}
