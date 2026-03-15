import 'package:mama_app/core/common_widgets/common_components/user_detaIl_component/user_detail_component.dart';
import 'package:mama_app/core/common_widgets/common_components/user_detaIl_component/user_detail_controller/user_detail_controller.dart';
import 'package:mama_app/features/main_tabs/home/modules/profile_tile.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/common_widgets/popups.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();
    final udc = Get.find<UserDetailController>();

    final setupProfileFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.profile),
      onRefresh: () async {
        pc.fetchMyProfile();
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            // ✅ show shimmer while loading
            if (pc.isLoading_.value) return const ProfileShimmer();

            final data = pc.userProfileData.value;

            return ContainerBordered(
              hasBrdr: true,
              brdrClr: c.secondary.withOpacity(0.3),
              contClr: c.inputBackground,
              child: UserDetailComponent(
                isLoading: udc.isLoading_,
                onTapSeeMore: udc.toggleSeeMore,
                onTapAction: (isAccepted) async {},
                isSeeMore: udc.isSeeMore,
                isFromProfile: true,
                user: data == null
                    ? null
                    : FakeUserDetailsModel(
                        imageUrl: '',
                        name: data.name ?? '',
                        age: _getAge(data.dob),
                        aboutMe: data.bio ?? '',
                        galleryImages: data.images,
                        children: data.children.map((e) => e.toString()).toList(),
                        infoList: [
                          if (data.address?.isNotEmpty == true)
                            UiInfoItem(iconPath: IconsPath.locationBold, text: data.address!),
                          if (data.mumStage?.isNotEmpty == true)
                            UiInfoItem(iconPath: IconsPath.chartFilled, text: data.mumStage!),
                          if (data.interesteds.isNotEmpty)
                            UiInfoItem(
                              iconPath: IconsPath.heartHalfFilled,
                              text: data.interesteds.join(', '),
                            ),
                        ],
                      ),
              ),
            );
          }),

          Gap(itemGap * 2),

          _getBtnRow(),

          Gap(itemGap * 2),

          ProfileTile(
            title: Strings.managePassword,
            iconPath: IconsPath.security,
            tileClr: c.inputBackground,

            onTap: () => Get.toNamed(RoutePaths.changePassword),
          ),
          Gap(itemGap),
          ProfileTile(
            title: Strings.blockedUser,
            tileClr: c.inputBackground,
            iconPath: IconsPath.userOutlined,
            onTap: () => Get.toNamed(RoutePaths.blockedUser),
          ),
          Gap(itemGap),
          ProfileTile(
            title: Strings.subscription,
            tileClr: c.inputBackground,
            iconPath: IconsPath.starFilled,
            onTap: () => Get.toNamed(RoutePaths.subscriptionInfo),
          ),
          Gap(itemGap),
          ProfileTile(
            title: Strings.about,
            tileClr: c.inputBackground,
            iconPath: IconsPath.info,
            onTap: () => Get.toNamed(RoutePaths.about),
          ),
          Gap(itemGap),
          ProfileTile(
            title: Strings.logOut,
            tileClr: c.inputBackground,
            iconPath: IconsPath.logout,
            iconColor: c.error,
            onTap: () {
              logoutConfirmDialog(
                isLoading: pc.isSignOutLoading_,
                onConfirm: () async => await pc.onTapLogout(),
              );
            },
          ),
          Gap(itemGap),
        ],
      ).getcm,
    );
  }

  Widget _getBtnRow() {
    return Row(
      spacing: itemGap * 2,
      children: [
        Expanded(
          child: CustomBtnWTxt(
            isSmall: true,
            btnColor: ctransp,
            borderClr: c.secondary.withOpacity(0.3),
            txtClr: c.primary,
            rad: 12,
            btnTxt: Strings.editProfile,
            isLoading: false,

            onTap: () => Get.toNamed(RoutePaths.editProfile),
          ),
        ),
        // Expanded(
        //   child: CustomBtnWTxt(
        //     isSmall: true,
        //     btnColor: c.primary,
        //     borderClr: c.primary,
        //     txtClr: white,
        //     btnTxt: Strings.share,
        //     rad: 12,
        //     isLoading: isLoading.value,

        //     onTap: () => onTapAction(true),
        //   ),
        // ),
      ],
    );
  }

  int _getAge(DateTime? dob) {
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
    return age;
  }
}
