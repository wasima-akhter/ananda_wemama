import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/buttons/small_outlined_btn.dart';
import '../../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../core/models/community_item_model.dart';

class CommunityItem extends StatelessWidget {
  final void Function()? onTapItemBtn;
  final void Function()? onTapItem;
  final bool isLoading;
  final String btnTxt;
  final Color? bgClr;
  final CommunityItemModel item;
  const CommunityItem({
    super.key,
    this.onTapItemBtn,
    required this.isLoading,
    required this.btnTxt,
    this.onTapItem,
    this.bgClr,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final communityName = item.name ?? '';
    final postNum = (item.totalPost ?? 0).toString();
    final membersNum = (item.totalMember ?? 0).toString();
    final stats = [postNum, membersNum];
    return CusGestureDetector(
      onTap: onTapItem,
      child: ContainerBordered(
        vp: 10,
        hp: 12,
        contClr: bgClr,
        hasBrdr: true,
        brdrClr: c.inputBorder.withOpacity(0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Make the text column expand naturally
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFit(
                    communityName.capEachWord(),
                    style: TxtStyle.outfitSmTitle,
                  ),

                  Gap(2.h),

                  Row(
                    children: List.generate(stats.length, (index) {
                      final text = index == 0 ? "New post" : "Members";
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == stats.length - 1 ? 0 : 12.w,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 4.r,
                              backgroundColor: c.primary,
                            ),
                            Gap(4),
                            Text(
                              "${stats[index]} $text",
                              style: TxtStyle.outfit(
                                fs: 13,
                                color: c.foregroundSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            Gap(20.w),

            SmallOutlinedBtn(
              isLoading: isLoading,
              btnClr: bgClr != null ? c.secondary : null,
              txtClr: bgClr != null ? white : c.primary,
              btnTxt: btnTxt,
              onTap: onTapItemBtn,
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityItemShimmer extends StatelessWidget {
  const CommunityItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 12,
      hasBrdr: true,
      brdrClr: c.inputBorder.withOpacity(0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title (2 lines effect)
                ShimmerWidget.rectangular(width: double.infinity, height: 12),
                Gap(6),
                ShimmerWidget.rectangular(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 12,
                ),

                Gap(10),

                /// Stats row
                Row(
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Row(
                        children: [
                          /// Dot
                          ShimmerWidget.circular(width: 8, height: 8),
                          Gap(6),

                          /// Text
                          ShimmerWidget.rectangular(width: 60, height: 10),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          Gap(12.w),

          /// BUTTON SHIMMER
          ShimmerWidget.rectangular(width: 80, height: 32),
        ],
      ),
    );
  }
}
