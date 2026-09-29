import '../../../../../app/controller_export.dart';
import '../../../../shared/wave_request/service/wave_user_profile_info_service.dart';
import '../services/community_detail_service.dart';

class CommunityActionController extends GetxController {
  static CommunityActionController get to => Get.find();

  // =========================
  // JOIN COMMUNITY
  // =========================

  final isJoinLoading = false.obs;

  Future<bool> joinCommunity(String communityId) async {
    if (isJoinLoading.value) return false;

    isJoinLoading.value = true;

    try {
      return await CommunityDetailService().joinCommunity(
        communityItemId: communityId,
      );
    } finally {
      isJoinLoading.value = false;
    }
  }

  // =========================
  // USER PROFILE
  // =========================

  final RxBool isGetUserProfileLoading = false.obs;
  final Rxn userProfileData = Rxn();

  final RxBool isSeeMore = false.obs;

  /// Clears the currently displayed profile.
  void clearUserProfile() {
    userProfileData.value = null;
    isSeeMore.value = false;
    isGetUserProfileLoading.value = false;
  }

  Future<void> getUserProfile({required String userId}) async {
    // Always clear old profile first.
    clearUserProfile();

    final id = userId.trim();

    // Invalid/empty ID → keep placeholder state.
    if (id.isEmpty) {
      print('[CommunityActionController] User ID is empty.');
      return;
    }

    isGetUserProfileLoading.value = true;

    try {
      final data = await WaveService().fetchUserProfile(userId: id);

      if (data != null) {
        userProfileData.value = data;

        print('[CommunityActionController] Profile fetched: $data');
      } else {
        print('[CommunityActionController] Profile data is null.');
      }
    } catch (e) {
      print('[CommunityActionController] Error fetching profile: $e');
    } finally {
      isGetUserProfileLoading.value = false;
    }
  }
}
