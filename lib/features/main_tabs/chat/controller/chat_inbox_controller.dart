import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/helpers/date_helper.dart';
import 'package:mama_app/core/utils/extension/string_extension.dart';
import 'package:mama_app/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/services/socket/socket_events.dart';
import '../../../../core/services/socket/socket_service.dart';
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
  final String chatId;
  ChatInboxController(this.chatId);

  // var fakeMsgList = [
  //   FakeMsgItemData(msg: "Hey, how are you?", time: "2h ago", isSentByMe: false),
  //   FakeMsgItemData(msg: "I'm good, thanks! How about you?", time: "1h ago", isSentByMe: true),
  //   FakeMsgItemData(msg: "Doing well, just busy with work.", time: "45min ago", isSentByMe: false),
  //   FakeMsgItemData(
  //     msg: "I understand. Let me know if you want to catch up later.",
  //     time: "02:45 pm",
  //     isSentByMe: true,
  //   ),
  //   FakeMsgItemData(msg: "Sure, sounds good!", time: "02:45 pm", isSentByMe: false),
  // ];

  // FakeChatInboxModel? fakeChatInbox;

  // void initFakeData(String chatId) {
  //   final senderData = FakeChatModel(
  //     id: chatId,
  //     name: "Alice",
  //     lastMessage: "Hey, how are you?",
  //     time: "2h ago",
  //     imageUrl: Strings.fakeImageUrl,
  //   );

  //   fakeChatInbox = FakeChatInboxModel(senderData: senderData, msgList: fakeMsgList);
  // }

  final msgInputController = TextEditingController();

  final msgInputFocus = FocusNode();

  final scrollController = ScrollController();

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  List<dynamic> groupMessagesByDate() {
    // ✅ Read from reactive list, not a passed-in model
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

  @override
  void onInit() async {
    print("chatId: $chatId");
    // initFakeData(chatId);

    await getChatInboxMsgList();

    //
    scrollToBottom();
    super.onInit();
  }

  @override
  void onClose() {
    msgInputController.dispose();
    msgInputFocus.dispose();
    super.onClose();
  }

  void unFocusAll() {
    msgInputFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// pick image -----------------------//

  var pickedImageOrFile = Rxn<XFile>(); // for image
  var filePicked = Rx<File?>(null); // for other files

  /// Pick single image (camera/gallery) or any type of file
  Future<void> pickSingleImageOrFile({ImageSource? source}) async {
    // Pick image from camera/gallery
    if (source != null) {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image != null) {
        pickedImageOrFile.value = image;
        print("Picked image: ${image.path}");
      }
      return;
    }

    // Pick any file
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null) {
          filePicked.value = File(path);
          pickedImageOrFile.value = result.files.single.xFile;
          print("Picked file: $path");
        }
      }
    } catch (e) {
      print("FilePicker error: $e");
    }
  }

  /////////////////////---------------------------
  void clearAll() {
    msgInputController.clear();
    msgInputFocus.unfocus();
    pickedImageOrFile.value = null;
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final realChatInboxMsgItem = ChatInboxMessageItemModel().obs;

  // updateChatInboxMsgItem

  // ─────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────

  // ── List management ───────────────────────────────────────────────────────

  final socket = Get.find<SocketService>();
  // Remove loadInbox() — not needed separately
  // Keep messages as the single source of truth

  final messages = <Message>[].obs;

  Future<void> getChatInboxMsgList() async {
    if (isLoading_.value) return;
    isLoading_.value = true;
    try {
      messages.clear(); // ✅ clear reactive list
      realChatInboxMsgItem.value = ChatInboxMessageItemModel();
      getChatInboxMSgListEmit(currentProfileId());
    } catch (e) {
      print("Error fetching chat list: $e");
    } finally {
      isLoading_.value = false;
      unFocusAll();
    }
  }

  // Called when socket returns the full message list
  void updateChatInboxMsgItem(ChatInboxMessageItemModel chatInboxMsgItem) {
    realChatInboxMsgItem.value = chatInboxMsgItem;
    messages.assignAll(chatInboxMsgItem.messages ?? []); // ✅ sync RxList
    isLoading_.value = false;
    scrollToBottom(); // ✅ scroll after data loads
  }

  // Called by socket on new incoming message
  void addMessage(Message msg) {
    messages.add(msg); // ✅ reactive, triggers UI rebuild
    scrollToBottom();
  }

  void onTapSendMsg() {
    final msg = msgInputController.text.trim();
    if (msg.isEmpty) {
      "Type Something...".showToast();
      return;
    }

    final receiverId = realChatInboxMsgItem.value.receiver?.id ?? '';
    final sentTime = DateTime.now();

    final newMsg = Message(
      conversationId: chatId,
      createdAt: sentTime,
      receiver: receiverId,
      seen: true,
      sender: currentProfileId(),
      text: msg,
    );

    messages.add(newMsg); // ✅ add to RxList, NOT realChatInboxMsgItem
    scrollToBottom();
    sendMessageEmit(msg, receiverId);
    clearAll();
  }

  void getChatInboxMSgListEmit(String userOwnId) {
    socket.emit(SocketEvents.getMessages, {"conversationId": chatId});
  }

  void sendMessageEmit(String message, String receiverId) {
    socket.emit(SocketEvents.sendMessage, {
      "senderId": currentProfileId(),
      "receiverId": receiverId,
      "text": message,
    });
  }
}
