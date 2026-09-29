import '../../../../../app/helper_widgets_export.dart';
import '../../manage/widgets/member_manage_list_item.dart';
import '../controller/member_management_controller.dart';

class MemberManagementScreen extends StatelessWidget {
  const MemberManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mmc = Get.find<MemberManagementController>();
    final chatRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: chatRefreshKey,
      onRefresh: () async {
        print("  refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.members),
      child: Column(
        children: [
          ...mmc.fakeBlockedUser.map((e) {
            return MemberManageListItem(chatModel: e, mmc: mmc);
          }),
        ],
      ).getcm,
    );
  }
}
