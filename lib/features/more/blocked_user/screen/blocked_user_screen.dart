import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../gen/assets.gen.dart';
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
          loading: () => Center(child: BlockedUserListItemSkeleton().getcm),

          // ─────────────────────────────
          // 🔹 Empty
          // ─────────────────────────────
          empty: () => EmptyNoSearchWidgetScrollable(
            assetPath: Assets.images.noChatIcon.path,
            title: "No blocked users",
            subTitle:
                "You haven't blocked anyone yet.\n"
                "Users you block will appear here.",
          ).get10cm,

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

class BlockedUserListItemSkeleton extends StatefulWidget {
  const BlockedUserListItemSkeleton({super.key});

  @override
  State<BlockedUserListItemSkeleton> createState() =>
      _BlockedUserListItemSkeletonState();
}

class _BlockedUserListItemSkeletonState
    extends State<BlockedUserListItemSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return ContainerBordered(
          mv: 10,
          vp: 0,
          hp: 0,
          child: Row(
            children: [
              // -----------------------------------------------------------
              // Avatar
              // -----------------------------------------------------------
              _SkeletonBox(
                width: 48.w,
                height: 48.w,
                radius: 999,
                animationValue: _controller.value,
              ),

              Gap(itemGap),

              // -----------------------------------------------------------
              // User name
              // -----------------------------------------------------------
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _SkeletonBox(
                    width: 105.w,
                    height: 15.h,
                    radius: 5.r,
                    animationValue: _controller.value,
                  ),
                ),
              ),

              Gap(itemGap),

              // -----------------------------------------------------------
              // Unblock button
              // -----------------------------------------------------------
              _SkeletonBox(
                width: 58.w,
                height: 28.h,
                radius: 7.r,
                animationValue: _controller.value,
              ),
            ],
          ),
        ).get10cm.mR(10);
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double animationValue;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = c.foregroundSecondary.withValues(alpha: .07);
    final highlightColor = c.foregroundSecondary.withValues(alpha: .14);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(-1.5 + animationValue * 3, 0),
          end: Alignment(-0.5 + animationValue * 3, 0),
          colors: [baseColor, highlightColor, baseColor],
        ),
      ),
    );
  }
}
