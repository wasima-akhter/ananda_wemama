import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../controller/blocked_user_controller.dart';
import '../widgets/blocked_user_list_item.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buc = Get.find<BlockedUserController>();

    return AppScreenTemplate(
      onRefresh: buc.getBlockedUserList,
      appBar: CommonAppBarContent(title: Strings.blockedUser),
      child: Obx(() {
        final state = getUIStateList(
          isLoading: buc.isLoading_.value,
          list: buc.blockedUserList.value,
        );

        return UIStateHandler(
          state: state,
          onRefresh: buc.getBlockedUserList,

          // ─────────────────────────────
          // 🔹 Loading
          // ─────────────────────────────
          loading: () => const Center(child: LoadingPrimary()),

          // ─────────────────────────────
          // 🔹 Empty
          // ─────────────────────────────
          empty: () => EmptyNoSearchWidgetScrollable(title: Strings.noBlockedUserFound),

          // ─────────────────────────────
          // 🔹 Data
          // ─────────────────────────────
          data: () => Column(
            children: [
              ...buc.blockedUserList.map((user) {
                return BlockedUserListItem(user: user, buc: buc).getcm;
              }),
            ],
          ),
        );
      }),
    );
  }
}
