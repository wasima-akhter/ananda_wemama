import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/helpers/date_helper.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/components/app_ui/popup_widgets/block_user_dialog.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/models/ui/common_data_models.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../more/blocked_user/service/blocked_user_service.dart';
import '../model/chat_inbox_msg_item_model.dart';

class FakeChatInboxModel {
  final FakeChatModel senderData;
  final List<FakeMsgItemData>? msgList;

  FakeChatInboxModel({required this.senderData, required this.msgList});
}

class FakeMsgItemData {
  final String msg;
  final String time;
  final bool isSentByMe;

  FakeMsgItemData({required this.msg, required this.time, required this.isSentByMe});
}

class ChatInboxController extends GetxController {
  final ChatInboxArgPassModel args;

  ChatInboxController(this.args);

  String get chatId => args.chatId;
  bool get isBlocked => args.isBlocked;

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
    print("chatId: $chatId");
    print("isBlocked: $isBlocked");
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
    realChatInboxMsgItem.value = item;
    messages.assignAll(item.messages ?? []);
    isLoading_.value = false; // ← data arrived, stop loading
    scrollToBottom();
  }

  // Called by SocketService on each new incoming message
  void addMessage(Message msg) {
    // Avoid duplicate if we just sent it optimistically
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  void emitGetMessages() {
    Get.find<SocketService>().emit(SocketEvents.getMessages, {"conversationId": chatId});
  }

  void _emitSendMessage(String message, String receiverId) {
    Get.find<SocketService>().emit(SocketEvents.sendMessage, {
      "senderId": currentProfileId(),
      "receiverId": receiverId,
      "text": message,
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
      ..sort((a, b) => (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));

    final List<dynamic> result = [];
    String? lastDate;

    for (var msg in sorted) {
      final dateLabel = DateHelper().formatDateLabel(msg.createdAt?.toString() ?? "");
      if (lastDate != dateLabel) {
        result.add(dateLabel);
        lastDate = dateLabel;
      }
      result.add(msg);
    }

    return result;
  }

  // ── File picking (unchanged) ──────────────────────────────────────────────

  var pickedImageOrFile = Rxn<XFile>();
  var filePicked = Rx<File?>(null);

  Future<void> pickSingleImageOrFile({ImageSource? source}) async {
    if (source != null) {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
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
      print("FilePicker error: $e");
    }
  }

  // Blocked users part---------------->>>>>>>

  var isBlockLoading = false.obs;
  Future<void> onTapBlocked({required String userId}) async {
    final isBlockLoading = false.obs;

    if (isBlockLoading.value) return;

    final confirm = await showAnimatedDialog<bool>(
      context: Get.context!,
      barrierDismissible: true,
      child: BlockUserConfirmDialog(
        isLoading: isBlockLoading,
        onConfirm: () async {
          isBlockLoading.value = true;

          try {
            final success = await BlockedUserService().blockUser(userId: userId);

            if (success) {}

            Get.back(result: true); // close dialog with success

            Get.find<ChatController>().getChatList();
          } catch (e) {
            print("Error blocking user: $e");
          } finally {
            isBlockLoading.value = false;
          }
        },
      ),
    );

    if (confirm != true) return;

    // Get.back();
  }

  var isUnblockLoading = false.obs;
  Future<void> onTapUnBlock({required String userId}) async {
    final isUnblockLoading = false.obs;

    if (isUnblockLoading.value) return;

    isUnblockLoading.value = true;

    try {
      final success = await BlockedUserService().unblockUser(userId: userId);

      if (success) {}

      // Get.back(result: true); // close dialog with success

      await Get.find<ChatController>().getChatList();
    } catch (e) {
      print("Error blocking user: $e");
    } finally {
      isUnblockLoading.value = false;
    }

    Get.back();
  }
}
