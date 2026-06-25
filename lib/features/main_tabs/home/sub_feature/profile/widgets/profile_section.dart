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
        brdrClr: c.secondary.withValues(alpha: 0.3),
        contClr: c.inputBackground,
        child: Column(
          children: [
            Gap(4.h),
            _buildInactiveInfo(),
            if (kDebugMode) Text(pc.userProfileData.value?.email ?? ''),

            UserDetailComponent(
              isLoading: udc.isLoading_,
              onTapSeeMore: udc.toggleSeeMore,

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
}
