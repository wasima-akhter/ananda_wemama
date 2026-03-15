import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/user_about_section.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/user_avatar.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/user_detail_controller/user_detail_controller.dart';

class MatchUserDetails extends StatelessWidget {
  final FakeUserDetailsModel? user;
  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final Future<void> Function(bool hasWaved) onTapAction;
  final RxBool isSeeMore;

  const MatchUserDetails({
    super.key,
    required this.user,
    required this.isLoading,
    required this.isSeeMore,
    required this.onTapSeeMore,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    // Show limited lines if collapsed, full text if expanded
    final isExpanded = isSeeMore;

    if (user == null) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: itemGap,
          children: [
            // user details here
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatar(imageUrl: Strings.fakeImageUrl),

                  _getUserName(),
                ],
              ),
            ),

            // location text, ttc, interest text section
            _getUserInfo(user?.infoList ?? []),

            // a row of 4 pictures here (rad : 12) using NetWorkImageWidget with fake image urls
            _getRowOfImages(),

            // children section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.children.cap, style: TxtStyle.outfitSemiB(fs: 15, w: 500)),
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

            // decline and accept buttons
            _getDeclineAcceptBtnRow(),
          ],
        ),
      ),
    );
  }

  Widget _getUserName() {
    return ContainerBordered(
      contClr: ctransp,
      vp: 0,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('John Doe, 24', style: TxtStyle.outfitSemiB(fs: 20, w: 600, color: c.primary)),
          Gap(3),
          SvgIcon(iconPath: IconsPath.verifiedTick).mB(12),
        ],
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
              Expanded(child: Text(e.text.capEachWord(), style: TxtStyle.outfitSmNor)),
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
              child: NetworkImageWidget(radius: 8, imageUrl: user?.galleryImages[index]),
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
            child: ContainerBordered(
              rad: 30,
              hp: 12,
              vp: 6,
              contClr: c.scaffoldBackground,
              child: Text(
                (user?.children[index] ?? '').capEachWord(),
                style: TxtStyle.outfitSmSecNor,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _getDeclineAcceptBtnRow() {
    return Row(
      spacing: itemGap * 2,
      children: [
        Expanded(
          child: CustomBtnWTxt(
            isSmall: true,
            btnColor: ctransp,
            borderClr: c.primary,
            txtClr: c.textSecondary,
            rad: 12,
            btnTxt: Strings.pass,
            isLoading: isLoading.value,

            onTap: () => onTapAction(false),
          ),
        ),
        Expanded(
          child: CustomBtnWTxt(
            isSmall: true,
            btnColor: c.primary,
            borderClr: c.primary,
            txtClr: white,
            btnTxt: Strings.wave,
            rad: 12,
            isLoading: isLoading.value,

            onTap: () => onTapAction(true),
          ),
        ),
      ],
    );
  }
}

class _InfoRow {
  final String iconPath;
  final String text;

  _InfoRow({required this.iconPath, required this.text});
}
