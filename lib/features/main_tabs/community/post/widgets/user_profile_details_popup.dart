import 'package:flutter/foundation.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/app_ui/components/user_detaIl_component/ui/user_detail_component.dart';
import '../../../../../core/components/ui/dialogs/small_popup_dialog.dart';
import '../../../../../core/helpers/widgets_helper.dart';
import '../../../../main_tabs/home/sub_feature/profile/widgets/profile_shimmer.dart';
import '../../core/controllers_shared/community_action_controller.dart';

class ProfileDetailsPopup extends StatefulWidget {
  final String userId;

  const ProfileDetailsPopup({super.key, required this.userId});

  @override
  State<ProfileDetailsPopup> createState() => _ProfileDetailsPopupState();
}

class _ProfileDetailsPopupState extends State<ProfileDetailsPopup> {
  final controller = CommunityActionController.to;

  @override
  void initState() {
    super.initState();

    print('userId: in prodile popup: ${widget.userId}');

    // Always clear previous profile when opening popup.
    controller.clearUserProfile();

    if (widget.userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        controller.getUserProfile(userId: widget.userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isGetUserProfileLoading.value;
      final userValue = controller.userProfileData.value;

      // =========================
      // LOADING
      // =========================

      if (isLoading) {
        return LargePopupDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [ProfileShimmer()],
          ),
        );
      }

      // =========================
      // EMPTY / FAILED
      // =========================

      if (userValue == null) {
        return LargePopupDialog(
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 40,
                        color: c.textSecondary,
                      ),

                      Gap(itemGap),

                      Text(
                        'Profile information is unavailable',
                        style: TxtStyle.outfit(
                          fs: 13,
                          w: 500,
                          color: c.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                _buildCloseButton(),
              ],
            ),
          ),
        );
      }

      // =========================
      // PROFILE DATA
      // =========================

      final userData = mapToUserModel(userValue);

      return LargePopupDialog(
        child: BounceSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (kDebugMode)
                Text(
                  userValue?.email ?? '',
                  style: TxtStyle.outfit(fs: 10, color: c.textSecondary),
                ),

              Stack(
                children: [
                  UserDetailComponent(
                    user: userData,
                    isLoading: controller.isGetUserProfileLoading,
                    onTapSeeMore: controller.isSeeMore.toggle,
                    isSeeMore: controller.isSeeMore,
                  ),
                  //
                  // _buildCloseButton(),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 2,
      right: 2,
      child: CusGestureDetector(
        onTap: () => Get.back(),
        child: SvgIcon(iconPath: IconsPath.closeCircle, height: 20),
      ),
    );
  }
}
