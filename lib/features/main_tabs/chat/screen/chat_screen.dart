import 'package:mama_app/core/common_widgets/cus_search_bar.dart';

import '../../../../app/helper_widgets_export.dart';
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
      },
      appBar: CommonAppBarContent(
        title: Strings.chat,
        hasBackNavArrow: false,

        suffix: CusCircleIconButton(
          onTap: cc.onTapHandWave,
          child: SvgIcon(iconPath: IconsPath.handWave, height: 25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CusSearchBar(controller: cc.searchController, focusNode: cc.searchFocus),

          Gap(itemGap * 2),
          ...cc.fakeChatList.map((e) {
            return ChatListItem(chatModel: e);
          }),
        ],
      ).getcm,
    );
  }
}
