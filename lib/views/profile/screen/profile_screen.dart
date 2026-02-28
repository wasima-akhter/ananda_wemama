import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/common_components/identity_detail_component.dart';
import '../../../core/common_widgets/models/common_data_models.dart';
import '../../../core/common_widgets/popups.dart';
import '../../../core/network/helpers/network_helpers.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final psc = Get.find<ProfileController>();

    return Obx(
      () => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(itemGap * 3),
            IdentityDetailComponent(
              supplierId: psc.user.value?.id ?? '',
              hasRatingRow: false,
              rightBtnWidet: CustomBtnWTxt(
                // style: TxtStyle.interSemiB(fs: 11, w: 700),
                isSmall: true,
                txtClr: c.textPrimary,
                padding: const EdgeInsets.all(5),
                onTap: () {
                  GNav.pushNamed(RoutePaths.editProfile);
                },
                w: 100,

                btnTxt: Strings.editProfile,
                isLoading: false,
              ),
              isCircle: true,

              identityCardData: IdentityCardDataModel(
                title: psc.username.value,
                phone: psc.phone.value,
                email: psc.email.value,
                avgRating: psc.avgRating.value,
                totalRating: psc.totalRating.value,

                imageUrl: makeImageUrl(imageUrl: storage.getUserInfo.imageUrl ?? ''),

                // imageUrl:
                //     "http://10.10.20.57:8001/uploads/profile-image/virat_image-1769840305600.jpg",
              ),
            ),
            Gap(itemGap * 2),
            ProfileTile(
              title: Strings.accountSettings,
              iconPath: IconsPath.info,
              onTap: () {
                GNav.pushNamed(RoutePaths.accountSettings);
              },
            ),

            Column(
              children: [
                Gap(itemGap * 2),

                ProfileTile(
                  title: Strings.notificationSettings,
                  iconPath: IconsPath.notification,
                  onTap: () {
                    GNav.pushNamed(RoutePaths.notificationSettings);
                  },
                ),
                Gap(itemGap * 2),

                ProfileTile(
                  title: Strings.stationLocation,
                  iconPath: IconsPath.locationBold,
                  onTap: () {
                    GNav.pushNamed(RoutePaths.stationLocation);
                  },
                ),
              ],
            ),

            ///
            ////
            Gap(itemGap * 3),
            Text(Strings.moreSettings, style: TxtStyle.inter(fs: 11, w: 600)),
            Gap(itemGap * 2),
            ProfileTile(
              title: Strings.contactSupport,
              iconPath: IconsPath.info,
              onTap: () {
                GNav.pushNamed(RoutePaths.contactSupport);
              },
            ),
            Gap(itemGap * 2),
            ProfileTile(
              title: Strings.termsCondition,
              iconPath: IconsPath.info,
              onTap: () {
                GNav.pushNamed(RoutePaths.termsAndConditions);
              },
            ),
            Gap(itemGap * 2),
            ProfileTile(
              title: Strings.privacyPolicy,
              iconPath: IconsPath.info,
              onTap: () {
                GNav.pushNamed(RoutePaths.privacyPolicy);
              },
            ),
            Gap(itemGap * 2),
            ProfileTile(
              title: Strings.logOut,
              iconPath: IconsPath.logout,
              iconColor: c.primary,
              onTap: () {
                logoutConfirmDialog(
                  context: context,
                  isLoading: psc.isSignOutLoading_,
                  onConfirm: () async => await psc.onTapLogout(),
                );
              },
            ),
            Gap(itemGap * 2),
          ],
        ).getcm,
      ),
    );
  }
}
