import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/ui/dialogs/popups.dart';
import '../../../modules/profile_tile.dart';
import '../controller/profile_controller.dart';

class ProfileSettingsTiles extends StatelessWidget {
  const ProfileSettingsTiles({super.key, required this.pc});

  final ProfileController pc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileTile(
          title: Strings.managePassword,
          iconPath: IconsPath.security,
          tileClr: c.inputBackground,
          onTap: () => Get.toNamed(RoutePaths.changePassword),
        ),

        Gap(itemGap),

        ProfileTile(
          title: Strings.blockedUser,
          iconPath: IconsPath.blockedUser,
          tileClr: c.inputBackground,
          onTap: () => Get.toNamed(RoutePaths.blockedUser),
        ),

        Gap(itemGap),

        ProfileTile(
          title: Strings.subscription,
          iconPath: IconsPath.starFilled,
          tileClr: c.inputBackground,
          onTap: () => Get.toNamed(RoutePaths.subscriptionInfo),
        ),

        Gap(itemGap),

        ProfileTile(
          title: Strings.about,
          iconPath: IconsPath.info,
          tileClr: c.inputBackground,
          onTap: () => Get.toNamed(RoutePaths.about),
        ),

        Gap(itemGap),

        ProfileTile(
          title: Strings.logOut,
          iconPath: IconsPath.logout,
          iconColor: c.error,
          tileClr: c.inputBackground,
          onTap: () => logoutConfirmDialog(
            isLoading: pc.isSignOutLoading_,
            onConfirm: pc.onTapLogout,
          ),
        ),
        Gap(itemGap),

        ProfileTile(
          title: Strings.deleteAccount,
          iconPath: Assets.icons.deleteNew,
          iconColor: c.error,
          tileClr: c.inputBackground,
          onTap: () => deleteAccountConfirmDialog(
            isLoading: pc.isDeleteAccountLoading_,
            onConfirm: pc.onTapDeteteAccount,
          ),
        ),
      ],
    );
  }
}
