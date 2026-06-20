import '../../../../../app/helper_widgets_export.dart';
import '../../core/models/community_item_detail_model.dart';

class UserShortDetailWidget extends StatelessWidget {
  final AllPost postItem;
  const UserShortDetailWidget({super.key, required this.postItem});

  @override
  Widget build(BuildContext context) {
    final isAnonymous = postItem.isAnonymous ?? false;

    final creator = postItem.creator;
    final creatorName = creator?.name ?? '';
    final creatorImg = creator?.profileImage ?? '';
    final creatorAddress = creator?.city ?? '';
    return Row(
      children: [
        NetworkImageWidget(
          imageUrl: isAnonymous ? '' : creatorImg, 
          name:  isAnonymous ? '' : creatorName,
          isCircle: true,
          radius: 18,
          isUser: true,
          enablePreview: true,  solidPlaceholderCircle: true,
        ),
        Gap(itemGap * 1.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFit(
              isAnonymous ? Strings.anonymous : creatorName.capEachWord(),
              style: TxtStyle.outfitSemiB(fs: 13, w: 500,  ),
            ),
            isAnonymous
                ? const SizedBox.shrink()
                : Row(
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
