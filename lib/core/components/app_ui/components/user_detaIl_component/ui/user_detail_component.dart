import '../../../../../../app/helper_widgets_export.dart';
import '../controller/user_detail_controller.dart';
import 'user_about_section.dart';
import 'user_avatar.dart';

class UserDetailComponent extends StatelessWidget {
  final FakeUserDetailsModel? user;

  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final RxBool isSeeMore;
  final bool? isFromProfile;
  const UserDetailComponent({
    super.key,
    this.user,
    required this.isLoading,
    required this.onTapSeeMore,
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

    // extract data from user.
    final userImage = user?.imageUrl ?? '';
    final userName = user?.name ?? '';
    final userAge = (user?.age ?? 0).toString();
    final userInfoList = user?.infoList ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: itemGap,
      children: [
        // user details here
        if (isFromProfile == null)
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

        Align(
          alignment: Alignment.center,
          child: UserAvatar(imageUrl: userImage, isFromProfile: isFromProfile),
        ),

        _getUserName(userName: userName, userAge: userAge),

        // location text, ttc, interest text section
        _getUserInfo(userInfoList),

        // a row of 4 pictures here (rad : 12) using NetWorkImageWidget with fake image urls
        _getRowOfImages(),

        // children section
        _getChildrenRow(),

        // baout me section
        if ((user?.aboutMe ?? '').isNotEmpty)
          UserAboutSection(
            aboutText: user?.aboutMe ?? '',
            isExpanded: isExpanded,
            onToggle: onTapSeeMore,
          ),
        Gap(4),
      ],
    );
  }

  Widget _getUserName({required String userName, required String userAge}) {
    return Align(
      // alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text.rich(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TxtStyle.outfitSemiB(fs: 20, w: 600),
              TextSpan(
                children: [
                  TextSpan(text: userName.capEachWord()),
                  if (userAge != '0') TextSpan(text: ', $userAge'),
                ],
              ),
            ),
          ),

          if (userAge != '0') ...[
            Gap(3),
            SvgIcon(iconPath: IconsPath.verifiedTick).mB(12),
          ],
        ],
      ),
    );
  }

  Widget _getUserInfo(List<UiInfoItem> listOfInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...listOfInfo.asMap().entries.map((entry) {
          final index = entry.key;
          final e = entry.value;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgIconColored(
                iconPath: e.iconPath,
                height: index == 0 ? 22 : 18,
              ),
              Gap(itemGap),
              Expanded(
                child: Text(
                  index == 1
                      ? "${listOfInfo.length == 1 ? "Stage" : "Stages"}: ${e.text.capEachWord()}"
                      : e.text.capEachWord(),
                  style: TxtStyle.outfitSmNor,
                ),
              ),
            ],
          ).mB(3);
        }),
      ],
    ).mHV(10, 0);
  }

  Widget _getRowOfImages() {
    if ((user?.galleryImages ?? []).isEmpty) return SizedBox.shrink();
    return Row(
      children: List.generate(4, (index) {
        final hasImage = index < (user?.galleryImages.length ?? 0);

        return Expanded(
          child: AspectRatio(
            aspectRatio: 1, // square
            child: Container(
              padding: 4.pa,
              child: hasImage
                  ? NetworkImageWidget(
                      bgColor: c.cardPrimary,
                      radius: 8,
                      enablePreview: true,
                      imageUrl: user!.galleryImages[index].trim(),
                      isUser: false,
                    )
                  : const SizedBox(), // empty slot
            ),
          ),
        );
      }),
    );
  }

  Widget _getChildrenRow() {
    if ((user?.children ?? []).isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.children.cap, style: TxtStyle.outfitSemiB(fs: 15, w: 500)),
        Gap(itemGap),

        SingleChildScrollView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Row(
            children: List.generate(user!.children.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w), // spacing between items
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContainerBordered(
                      rad: 30,
                      hp: 11,
                      vp: 5,
                      contClr: white,
                      child: Text(
                        (user?.children[index] ?? '').capEachWord(),
                        style: TxtStyle.outfit(fs: 11),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        Gap(4.h),
      ],
    );
  }
}

//

//
