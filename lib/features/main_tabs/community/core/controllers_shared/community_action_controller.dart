import '../../../../../app/controller_export.dart';
import '../../../../shared/wave_request/service/wave_user_profile_info_service.dart';
import '../services/community_detail_service.dart';

class CommunityActionController extends GetxController {
  static CommunityActionController get to => Get.find();
  final isJoinLoading = false.obs;

  Future<bool> joinCommunity(String communityId) async {
    if (isJoinLoading.value) return false;

    isJoinLoading.value = true;

    try {
      final success = await CommunityDetailService().joinCommunity(
        communityItemId: communityId,
      );

      return success;
    } finally {
      isJoinLoading.value = false;
    }
  }

  // =========================
  // USER PROFILE
  // =========================

  final isGetUserProfileLoading = false.obs;
  final userProfileData = Rxn();

  final isSeeMore = false.obs;

  Future<void> getUserProfile({required String userId}) async {
    if (isGetUserProfileLoading.value) return;

    // Clear previous user's data
    userProfileData.value = null;

    // Reset See More state
    isSeeMore.value = false;

    isGetUserProfileLoading.value = true;

    try {
      final data = await WaveService().fetchUserProfile(userId: userId);

      if (data != null) {
        userProfileData.value = data;

        log('Profile fetched: $data');
      } else {
        log('Profile data is null');
      }
    } catch (e) {
      log('Error fetching profile: $e');
    } finally {
      isGetUserProfileLoading.value = false;
    }
  }
}
