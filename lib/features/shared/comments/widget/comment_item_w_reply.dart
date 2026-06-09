import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../../../main_tabs/community/core/models/all_comments_of_post_model.dart';

class CommentItem extends StatelessWidget {
  final CommentModelOfPost item;
  const CommentItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageWidget(imageUrl: Strings.fakeImageUrl, radius: 20),

          Gap(itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.creator?.name ?? '',
                  style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary),
                ),
                Text(
                  item.content ?? '',
                  style: TxtStyle.outfit(fs: 13, w: 400),
                ),
                CusGestureDetector(
                  onTap: () {},
                  child: Text(Strings.reply, style: TxtStyle.outfitSmSecNor500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItemShimmer extends StatelessWidget {
  const CommentItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar shimmer
          const ShimmerWidget.circular(width: 40, height: 40),

          Gap(itemGap),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // username shimmer
                const ShimmerWidget.rectangular(width: 120, height: 14),

                Gap(itemGap * 0.5),

                // comment line 1
                const ShimmerWidget.rectangular(
                  width: double.infinity,
                  height: 12,
                ),

                Gap(itemGap * 0.3),

                // comment line 2 (shorter)
                const ShimmerWidget.rectangular(width: 180, height: 12),

                Gap(itemGap * 0.6),

                // reply shimmer
                const ShimmerWidget.rectangular(width: 60, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
