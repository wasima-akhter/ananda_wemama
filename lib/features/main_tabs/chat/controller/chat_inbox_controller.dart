import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/helpers/date_helper.dart';
import 'package:mama_app/core/helpers/widgets_helper.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/app_ui/popup_widgets/block_user_dialog.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/helpers/image_helper.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../more/blocked_user/service/blocked_user_service.dart';
import '../model/chat_inbox_msg_item_model.dart';
import '../service/chat_inbox_service.dart';

class FakeChatInboxModel {
  final FakeChatModel senderData;
  final List<FakeMsgItemData>? msgList;

  FakeChatInboxModel({required this.senderData, required this.msgList});
}

class FakeMsgItemData {
  final String msg;
  final String time;
  final bool isSentByMe;

  /// NEW
  final List<Attachment> attachments;

  FakeMsgItemData({
    required this.msg,
    required this.time,
    required this.isSentByMe,
    this.attachments = const [],
  });
}

class ChatInboxController extends GetxController {
  final ChatInboxArgPassModel args;

  ChatInboxController(this.args);

  String get chatId => args.chatId;

  final isBlockedRx = false.obs;
  bool get isBlocked => isBlockedRx.value;

  final msgInputController = TextEditingController();
  final msgInputFocus = FocusNode();
  final scrollController = ScrollController();

  // ── State ────────────────────────────────────────────────────────────────

  final isLoading_ = true.obs; // ← start true
  bool get isLoading => isLoading_.value;

  final isSending_ = false.obs; // ← separate sending state
  bool get isSending => isSending_.value;

  final messages = <Message>[].obs;
  final realChatInboxMsgItem = ChatInboxMessageItemModel().obs;

  // ── Init / Close ─────────────────────────────────────────────────────────

  @override
  void onInit() async {
    super.onInit();
    log("chatId: $chatId");
    log("isBlocked: $isBlocked");

    isBlockedRx.value = args.isBlocked;
    emitGetMessages(); // ← just emit, don't clear or set loading again
  }

  @override
  void onClose() {
    msgInputController.dispose();
    msgInputFocus.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ── Socket callbacks ─────────────────────────────────────────────────────

  // Called by SocketService when full message list arrives
  void updateChatInboxMsgItem(ChatInboxMessageItemModel item) {
    // ✅ Ignore if this response is for a different conversation
    if (item.messages?.isNotEmpty == true) {
      final incomingChatId = item.messages!.first.conversationId ?? '';
      if (incomingChatId.isNotEmpty && incomingChatId != chatId) {
        log(
          "⚠️ Ignoring messages for different chat: $incomingChatId (mine: $chatId)",
        );
        return;
      }
    }

    realChatInboxMsgItem.value = item;
    messages.assignAll(item.messages ?? []);
    isLoading_.value = false;
    scrollToBottom();
  }

  // Called by SocketService on each new incoming message
  void addMessage(Message msg) {
    // ✅ Ignore messages for other conversations
    if (msg.conversationId != null && msg.conversationId != chatId) return;

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
      scrollToBottom();
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

  void _emitSendMessage(
    String message,
    String receiverId, {
    required List<Map<String, dynamic>> attachments,
  }) {
    Get.find<SocketService>().emit(SocketEvents.sendMessage, {
      "senderId": currentProfileId(),
      "receiverId": receiverId,
      "text": message,
      "attachments": attachments,
    });
  }

  void clearAll() {
    msgInputController.clear();
    msgInputFocus.unfocus();
    pickedImageOrFile.value = null;
  }

  void unFocusAll() {
    msgInputFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
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

  var pickedImageOrFile = Rxn<XFile>();
  var filePicked = Rx<File?>(null);

  Future<void> pickSingleImageOrFile({ImageSource? source}) async {
    if (source != null) {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        imageQuality: 60,
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
      if (image != null) pickedImageOrFile.value = image;
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null) {
          filePicked.value = File(path);
          pickedImageOrFile.value = result.files.single.xFile;
        }
      }
    } catch (e) {
      log("FilePicker error: $e");
    }
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
  static const int maxImages = 10;
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
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;

    final newFiles = result.files
        .where((e) => e.path != null)
        .map((e) => XFile(e.path!))
        .toList();

    final images = newFiles.where(isImageFile).toList();
    final others = newFiles.where((f) => !isImageFile(f)).toList();

    if (!canAddImages(images.length)) {
      Get.snackbar("Limit reached", "Max 10 images allowed");
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

  // old

  /*
  // ── Send message ─────────────────────────────────────────────────────────

  void onTapSendMsg() {
    final text = msgInputController.text.trim();
    if (text.isEmpty) {
      "Type something...".showToast();
      return;
    }

    if (isBlocked) {
      "Can't send message right now. Unblock the user first.".showToast();
    }

    final receiverId = realChatInboxMsgItem.value.receiver?.id ?? '';

    // Optimistic add — user sees message instantly
    final newMsg = Message(
      conversationId: chatId,
      createdAt: DateTime.now(),
      receiver: receiverId,
      seen: false,
      sender: currentProfileId(),
      text: text,
    );

    messages.add(newMsg);
    scrollToBottom();

    // Emit to socketio
    _emitSendMessage(text, receiverId);

    // ← NO getChatInboxMsgList() here — that caused the empty flicker
    clearAll();
  }


*/
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
      "Something went wrong. Please try again.".showToast();
      return;
    }

    if (hasFile) {
      sendFileMessage(receiverId, text);
    } else {
      _sendTextMessage(text, receiverId);
    }
  }

  void _sendTextMessage(String text, String receiverId) {
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
    scrollToBottom();
    _emitSendMessage(text, receiverId, attachments: []);

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

  Future<void> sendFileMessage(String receiverId, String text) async {
    if (isSending_.value) return;
    isSending_.value = true;

    /// 1️⃣ TAKE SNAPSHOT (DO NOT MUTATE ORIGINAL YET)
    final files = List<XFile>.from(pickedFiles);

    try {
      /// 2️⃣ UPLOAD FIRST
      final result = await ChatInboxService().sendChatFile(chatFiles: files);

      if (result == null) {
        "Failed to send file. Please try again.".showToast();
        return;
      }

      /// 3️⃣ BUILD SOCKET PAYLOAD
      final attachments = normalizeAttachments(result);

      /// 4️⃣ EMIT MESSAGE
      _emitSendMessage(text, receiverId, attachments: attachments);

      /// 5️⃣ ONLY NOW CLEAR STATE (SUCCESS PATH)
      clearAttachments();
      unFocusAll();
    } catch (e) {
      log("_sendFileMessage error: $e");

      "Something went wrong while sending the file.".showToast();

      /// ❗ IMPORTANT: DO NOT CLEAR ON ERROR
      /// user should retry without re-picking files
    } finally {
      isSending_.value = false;
    }
  }

  ///
}
