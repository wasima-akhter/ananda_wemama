import '../../../app/helper_widgets_export.dart';
import '../../models/ui/fake_comment_item_model.dart';

class CommentItem extends StatelessWidget {
  final FakeCommentModel item;
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
                Text(item.userName, style: TxtStyle.outfitSemiB(fs: 14, color: c.textPrimary)),
                Text(item.comment, style: TxtStyle.outfit(fs: 13, w: 400)),
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
