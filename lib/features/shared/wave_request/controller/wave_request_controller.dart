import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../model/new_wave_req_list_item_model.dart';
import '../service/wave_user_profile_info_service.dart';

class WaveRequestController extends GetxController {
  var fakeNewWavesList = [
    FakeNewWavesModel(id: "1", name: "Alice", time: "2h ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "2", name: "Bob", time: "4min ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "3", name: "Charlie", time: "yesterday", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "4", name: "Diana", time: "22 Jan 2026", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "5", name: "Eve", time: "1 Jan 2026", imageUrl: Strings.fakeImageUrl),
  ];

  @override
  void onInit() {
    getNewWavesList();

    ever(newWaveList, (callback) {
      // show the list anew after it changed.
    });
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  final isSuccessAccept = false.obs;
  Future<void> onTapAction(bool isAccepted, {required String conversationId}) async {
    Get.back();

    if (isAccepted) {
      // first trigger the emit of acceptation
      //
      acceptUserWave(conversationId);

      // listen method is success,
      // then show:

      if (isSuccessAccept.value) {
        // show popup
        showReqAcceptedDialog();
        Future.delayed(Duration(seconds: 3), () {
          Get.back();

          final myImageUrl = currentUserImage();
          final peerImageUrl = '';
          final peerName = '';

          showBothConnectedDialog(
            myImageUrl: myImageUrl,
            peerImageUrl: peerImageUrl,
            peerName: peerName,
          );
        });
      }
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final newWaveList = <NewWaveListItemModel>[].obs;

  /// Fetch the latest  data from API
  Future<void> getNewWavesList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    debugPrint(' getNewWavesList.. ');

    try {
      final currentUserId = currentProfileId();
      getConversationRequestList(currentUserId);
      // final data = await ChatService().fetchChatList(

      // );

      // if (data != null) {

      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }

  void updateWaveList(List<NewWaveListItemModel> list) {
    newWaveList.assignAll(list);
  }

  final socket = Get.find<SocketService>();
  void getConversationRequestList(String receiverId) {
    socket.emit(SocketEvents.getConversationRequests, {"receiverId": receiverId});
  }

  void acceptUserWave(String conversationId) {
    socket.emit(SocketEvents.acceptConversationRequest, {"conversationId": conversationId});
  }

  // API loading state
  var isgetUserProfileLoading_ = false.obs;
  bool get isgetUserProfileLoading => isgetUserProfileLoading_.value;

  final waveUserProfileData = Rxn<ProfileDataModel>();
  //// get wave user details
  ///
  /// Fetch the latest profile from API
  Future<void> getUserProfile({required String userId}) async {
    if (isgetUserProfileLoading_.value) return; // Prevent duplicate calls
    isgetUserProfileLoading_.value = true;

    try {
      final data = await WaveUserProfileInfoService().fetchUserProfile(userId: userId);

      if (data != null) {
        waveUserProfileData.value = data;
        print("data fetching profile: ${(data)}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isgetUserProfileLoading_.value = false;
    }
  }

  ///
}

class FakeNewWavesModel {
  final String id;
  final String name;
  final String time;
  final String imageUrl;

  FakeNewWavesModel({
    required this.name,
    required this.time,
    required this.imageUrl,
    required this.id,
  });
}
