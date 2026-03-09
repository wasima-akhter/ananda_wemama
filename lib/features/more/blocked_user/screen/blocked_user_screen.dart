import '../../../../app/helper_widgets_export.dart';
import '../controller/blocked_user_controller.dart';
import '../widgets/blocked_user_list_item.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buc = Get.find<BlockedUserController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: chatRefreshKey,
      onRefresh: () async {
        print("  refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.blockedUser),
      child: Column(
        children: [
          ...buc.fakeBlockedUser.map((e) {
            return BlockedUserListItem(chatModel: e, buc: buc);
          }),
        ],
      ).getcm,
    );
  }
}
