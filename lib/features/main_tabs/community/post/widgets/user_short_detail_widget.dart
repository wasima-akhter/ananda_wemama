import 'package:we_mama/core/components/ui/dialogs/popups.dart';

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
        isAnonymous
            ? CircleAvatar(radius: 18.r, backgroundColor: c.primary)
            : NetworkImageWidget(
                imageUrl: creatorImg,
                name: creatorName,
                isCircle: true,
                radius: 18,
                isUser: true,
                enablePreview: true,
                solidPlaceholderCircle: true,
              ),
        Gap(itemGap * 1.5),
        Flexible(
          child: CusGestureDetector(
            onTap: isAnonymous
                ? null
                : () {
                    print(' creator?.id: in : ${creator?.id}');
                    showProfileDetailsPopup(userId: creator?.id ?? '');
                  },
            child: Container(
              padding: EdgeInsets.only(right: 5),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    isAnonymous ? Strings.anonymous : creatorName.capEachWord(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TxtStyle.outfitSemiB(fs: 13, w: 500),
                  ),
                  isAnonymous
                      ? const SizedBox.shrink()
                      : creatorAddress.isNotEmpty
                      ? Row(
                          children: [
                            SvgIcon(
                              iconPath: IconsPath.locationBold,
                              height: 16,
                            ),
                            TextFit(
                              creatorAddress,
                              style: TxtStyle.outfitxSmNor500,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
