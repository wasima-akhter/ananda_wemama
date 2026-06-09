import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../../main_tabs/chat/widgets/chat_user_image.dart';
import '../../members/controller/member_management_controller.dart';

class MemberManageListItem extends StatelessWidget {
  final MemberManagementController mmc;
  final FakeBlockedUserModel chatModel;

  const MemberManageListItem({
    super.key,
    required this.chatModel,
    required this.mmc,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = chatModel.imageUrl;
    final name = chatModel.name;

    return ContainerBordered(
      mv: 10,
      vp: 0,
      hp: 0,
      child: Row(
        children: [
          ChatUserImage(imageUrl: imageUrl, name: name),
          Gap(itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  name.cap,
                  style: TxtStyle.outfitSemiB(fs: 16, w: 500, color: c.primary),
                ),
              ],
            ),
          ),

          Gap(itemGap),
          CusFlexibleDropdown(
            items: [
              CusDropdownItem(
                title: Strings.mute,
                // onTap: () async => await showReportBottomSheet(),
              ),
              CusDropdownItem(
                title: Strings.suspend,
                // onTap: () async => await showReportBottomSheet(),
              ),
              CusDropdownItem(
                title: Strings.ban,
                // onTap: () async => await showReportBottomSheet(),
              ),
            ],
            child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
          ),
        ],
      ),
    ).get10cm.mR(10);
  }
}
