import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../model/new_wave_req_list_item_model.dart';
import '../service/wave_user_profile_info_service.dart';

//
// class WaveRequestController extends GetxController {
//   var fakeNewWavesList = [
//     FakeNewWavesModel(id: "1", name: "Alice", time: "2h ago", imageUrl: Strings.fakeImageUrl),
//     FakeNewWavesModel(id: "2", name: "Bob", time: "4min ago", imageUrl: Strings.fakeImageUrl),
//     FakeNewWavesModel(id: "3", name: "Charlie", time: "yesterday", imageUrl: Strings.fakeImageUrl),
//     FakeNewWavesModel(id: "4", name: "Diana", time: "22 Jan 2026", imageUrl: Strings.fakeImageUrl),
//     FakeNewWavesModel(id: "5", name: "Eve", time: "1 Jan 2026", imageUrl: Strings.fakeImageUrl),
//   ];

//   @override
//   void onInit() {
//     getNewWavesList();

//     ever(newWaveList, (callback) {
//       // show the list anew after it changed.
//     });
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }

//   void clearAll() {}

//   void unFocusAll() {
//     FocusManager.instance.primaryFocus?.unfocus();
//   }

//   final isSuccessAccept = false.obs;

//   final peerImageUrl = ''.obs;
//   final peerName = ''.obs;

//   Future<void> onTapAction(bool isAccepted, {required String conversationId}) async {
//     Get.back();

//     if (isAccepted) {
//       // first trigger the emit of acceptation
//       //
//       acceptUserWave(conversationId);

//       // listen method is success,
//       // then show:

//       if (isSuccessAccept.value) {
//         // show popup
//         showReqAcceptedDialog();
//         Future.delayed(Duration(seconds: 3), () {
//           Get.back();

//           final myImageUrl = currentUserImage();

//           showBothConnectedDialog(
//             myImageUrl: myImageUrl,
//             peerImageUrl: peerImageUrl.value,
//             peerName: peerName.value,
//             conversationId: conversationId,
//           );
//         });
//       }
//     } else {
//       // if rejected
//       rejectUserWave(conversationId);
//     }
//   }

//   // API loading state
//   var isLoading_ = false.obs;
//   bool get isLoading => isLoading_.value;

//   final newWaveList = <NewWaveListItemModel>[].obs;

//   /// Fetch the latest  data from API
//   Future<void> getNewWavesList() async {
//     if (isLoading_.value) return; // Prevent duplicate calls
//     isLoading_.value = true;

//     log(' getNewWavesList.. ');

//     try {
//       final currentUserId = currentProfileId();
//       getConversationRequestList(currentUserId);
//       // final data = await ChatService().fetchChatList(

//       // );

//       // if (data != null) {

//       // }
//     } catch (e) {
//       log("Error fetching profile: $e");
//     } finally {
//       isLoading_.value = false;

//       unFocusAll();
//     }
//   }

//   void updateWaveList(List<NewWaveListItemModel> list) {
//     newWaveList.assignAll(list);
//   }

//   final socket = Get.find<SocketService>();
//   void getConversationRequestList(String receiverId) {
//     socket.emit(SocketEvents.getConversationRequests, {"receiverId": receiverId});
//   }

//   void acceptUserWave(String conversationId) {
//     socket.emit(SocketEvents.acceptConversationRequest, {"conversationId": conversationId});
//   }

//   void rejectUserWave(String conversationId) {
//     socket.emit(SocketEvents.rejectConversationRequest, {"conversationId": conversationId});
//   }

//   // API loading state
//   var isgetUserProfileLoading_ = false.obs;
//   bool get isgetUserProfileLoading => isgetUserProfileLoading_.value;

//   final waveUserProfileData = Rxn<ProfileDataModel>();
//   //// get wave user details
//   ///
//   /// Fetch the latest profile from API
//   Future<void> getUserProfile({required String userId}) async {
//     if (isgetUserProfileLoading_.value) return; // Prevent duplicate calls
//     isgetUserProfileLoading_.value = true;

//     try {
//       final data = await WaveUserProfileInfoService().fetchUserProfile(userId: userId);

//       if (data != null) {
//         waveUserProfileData.value = data;
//         log("data fetching profile: ${(data)}");
//       }
//     } catch (e) {
//       log("Error fetching profile: $e");
//     } finally {
//       isgetUserProfileLoading_.value = false;
//     }
//   }

//   ///
// }
//
class WaveRequestController extends GetxController {
  @override
  void onInit() {
    getNewWavesList();

    // ── React to socket success flags ─────────────────────────────────────────
    ever(isSuccessAccept, (bool success) {
      if (!success) return;
      _onAcceptSuccess();
      isSuccessAccept.value = false; // reset
    });

    ever(isSuccessReject, (bool success) {
      if (!success) return;
      _onRejectSuccess();
      isSuccessReject.value = false; // reset
    });

    super.onInit();
  }

  // ── State ─────────────────────────────────────────────────────────────────
  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final isSuccessAccept = false.obs;
  final isSuccessReject = false.obs;

  final peerImageUrl = ''.obs;
  final peerName = ''.obs;

  final newWaveList = <NewWaveListItemModel>[].obs;

  // Tracks which conversationId is currently being acted on
  String _pendingConversationId = '';

  // ── onTapAction ───────────────────────────────────────────────────────────
  Future<void> onTapAction(
    bool isAccepted, {
    required String conversationId,
  }) async {
    Get.back(); // close bottom sheet

    _pendingConversationId = conversationId;

    if (isAccepted) {
      acceptUserWave(conversationId);
      // ✅ Result handled reactively in ever(isSuccessAccept)
    } else {
      rejectUserWave(conversationId);
      // ✅ Result handled reactively in ever(isSuccessReject)
    }
  }

  // ── Accept success handler ────────────────────────────────────────────────
  void _onAcceptSuccess() {
    // 1. Remove from local list
    _removeFromList(_pendingConversationId);

    // 2. Show accepted dialog
    showReqAcceptedDialog();

    // 3. After delay → show both connected dialog
    Future.delayed(const Duration(seconds: 3), () {
      Get.back(); // close accepted dialog

      showBothConnectedDialog(
        myImageUrl: Get.find<ProfileController>().myImageUrl,
        peerImageUrl: peerImageUrl.value,
        peerName: peerName.value,
        conversationId: _pendingConversationId,
      );
    });
  }

  // ── Reject success handler ────────────────────────────────────────────────
  void _onRejectSuccess() {
    // Remove from local list silently
    _removeFromList(_pendingConversationId);
  }

  // ── List management ───────────────────────────────────────────────────────
  void updateWaveList(List<NewWaveListItemModel> list) {
    /*

   // fake data

      newWaveList.value = <NewWaveListItemModel>[
  NewWaveListItemModel(
    id: 'wave_1',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    updatedAt: DateTime.now(),
    v: 1,
    participants: [
      Participant(
        id: 'p1',
        name: 'Ayesha Rahman',
        profileImage: '',
      ),
      Participant(
        id: 'p2',
        name: 'Nusrat Jahan',
        profileImage: '',
      ),
    ],
  ),

  NewWaveListItemModel(
    id: 'wave_2',
    status: 'active',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
    v: 1,
    participants: [
      Participant(
        id: 'p3',
        name: 'Sarah Ahmed',
        profileImage: '',
      ),
      Participant(
        id: 'p4',
        name: 'Mim Akter',
        profileImage: '',
      ),
      Participant(
        id: 'p5',
        name: 'Fatema Khatun',
        profileImage: '',
      ),
    ],
  ),

  NewWaveListItemModel(
    id: 'wave_3',
    status: 'inactive',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    v: 1,
    participants: [
      Participant(
        id: 'p6',
        name: 'Nadia Islam',
        profileImage: '',
      ),
    ],
  ),
];
*/
    newWaveList.assignAll(list);
  }

  void _removeFromList(String conversationId) {
    newWaveList.removeWhere((item) => item.id == conversationId);
  }

  // ── Emits ─────────────────────────────────────────────────────────────────
  final socket = Get.find<SocketService>();

  void getConversationRequestList(String receiverId) {
    socket.emit(SocketEvents.getConversationRequests, {
      
    });
  }

  void acceptUserWave(String conversationId) {
    socket.emit(SocketEvents.acceptConversationRequest, {
      "conversationId": conversationId,
    });
  }

  void rejectUserWave(String conversationId) {
    socket.emit(SocketEvents.rejectConversationRequest, {
      "conversationId": conversationId,
    });
  }

  // ── Fetch list ────────────────────────────────────────────────────────────
  Future<void> getNewWavesList() async {
    if (isLoading_.value) return;
    isLoading_.value = true;
    try {
      getConversationRequestList(currentProfileId());
    } catch (e) {
      log("Error fetching wave list: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  void unFocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  //   // API loading state
  var isgetUserProfileLoading_ = false.obs;
  bool get isgetUserProfileLoading => isgetUserProfileLoading_.value;
  //// get wave user details
  ///
  /// Fetch the latest profile from API
  ///
  final waveUserProfileData = Rxn<ProfileDataModel>();

  ///
  Future<void> getUserProfile({required String userId}) async {
    if (isgetUserProfileLoading_.value) return; // Prevent duplicate calls
    isgetUserProfileLoading_.value = true;

    try {
      final data = await WaveUserProfileInfoService().fetchUserProfile(
        userId: userId,
      );

      if (data != null) {
        waveUserProfileData.value = data;
        log("data fetching profile: ${(data)}");
      }
    } catch (e) {
      log("Error fetching profile: $e");
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
