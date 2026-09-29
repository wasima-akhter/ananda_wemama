import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:we_mama/core/helpers/date_helper.dart';
import 'package:we_mama/core/helpers/widgets_helper.dart';
import 'package:we_mama/core/utils/extension/string_extension.dart';
import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';
import 'package:we_mama/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/app_ui/popup_widgets/block_user_dialog.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/helpers/image_helper.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../../core/utils/paginator/paginator.dart';
import '../../../more/blocked_user/service/blocked_user_service.dart';
import '../../../shared/wave_request/service/wave_user_profile_info_service.dart';
import '../../home/sub_feature/profile/model/profile_model.dart';
import '../model/chat_inbox_msg_item_model.dart';
import '../service/chat_inbox_service.dart';

class ChatInboxController extends GetxController {
  final ChatInboxArgPassModel args;

  ChatInboxController(this.args);

  String get chatId => args.chatId;

  static ChatInboxController get to => ChatInboxController.to;

  final isBlockedRx = false.obs;
  bool get isBlocked => isBlockedRx.value;

  final msgInputController = TextEditingController();
  final msgInputFocus = FocusNode();
  final scrollController = ScrollController();

  // ── State ────────────────────────────────────────────────────────────────

  final isSending_ = false.obs; // ← separate sending state
  bool get isSending => isSending_.value;

  // ── Messages via REST pagination ────────────────────────────────────────

  late final Paginator<Message> messagesPaginator;
  RxList<Message> get messages => messagesPaginator.items;

  bool get isLoading => messagesPaginator.isLoading.value;
  RxBool get isLoading_ => messagesPaginator.isLoading;

  final realChatInboxMsgItem = ChatInboxMessageItemModel().obs;

  //
  StreamSubscription? _socketConnectedSub;
  StreamSubscription? _socketDisconnectedSub;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  static const _maxReconnectDelay = Duration(seconds: 30);
  Worker? _tabWorker;
  // ── Init / Close ─────────────────────────────────────────────────────────

  @override
  void onInit() async {
    super.onInit();

    print("chatId: $chatId");
    print("isBlocked: $isBlocked");
    isBlockedRx.value = args.isBlocked;
    // emitGetMessages();

    // Join this conversation
    joinConversation();

    // Auto-send hello after messages load

    messagesPaginator = Paginator<Message>(
      fetchPage: (page, limit) async {
        final result = await ChatInboxService().fetchMessagesPaged(
          conversationId: chatId,
          page: page,
          limit: limit,
        );

        // side effects: keep receiver / block status in sync
        realChatInboxMsgItem.value = result.item;
        final blocked = result.item.conversation?.isBlocked;
        if (blocked != null) isBlockedRx.value = blocked;

        return PaginatedResult<Message>(
          data: result.messages,
          meta: result.meta,
        );
      },
    );

    await getMessages();
    print('getMessages -->scrollToLast called ');
    scrollToLast();

    //

    _socketConnectedSub = socket.onConnected.listen((_) {
      print("🔌 ChatInbox socket connected");

      _reconnectAttempt = 0;
      _reconnectTimer?.cancel();

      // optional: refresh messages when reconnect happens
      getMessages();
    });

    _socketDisconnectedSub = socket.onDisconnected.listen((_) {
      print("🔌 ChatInbox socket disconnected");
      _scheduleReconnect();
    });

    if (args.autoHello) {
      ever(messagesPaginator.isLoading, (bool loading) {
        if (!loading && messages.isEmpty) {
          msgInputController.text = "Hello 👋";
          onTapSendMsg();
        }
      });
    }
  }

  void joinConversation() {
    if (!socket.isConnected) {
      print("⚠️ Cannot join conversation: socket disconnected");
      return;
    }

    print("➡️ Joining conversation: $chatId");

    socket.emit(SocketEvents.joinConversation, {"conversationId": chatId});
  }

  //
  final socket = Get.find<SocketService>();
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
      if (socket.isConnected) return;

      print("🔁 ChatInbox reconnect attempt ${_reconnectAttempt + 1}");
      _reconnectAttempt++;

      try {
        socket.disconnectSocket();
        await socket.connectSocket();
      } catch (e) {
        print("❌ reconnect failed: $e");
      }

      if (!socket.isConnected) {
        _scheduleReconnect();
      }
    });
  }

  Future<void> getMessages() => messagesPaginator.loadInitial();
  Future<void> loadMoreMessages() => messagesPaginator.loadMore();

  @override
  void onClose() {
    // Leave current conversation
    if (socket.isConnected) {
      socket.emit(SocketEvents.leaveConversation, {"conversationId": chatId});
    }

    msgInputController.dispose();
    msgInputFocus.dispose();
    scrollController.dispose();
    messagesPaginator.dispose();

    _socketConnectedSub?.cancel();
    _socketDisconnectedSub?.cancel();
    _reconnectTimer?.cancel();
    _tabWorker?.dispose();
    super.onClose();
  }
  // ── Socket callbacks ─────────────────────────────────────────────────────

  // Called by SocketService when full message list arrives
  void updateChatInboxMsgItem(ChatInboxMessageItemModel item) {
    // // ✅ Ignore if this response is for a different conversation
    // if (item.messages.isNotEmpty == true) {
    //   final incomingChatId = item.messages.first.conversationId ?? '';
    //   if (incomingChatId.isNotEmpty && incomingChatId != chatId) {
    //     print(
    //       "⚠️ Ignoring messages for different chat: $incomingChatId (mine: $chatId)",
    //     );
    //     return;
    //   }
    // }

    // realChatInboxMsgItem.value = item;
    // messages.assignAll(item.messages ?? []);
    // isLoading_.value = false;
    // scrollToNewest();
  }

  // Called by SocketService on each new incoming message
  void addMessage(Message msg) {
    // ✅ Ignore messages for other conversations
    if (msg.conversationId != chatId) return;

    final alreadyExists = messages.any(
      (m) =>
          m.sender == msg.sender &&
          m.text == msg.text &&
          m.createdAt != null &&
          msg.createdAt != null &&
          msg.createdAt!.difference(m.createdAt!).inSeconds.abs() < 3,
    );
    if (!alreadyExists) {
      messages.add(msg);
    }
  }
  // ── Helpers ───────────────────────────────────────────────────────────────

  void emitGetMessages() {
    Get.find<SocketService>().emit(SocketEvents.getMessages, {
      "conversationId": chatId,
    });
  }

  //
  List<Map<String, dynamic>> normalizeAttachments(dynamic data) {
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }

    if (data is Map<String, dynamic>) {
      final inner = data['data'];

      if (inner is List) {
        return inner.cast<Map<String, dynamic>>();
      }

      /// single file fallback
      return [data];
    }

    return [];
  }

  //
  final sendFailed_ = false.obs;
  Future<bool> _emitSendMessage(
    String message,
    String receiverId, {
    required List<Map<String, dynamic>> attachments,
  }) async {
    if (!socket.isConnected) {
      print("❌ Send failed: socket not connected");

      _scheduleReconnect(immediate: true);

      sendFailed_.value = true;
      return false;
    }

    try {
      socket.emit(SocketEvents.sendMessage, {
        "senderId": currentProfileId(),
        "receiverId": receiverId,
        "text": message,
        "attachments": attachments,
      });

      return true;
    } catch (e) {
      print("❌ Send error: $e");
      sendFailed_.value = true;
      return false;
    }
  }

  void clearAll() {
    msgInputController.clear();
    msgInputFocus.unfocus();
  }

  void unFocusAll() {
    msgInputFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void scrollToNewest() {
    print('scrollToNewest called ');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final autoScrolling = false.obs;

  Future<void> scrollToLast() async {
    print('scrollToLast called ');
    // autoScrolling.value = true;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (scrollController.hasClients) {
    //     scrollController.animateTo(
    //       scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 300),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });

    // autoScrolling.value = false;
    autoScrolling.value = true;

    await Future.delayed(const Duration(milliseconds: 50));

    if (!scrollController.hasClients) return;

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );

    autoScrolling.value = false;
  }

  List<dynamic> groupMessagesByDate() {
    final sorted = [...messages]
      ..sort(
        (a, b) =>
            (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)),
      );

    final List<dynamic> result = [];
    String? lastDate;

    for (var msg in sorted) {
      final dateLabel = DateHelper().formatDateLabel(
        msg.createdAt?.toString() ?? "",
      );
      if (lastDate != dateLabel) {
        result.add(dateLabel);
        lastDate = dateLabel;
      }
      result.add(msg);
    }

    return result;
  }

  // Blocked users part---------------->>>>>>>

  var isBlockLoading = false.obs;
  Future<void> onTapBlocked({required String userId}) async {
    if (isBlockLoading.value) return;

    final confirm = await showAnimatedDialog<bool>(
      context: Get.context!,
      barrierDismissible: true,
      child: BlockUserConfirmDialog(
        isLoading: isBlockLoading,
        onConfirm: () async {
          isBlockLoading.value = true;
          Get.back();

          try {
            final success = await BlockedUserService().blockUser(
              userId: userId,
            );

            if (success) {
              isBlockedRx.value = true;

              Get.find<ChatController>().updateChatBlockStatus(
                chatId: chatId,
                isBlocked: true,
              );
            }

            Get.back(result: true);
            Get.offAndToNamed(RoutePaths.mainNav);
            MainNavController.to.goToTab(1);
          } finally {
            isBlockLoading.value = false;
          }
        },
      ),
    );
  }

  var isUnblockLoading = false.obs;
  Future<void> onTapUnBlock({required String userId}) async {
    if (isUnblockLoading.value) return;

    isUnblockLoading.value = true;

    try {
      final success = await BlockedUserService().unblockUser(userId: userId);

      if (success) {
        isBlockedRx.value = false;

        Get.find<ChatController>().updateChatBlockStatus(
          chatId: chatId,
          isBlocked: false,
        );

        Get.offAndToNamed(RoutePaths.mainNav);
        MainNavController.to.goToTab(1);
      }
    } finally {
      isUnblockLoading.value = false;
    }
  }

  Future<void> onTapReportUser({required String userId}) async {
    await showReportBottomSheet(isUserReport: true, userId: userId);
    Get.back(); // report user dropdown collapse
  }

  //-----------------> Upload chat files

  //

  // ── File picking ──────────────────────────────────────────────────────────
  static const int maxImages = 5;
  static const int maxFiles = 5;

  bool canAddImages(int count) {
    final currentImages = pickedFiles.where((f) => isImageFile(f)).length;

    return (currentImages + count) <= maxImages;
  }

  bool canAddFiles(int count) {
    final currentFiles = pickedFiles.where((f) => !isImageFile(f)).length;

    return (currentFiles + count) <= maxFiles;
  }

  //
  final pickedFiles = <XFile>[].obs;
  Future<void> pickMultipleFiles({ImageSource? source}) async {
    List<XFile> newFiles = [];

    if (source == ImageSource.camera) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image != null) {
        newFiles.add(image);
      }
    } else if (source == ImageSource.gallery) {
      final images = await ImagePicker().pickMultiImage();

      newFiles.addAll(images);
    } else {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result == null) return;

      newFiles = result.files
          .where((e) => e.path != null)
          .map((e) => XFile(e.path!))
          .toList();
    }

    if (newFiles.isEmpty) return;

    final images = newFiles.where(isImageFile).toList();
    final others = newFiles.where((f) => !isImageFile(f)).toList();

    if (!canAddImages(images.length)) {
      Get.snackbar("Limit reached", "Max 5 images allowed");
      return;
    }

    if (!canAddFiles(others.length)) {
      Get.snackbar("Limit reached", "Max 5 files allowed");
      return;
    }

    pickedFiles.addAll(newFiles);
  }

  void removeFile(int index) {
    pickedFiles.removeAt(index);
  }

  void removeFileByValue(XFile file) {
    pickedFiles.remove(file);
  }

  // new
  //// ── Send message ──────────────────────────────────────────────────────────

  void onTapSendMsg() {
    final text = msgInputController.text.trim();
    final hasFile = pickedFiles.value.isNotEmpty;

    if (text.isEmpty && !hasFile) {
      "Type something or pick a file...".showToast();
      return;
    }

    if (isBlocked) {
      "Can't send message right now. Unblock the user first.".showToast();
      return;
    }

    final receiverId = realChatInboxMsgItem.value.receiver?.id ?? '';

    if (receiverId.isEmpty) {
      Strings.somethingWentWrong.showToast();
      return;
    }

    if (hasFile) {
      sendFileMessage(receiverId, text);
    } else {
      _sendTextMessage(text, receiverId);
    }
  }

  Future<void> _sendTextMessage(String text, String receiverId) async {
    messages.add(
      Message(
        conversationId: chatId,
        createdAt: DateTime.now(),
        receiver: receiverId,
        seen: false,
        sender: currentProfileId(),
        text: text,
      ),
    );
    scrollToLast();

    final ok = await _emitSendMessage(text, receiverId, attachments: []);

    if (!ok) {
      messages.removeWhere(
        (m) =>
            m.text == text &&
            m.sender == currentProfileId() &&
            (DateTime.now()
                    .difference(m.createdAt ?? DateTime.now())
                    .inSeconds <
                5),
      );

      "Message failed to send. Please check your connection.".showToast();
      return;
    }

    // ✅ Update chat list immediately (optimistic)
    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().updateLastMessage(
        chatId: chatId,
        lastMessage: text,
        time: DateTime.now().toUtc(),
      );
    }
    clearAll();
  }

  //
  void clearAttachments() {
    pickedFiles.clear();
    msgInputController.clear();
  }

  Future<void> downloadFile(String url) async {
    try {
      downloadingUrl.value = url;
      downloadProgress.value = 0;

      final fileName = p.basename(url.split('?').first);

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';

      await Dio().download(
        url,
        tempPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      print("Downloaded to temp: $tempPath");

      final lower = fileName.toLowerCase();

      if (lower.endsWith(".jpg") ||
          lower.endsWith(".jpeg") ||
          lower.endsWith(".png") ||
          lower.endsWith(".webp")) {
        await Gal.putImage(tempPath);
        Snack.showSuccess("Image saved to gallery");
      } else if (lower.endsWith(".mp4") || lower.endsWith(".mov")) {
        await Gal.putVideo(tempPath);
        Snack.showSuccess("Video saved to gallery");
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final savePath = '${dir.path}/$fileName';

        await File(tempPath).copy(savePath);

        Snack.showSuccess("File saved in app storage");
        await OpenFile.open(savePath);
      }
    } catch (e) {
      print("Download error: $e");
      Snack.showError("Download failed");
    } finally {
      downloadProgress.value = 0;
      downloadingUrl.value = '';
    }
  }

  //
  final downloadingUrl = ''.obs;
  final downloadProgress = 0.0.obs;

  //

  Future<void> sendFileMessage(String receiverId, String text) async {
    if (isSending_.value) return;

    isSending_.value = true;

    /// 1️⃣ TAKE SNAPSHOT
    final files = List<XFile>.from(pickedFiles);

    try {
      /// 2️⃣ UPLOAD FILES
      final result = await ChatInboxService().sendChatFile(chatFiles: files);

      if (result == null) {
        "Failed to send file. Please try again.".showToast();
        return;
      }

      /// 3️⃣ NORMALIZE ATTACHMENTS
      final attachments = normalizeAttachments(result);

      /// 4️⃣ CREATE LOCAL MESSAGE (OPTIMISTIC)
      final localMessage = Message(
        conversationId: chatId,
        createdAt: DateTime.now(),
        receiver: receiverId,
        seen: false,
        sender: currentProfileId(),
        text: text,

        /// IMPORTANT
        attachments: attachments.map((e) => Attachment.fromJson(e)).toList(),
      );

      /// 5️⃣ ADD LOCALLY
      messages.add(localMessage);

      scrollToLast();

      /// 6️⃣ SOCKET EMIT
      final ok = await _emitSendMessage(
        text,
        receiverId,
        attachments: attachments,
      );

      if (!ok) {
        messages.removeWhere(
          (m) =>
              m.text == text &&
              m.sender == currentProfileId() &&
              (DateTime.now()
                      .difference(m.createdAt ?? DateTime.now())
                      .inSeconds <
                  5),
        );

        "Message failed to send. Please check your connection.".showToast();
        return;
      }

      /// 7️⃣ UPDATE CHAT LIST
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().updateLastMessage(
          chatId: chatId,
          lastMessage: text.isNotEmpty ? text : "📎 Attachment",
          time: DateTime.now().toUtc(),
        );
      }

      /// 8️⃣ CLEAR
      clearAttachments();
      unFocusAll();
    } catch (e) {
      print("sendFileMessage error: $e");

      "Something went wrong while sending the file.".showToast();
    } finally {
      isSending_.value = false;
    }
    //
  }

  ///
  // get wave user details
  ///
  RxBool isSeeMore = false.obs;

  void toggleSeeMore() {
    isSeeMore.value = !isSeeMore.value;
  }

  //   // API loading state
  var isgetUserProfileLoading_ = false.obs;
  bool get isgetUserProfileLoading => isgetUserProfileLoading_.value;

  /// Fetch the latest profile from API
  ///
  final chatUserProfileData = Rxn<ProfileDataModel>();

  ///
  Future<void> getUserProfile({required String userId}) async {
    if (isgetUserProfileLoading_.value) return; // Prevent duplicate calls
    isgetUserProfileLoading_.value = true;

    try {
      final data = await WaveService().fetchUserProfile(userId: userId);

      if (data != null) {
        chatUserProfileData.value = data;
        print("data fetching profile: ${(data)}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isgetUserProfileLoading_.value = false;
    }
  }

  /////
}
