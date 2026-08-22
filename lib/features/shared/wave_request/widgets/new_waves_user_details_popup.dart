import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:we_mama/core/components/app_ui/components/user_detaIl_component/ui/user_detail_component.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/small_popup_dialog.dart';
import '../../../../core/helpers/widgets_helper.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../../main_tabs/home/sub_feature/profile/widgets/profile_shimmer.dart';
import '../../subscription/subscription_access/premium_access_service.dart';
import '../../subscription/subscription_access/premium_gate.dart';

class NewWavesUserDetailsPopup extends StatelessWidget {
  final Rxn<ProfileDataModel> user;
  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final Future<void> Function(bool isAccepted) onTapAction;
  final RxBool isSeeMore;
  final RxBool isAcceptLoading;
  final RxBool isRejectLoading;

  const NewWavesUserDetailsPopup({
    super.key,
    required this.user,
    required this.isLoading,
    required this.isSeeMore,
    required this.onTapSeeMore,
    required this.onTapAction,
    required this.isAcceptLoading,
    required this.isRejectLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userValue = user.value;

      if (isLoading.value) {
        return LargePopupDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const ProfileShimmer()],
          ),
        );
      }

      if (userValue == null) {
        return LargePopupDialog(
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "Failed to load user",
                    style: TxtStyle.outfitSmNor,
                  ),
                ),

                Positioned(
                  top: 2,
                  right: 10,
                  child: CusGestureDetector(
                    onTap: () => Get.back(),
                    child: SvgIcon(iconPath: IconsPath.closeCircle, height: 20),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      final userData = mapToUserModel(userValue);

      final isPremium = PremiumAccessService.to.isPremiumUser.value;

      return LargePopupDialog(
        child: BounceSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (kDebugMode) Text(user.value?.email ?? ''),

              Stack(
                children: [
                  IgnorePointer(
                    ignoring: !isPremium,
                    child: UserDetailComponent(
                      user: userData,
                      isLoading: isLoading,
                      onTapSeeMore: onTapSeeMore,
                      isSeeMore: isSeeMore,
                    ),
                  ),
                  if (!isPremium)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Colors.white.withValues(alpha: .15),
                            height: double.infinity,
                            child: Stack(
                              children: [
                                // Close button
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: CusGestureDetector(
                                    onTap: () => Get.back(),
                                    child: SvgIcon(
                                      iconPath: IconsPath.closeCircle,
                                      height: 20,
                                    ),
                                  ),
                                ),

                                // Center content
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Upgrade to Premium to view profile",
                                        style: TxtStyle.outfitSmTitle.copyWith(
                                          color: c.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Gap(20),
                                      CusGestureDetector(
                                        onTap: () {
                                          Get.back();
                                          Get.toNamed(
                                            RoutePaths.subscriptionUpgrade,
                                          );
                                        },
                                        child: ContainerBordered(
                                          vp: 8,
                                          mh: 12,
                                          contClr: c.primary,
                                          child: Text(
                                            "Upgrade",
                                            style: TxtStyle.outfitSmTitle
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                  color: white,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // UserDetailComponent(
              //   user: userData,
              //   isLoading: isLoading,
              //   onTapSeeMore: onTapSeeMore,
              //   isSeeMore: isSeeMore,
              // ),
              _getDeclineAcceptBtnRow(),
            ],
          ),
        ),
      );
    });
  }

  Widget _getDeclineAcceptBtnRow() {
    return PremiumLock(
      child: Row(
        spacing: itemGap * 2,
        children: [
          Expanded(
            child: CustomBtnWTxt(
              isSmall: true,
              btnColor: ctransp,
              borderClr: c.primary,
              txtClr: c.textSecondary,
              rad: 12,
              btnTxt: Strings.decline,
              isLoading: isRejectLoading.value,
              onTap: () => onTapAction(false),
            ),
          ),
          Expanded(
            child: CustomBtnWTxt(
              isSmall: true,
              btnColor: c.primary,
              borderClr: c.primary,
              txtClr: white,
              btnTxt: Strings.accept,
              rad: 12,
              isLoading: isAcceptLoading.value,
              onTap: () => onTapAction(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String iconPath;
  final String text;

  _InfoRow({required this.iconPath, required this.text});
}
