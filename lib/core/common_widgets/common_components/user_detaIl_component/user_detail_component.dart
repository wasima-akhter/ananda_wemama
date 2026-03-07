import '../../../../app/helper_widgets_export.dart';
import 'user_about_section.dart';
import 'user_avatar.dart';
import 'user_detail_controller/user_detail_controller.dart';

class UserDetailComponent extends StatelessWidget {
  final FakeUserDetailsModel? user;

  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final Future<void> Function(bool isAccepted) onTapAction;
  final RxBool isSeeMore;
  final bool? isFromProfile;
  const UserDetailComponent({
    super.key,
    this.user,
    required this.isLoading,
    required this.onTapSeeMore,
    required this.onTapAction,
    required this.isSeeMore,
    this.isFromProfile,
  });

  @override
  Widget build(BuildContext context) {
    // Show limited lines if collapsed, full text if expanded
    final isExpanded = isSeeMore;

    if (user == null) {
      return SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: itemGap,
      children: [
        // user details here
        if (isFromProfile ==null)
          Align(
            alignment: Alignment.centerRight,
            child: CusGestureDetector(
              onTap: () => Get.back(),
              child: SvgIcon(
                iconPath: IconsPath.closeCircle,
                height: 20,
              ).mOnly(top: 2, right: 10),
            ),
          ),

        UserAvatar(imageUrl: Strings.fakeImageUrl, isFromProfile: isFromProfile,),

        _getUserName(),

        // location text, ttc, interest text section
        _getUserInfo(user?.infoList ?? []),

        // a row of 4 pictures here (rad : 12) using NetWorkImageWidget with fake image urls
        _getRowOfImages(),

        // children section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.children.cap,
              style: TxtStyle.outfitSemiB(fs: 15, w: 500),
            ),
            Gap(itemGap),
            _getChildrenRow(),
          ],
        ),
        Gap(4),

        // baout me section
        UserAboutSection(
          aboutText: user?.aboutMe ?? '',
          isExpanded: isExpanded,
          onToggle: onTapSeeMore,
        ),
        Gap(4),
      ],
    );
  }

  Widget _getUserName() {
    return IntrinsicWidth(
      child: ContainerBordered(
        contClr: ctransp,
        vp: 0,
        child: Row(
          children: [
            Text(
              'Ananda, 21',
              style: TxtStyle.outfitSemiB(fs: 20, w: 600, color: c.primary),
            ),
            Gap(3),
            SvgIcon(iconPath: IconsPath.verifiedTick).mB(12),
          ],
        ),
      ),
    );
  }

  Widget _getUserInfo(List<UiInfoItem> listOfInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...listOfInfo.map(
          (e) => Row(
            children: [
              SvgIconColored(iconPath: e.iconPath, height: 18),
              Gap(itemGap),
              Expanded(
                child: Text(e.text.capEachWord(), style: TxtStyle.outfitSmNor),
              ),
            ],
          ).mB(3),
        ),
      ],
    ).mHV(20, 0);
  }

  Widget _getRowOfImages() {
    return Row(
      children: List.generate(user!.galleryImages.length, (index) {
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1, // 1:1 square
            child: Padding(
              padding: 4.pa,
              child: NetworkImageWidget(
                radius: 8,
                imageUrl: user?.galleryImages[index],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _getChildrenRow() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(user!.children.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w), // spacing between items
            child: IntrinsicWidth(
              child: ContainerBordered(
                rad: 30,
                hp: 12,
                vp: 6,
                contClr: c.secondary.withOpacity(0.2),
                child: Text(
                  (user?.children[index] ?? '').capEachWord(),
                  style: TxtStyle.outfitSmSecNor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
