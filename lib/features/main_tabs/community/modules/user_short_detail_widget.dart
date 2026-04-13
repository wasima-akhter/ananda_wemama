import '../../../../app/helper_widgets_export.dart';
import '../model/community_item_detail_model.dart';

class UserShortDetailWidget extends StatelessWidget {
  final AllPost postItem;
  const UserShortDetailWidget({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    final creator = postItem.creator;
    final creatorName = creator?.name ?? '';
    final creatorAddress = creator?.city ?? '';
    return Row(
      children: [
        NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 25),
        Gap(itemGap * 1.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFit(creatorName, style: TxtStyle.outfitSmNor500),
            Row(
              children: [
                SvgIcon(iconPath: IconsPath.locationBold, height: 16),
                TextFit(creatorAddress, style: TxtStyle.outfitxSmNor500),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
