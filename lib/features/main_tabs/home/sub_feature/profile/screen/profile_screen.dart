import 'package:mama_app/core/common_widgets/common_components/user_detaIl_component/user_detail_component.dart';
import 'package:mama_app/core/common_widgets/common_components/user_detaIl_component/user_detail_controller/user_detail_controller.dart';
import 'package:mama_app/features/main_tabs/home/modules/profile_tile.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/common_widgets/popups.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pc = Get.find<ProfileController>();
    final udc = Get.find<UserDetailController>();

    final setupProfileFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.profile),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerBordered(
            hasBrdr: true,
            brdrClr: c.secondary.withOpacity(0.3),
            contClr: c.inputBackground,
            child: UserDetailComponent(
              isLoading: udc.isLoading_,
              onTapSeeMore: udc.toggleSeeMore,
              onTapAction: (isAccepted) async {},
              isSeeMore: udc.isSeeMore,
              user: udc.fakeUserDetails,
              isFromProfile: true,
            ),
          ),

          Gap(itemGap * 2),

          _getBtnRow(),

          Gap(itemGap * 2),

          ProfileTile(
            title: Strings.managePassword,
            iconPath: IconsPath.security, 
            onTap: () => Get.toNamed(RoutePaths.changePassword),
          ),
          Gap(itemGap ),
          ProfileTile(
            title: Strings.blockedUser,
            iconPath: IconsPath.userOutlined, 
            onTap: () => Get.toNamed(RoutePaths.changePassword),
          ),
          Gap(itemGap ),
          ProfileTile(
            title: Strings.subscription,
            iconPath: IconsPath.starFilled, 
            onTap: () => Get.toNamed(RoutePaths.subscriptionUpgrade),
          ),
          Gap(itemGap ),
          ProfileTile(
            title: Strings.logOut,
            iconPath: IconsPath.logout,
            iconColor: c.error, 
            onTap: () {
                  logoutConfirmDialog(
                    
                    isLoading: pc.isSignOutLoading_,
                    onConfirm: () async => await pc.onTapLogout(),
                  );
            },
          ),
          Gap(itemGap ),
           

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
}
