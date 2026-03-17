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
        child: UserDetailComponent(
          isLoading: udc.isLoading_,
          onTapSeeMore: udc.toggleSeeMore,
          onTapAction: (_) async {},
          isSeeMore: udc.isSeeMore,
          isFromProfile: true,
          user: userData,
        ),
      );
    });
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
}
