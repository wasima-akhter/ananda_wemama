import 'dart:async';

import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../main_tabs/home/sub_feature/profile/controller/profile_controller.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../model/new_wave_req_list_item_model.dart';
import '../service/wave_user_profile_info_service.dart';

class WaveRequestController extends GetxController {
  // ── Reconnect management ─────────────────────────────────────────────────
  StreamSubscription? _socketConnectedSub;
  StreamSubscription? _socketDisconnectedSub;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  static const _maxReconnectDelay = Duration(seconds: 30);

  @override
  void onInit() {
    getNewWavesList();

    // ✅ On connect: refresh list + reset backoff
    _socketConnectedSub = socket.onConnected.listen((_) {
      print("🔌 Socket connected — refreshing wave requests");
      _reconnectAttempt = 0;
      _reconnectTimer?.cancel();
      getNewWavesList(forceRefresh: true);
    });

    // ✅ On disconnect: actively try to reconnect instead of just waiting
    _socketDisconnectedSub = socket.onDisconnected.listen((_) {
      print("🔌 Socket disconnected — scheduling reconnect");
      _scheduleReconnect();
    });

    if (!socket.isConnected) {
      _scheduleReconnect(immediate: true);
    }

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

  @override
  void onClose() {
    _socketConnectedSub?.cancel();
    _socketDisconnectedSub?.cancel();
    _reconnectTimer?.cancel();
    super.onClose();
  }

  /// Attempts to reconnect with exponential backoff (capped).
  /// `immediate: true` skips the delay for the first attempt.
  void _scheduleReconnect({bool immediate = false}) {
    if (socket.isConnected) return;

    _reconnectTimer?.cancel();

    final delay = immediate
        ? Duration.zero
        : Duration(
            seconds: (2 << _reconnectAttempt).clamp(
              1,
              _maxReconnectDelay.inSeconds,
            ),
          );

    _reconnectTimer = Timer(delay, () async {
      if (socket.isConnected) return; // already recovered

      print("🔁 Attempting socket reconnect (try ${_reconnectAttempt + 1})");
      _reconnectAttempt++;

      try {
        socket.disconnectSocket();
        await socket.connectSocket();
      } catch (e) {
        print("❌ Reconnect attempt failed: $e");
      }

      if (!socket.isConnected) {
        _scheduleReconnect();
      }
    });
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
    } else {
      rejectUserWave(conversationId);
    }
  }

  // ── Accept success handler ────────────────────────────────────────────────
  void _onAcceptSuccess() {
    _removeFromList(_pendingConversationId);

    showReqAcceptedDialog();

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
    _removeFromList(_pendingConversationId);
  }

  // ── List management ───────────────────────────────────────────────────────
  void updateWaveList(List<NewWaveListItemModel> list) {
    newWaveList.assignAll(list);
  }

  void _removeFromList(String conversationId) {
    newWaveList.removeWhere((item) => item.id == conversationId);
  }

  // ── Emits ─────────────────────────────────────────────────────────────────
  final socket = Get.find<SocketService>();

  void getConversationRequestList(String receiverId) {
    socket.emit(SocketEvents.getConversationRequests, {});
  }

  /// socket-->
  // void acceptUserWave(String conversationId) {
  //   socket.emit(SocketEvents.acceptConversationRequest, {
  //     "conversationId": conversationId,
  //   });
  // }

  // void rejectUserWave(String conversationId) {
  //   socket.emit(SocketEvents.rejectConversationRequest, {
  //     "conversationId": conversationId,
  //   });
  // }

  final isAcceptLoading = false.obs;
  final isRejectLoading = false.obs;

  final service = WaveService();
  Future<void> acceptUserWave(String conversationId) async {
    if (isAcceptLoading.value) return;

    isAcceptLoading.value = true;

    try {
      final success = await service.acceptWaveRequest(
        conversationId: conversationId,
      );

      if (!success) {
        Snack.showError("Couldn't accept the request. Please try again.");
        return;
      }

      newWaveList.removeWhere((e) => e.id == conversationId);
      newWaveList.refresh();

      Get.back();

      Snack.showSuccess("Wave request accepted.");
      // call chat list refresh.
      if (Get.isRegistered<ChatController>()) {
        ChatController.to.getChatList(forceRefresh: true);
      }
    } finally {
      isAcceptLoading.value = false;
    }
  }

  Future<void> rejectUserWave(String conversationId) async {
    if (isRejectLoading.value) return;

    isRejectLoading.value = true;

    try {
      final success = await service.rejectWaveRequest(
        conversationId: conversationId,
      );

      if (!success) {
        Snack.showError("Couldn't decline the request. Please try again.");
        return;
      }

      newWaveList.removeWhere((e) => e.id == conversationId);
      newWaveList.refresh();

      Get.back();

      Snack.showSuccess("Wave request declined.");
    } finally {
      isRejectLoading.value = false;
    }
  }

  //

  // ── Fetch list ────────────────────────────────────────────────────────────
  Future<void> getNewWavesList({bool forceRefresh = false}) async {
    if (isLoading_.value) return;

    // ✅ Not connected? Kick off reconnect and let the onConnected
    // listener retry this call once the socket recovers — mirrors
    // ChatController.getChatList's approach instead of emitting into a
    // dead socket.
    if (!socket.isConnected) {
      print("⏳ getNewWavesList — socket down, scheduling reconnect");
      _scheduleReconnect(immediate: true);
      return;
    }

    isLoading_.value = true;
    try {
      getConversationRequestList(currentProfileId());
    } catch (e) {
      print("Error fetching wave list: $e");
    } finally {
      isLoading_.value = false;
    }
  }

  void unFocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  // API loading state
  var isgetUserProfileLoading_ = false.obs;
  bool get isgetUserProfileLoading => isgetUserProfileLoading_.value;

  final waveUserProfileData = Rxn<ProfileDataModel>();

  Future<void> getUserProfile({required String userId}) async {
    if (isgetUserProfileLoading_.value) return; // Prevent duplicate calls
    isgetUserProfileLoading_.value = true;

    try {
      final data = await WaveService().fetchUserProfile(userId: userId);

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
