import 'package:flutter/foundation.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../../../../core/components/app_ui/components/user_detaIl_component/ui/user_detail_component.dart';
import '../../../../../../core/helpers/widgets_helper.dart';
import '../controller/profile_controller.dart';
import '../modules/location_status/active_info_dropdown.dart';
import 'profile_shimmer.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.pc, required this.udc});

  final ProfileController pc;
  final UserDetailController udc;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pc.isLoading_.value) return const ProfileShimmer();

      final userData = mapToUserModel(pc.userProfileData.value);

      return ContainerBordered(
        hasBrdr: true,
        brdrClr: c.secondary.withOpacity(0.3),
        contClr: c.inputBackground,
        child: Column(
          children: [
            Gap(4.h),
            _buildInactiveInfo(),
            if (kDebugMode) Text(pc.userProfileData.value?.email ?? ''),

            UserDetailComponent(
              isLoading: udc.isLoading_,
              onTapSeeMore: udc.toggleSeeMore,
              onTapAction: (_) async {},
              isSeeMore: udc.isSeeMore,
              isFromProfile: true,
              user: userData,
            ),

            Gap(itemGap),

            _buildEditProfileButton(),
            Gap(itemGap * 2),
          ],
        ),
      );
    });
  }

  Widget _buildEditProfileButton() {
    return Row(
      children: [
        Expanded(
          child: CustomBtnWTxt(
            isLoading: false,
            isSmall: true,
            btnColor: ctransp,
            borderClr: c.secondary,
            txtClr: c.primary,
            rad: 12,
            btnTxt: Strings.editProfile,
            onTap: () => Get.toNamed(RoutePaths.editProfile),
          ),
        ),
      ],
    );
  }

  Widget _buildInactiveInfo() {
    return const ActiveInfoDropdown();
  }

  /*
  Widget _buildInactiveInfo() {
    final alm = AppLocationManager.to;

    final overlayHeight = 10.h;

    return Obx(() {
      final isActive = alm.isLocationActive.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ActiveTag(isActive: isActive),

          Gap(itemGap),

          CusFlexibleDropdown(
            items: [],
            offset: Offset(0, overlayHeight),

            customOverlay: Container(
              margin: EdgeInsets.only(left: S.w * 0.2, right: S.w * 0.07),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ContainerBordered(
                    vp: 16,
                    hp: 12,
                    contClr: c.scaffoldBackground,
                    rad: 18,
                    boxShadow: boxShadowAllSides,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isActive
                                  ? c.primary.withOpacity(0.12)
                                  : c.bottomSheetBackground.withOpacity(0.5),

                              radius: 9,

                              child: SvgIconColored(
                                iconPath: IconsPath.curvedInfo,

                                iconColor: isActive
                                    ? c.primary
                                    : c.primary.withOpacity(0.5),

                                height: 11,
                              ),
                            ),

                            Gap(4.w),

                            isActive
                                ? Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "You are active now",
                                          style: TxtStyle.interSemiB(
                                            fs: 13,
                                            w: 600,
                                            color: c.primary,
                                          ),
                                        ),
                                        CusGestureDetector(
                                          onTap: () async {
                                            final success =
                                                await AppLocationManager.to
                                                    .disableLocation();

                                            if (success) {
                                              AppLocationManager
                                                      .to
                                                      .isLocationActive
                                                      .value =
                                                  false;

                                              Get.back();

                                              Snack.showWarning(
                                                "Location disabled. You are now inactive.",
                                              );
                                            }
                                          },
                                          child: ContainerBordered(
                                            rad: 30,
                                            contClr: c.cardReminder.withValues(
                                              alpha: 0.5,
                                            ),
                                            vp: 2.5,
                                            hp: 9,
                                            child: Text(
                                              "Disable",
                                              style: TxtStyle.outfitSemiB(
                                                fs: 13,
                                                w: 400,
                                                color: c.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Strings.youAreInactiveNow,
                                          style: TxtStyle.interSemiB(
                                            fs: 13,
                                            w: 600,
                                            color: c.primary.withOpacity(0.5),
                                          ),
                                        ),
                                        CusGestureDetector(
                                          onTap: () async {
                                            final result =
                                                await AppLocationManager.to
                                                    .enableLocationGateway();
                                            Get.back();
                                            Get.back();

                                            if (result ==
                                                LocationFlowResult.success) {
                                              Snack.showSuccess(
                                                "Location enabled",
                                              );
                                            } else {
                                              Snack.showError(
                                                "Please enable location fully",
                                              );
                                            }
                                          },
                                          child: ContainerBordered(
                                            rad: 30,
                                            contClr: c.primary,
                                            vp: 2.5,
                                            hp: 9,
                                            child: Text(
                                              "Enable",
                                              style: TxtStyle.outfitSemiB(
                                                fs: 13,
                                                w: 400,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),

                        Gap(5.h),

                        Text(
                          isActive
                              ? "Nearby moms can discover you now."
                              : Strings.inactiveNotVisible,

                          style: TxtStyle.interSemiB(
                            fs: 10,
                            w: 400,
                            color: c.primary,
                          ),
                        ),

                        if (!isActive) ...[
                          Gap(5.h),

                          Text(
                            Strings.enableLocationForMatching,

                            style: TxtStyle.interSemiB(
                              fs: 10,
                              w: 400,
                              color: c.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            child: ActiveInfo(isActive: isActive),
          ),
        ],
      );
    });
  }
*/
}
