import '../../../../app/controller_export.dart';
import '../services/community_detail_service.dart';

class CommunityActionController extends GetxController {
  final isJoinLoading = false.obs;

  Future<bool> joinCommunity(String communityId) async {
    if (isJoinLoading.value) return false;

    isJoinLoading.value = true;

    try {
      final success = await CommunityDetailService().joinCommunity(communityItemId: communityId);

      return success;
    } finally {
      isJoinLoading.value = false;
    }
  }
}
