import 'package:mama_app/core/common_widgets/common_components/tag_type_widgets.dart';
import 'package:mama_app/core/common_widgets/cus_flexible_dropdown.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/common_widgets/common_components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../../../../core/common_widgets/common_components/user_detaIl_component/ui/user_detail_component.dart';
import '../../../../../../core/helpers/widgets_helper.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';
import 'profile_shimmer.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.pc, required this.udc});

  final ProfileController pc;
  final UserDetailController udc;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pc.isLoading_.value) return const ProfileShimmer();

      final userData = _mapToUserModel(pc.userProfileData.value);

      return ContainerBordered(
        hasBrdr: true,
        brdrClr: c.secondary.withOpacity(0.3),
        contClr: c.inputBackground,
        child: Column(
          children: [
            Gap(4.h),
            _buildInactiveInfo(),
            Text(pc.userProfileData.value?.email ?? ''),
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

  FakeUserDetailsModel? _mapToUserModel(ProfileDataModel? data) {
    if (data == null) return null;

    return FakeUserDetailsModel(
      imageUrl: data.profileImage ?? '',
      name: data.name ?? '',
      age: _calculateAge(data.dob),
      aboutMe: data.bio ?? '',
      galleryImages: data.images,
      children: data.children.map((e) => getChildAge(e.dob.toString())).toList(),
      infoList: _buildInfoList(data),
    );
  }

  List<UiInfoItem> _buildInfoList(ProfileDataModel data) {
    final List<UiInfoItem> list = [];
    final coords = data.location?.coordinates;

    if (coords != null && coords.length >= 2) {
      list.add(
        UiInfoItem(
          iconPath: IconsPath.locationBold,
          text: "${data.city ?? ''}, ${data.state ?? ''}",
        ),
      );
    }

    if (data.mumStage != null) {
      list.add(UiInfoItem(iconPath: IconsPath.chartFilled, text: data.mumStage!));
    }

    if (data.interesteds.isNotEmpty) {
      list.add(UiInfoItem(iconPath: IconsPath.heartHalfFilled, text: data.interesteds.join(', ')));
    }

    return list;
  }

  int _calculateAge(DateTime? dob) {
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
    return age;
  }

  Widget _buildInactiveInfo() {
    final overlayHeight = 10.h;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ActiveTag(isActive: false),
        Gap(itemGap),
        CusFlexibleDropdown(
          items: [],

          offset: Offset(0, overlayHeight),
          customOverlay: Container(
            margin: EdgeInsets.only(left: S.w * 0.2, right: S.w * 0.07),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            backgroundColor: c.bottomSheetBackground.withOpacity(0.5),
                            radius: 9,
                            child: SvgIconColored(
                              iconPath: IconsPath.curvedInfo,
                              iconColor: c.primary.withOpacity(0.5),
                              height: 11,
                            ),
                          ),
                          Gap(4.w),
                          Text(
                            Strings.youAreInactiveNow,
                            style: TxtStyle.interSemiB(
                              fs: 13,
                              w: 600,
                              color: c.primary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      Gap(5.h),

                      Text(
                        Strings.inactiveNotVisible,
                        style: TxtStyle.interSemiB(
                          fs: 10,
                          w: 400,
                          color: c.primary.withOpacity(0.5),
                        ),
                      ),
                      Gap(5.h),
                      Text(
                        Strings.enableLocationForMatching,
                        style: TxtStyle.interSemiB(fs: 10, w: 400, color: c.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: ActiveInfo(isActive: false),
        ),
      ],
    );
  }
}
