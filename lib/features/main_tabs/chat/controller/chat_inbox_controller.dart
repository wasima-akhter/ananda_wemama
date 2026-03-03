import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/controller_export.dart';

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

  var fakeMsgList = [
    FakeMsgItemData(msg: "Hey, how are you?", time: "2h ago", isSentByMe: false),
    FakeMsgItemData(msg: "I'm good, thanks! How about you?", time: "1h ago", isSentByMe: true),
    FakeMsgItemData(msg: "Doing well, just busy with work.", time: "45min ago", isSentByMe: false),
    FakeMsgItemData(
      msg: "I understand. Let me know if you want to catch up later.",
      time: "02:45 pm",
      isSentByMe: true,
    ),
    FakeMsgItemData(msg: "Sure, sounds good!", time: "02:45 pm", isSentByMe: false),
  ];

  FakeChatInboxModel? fakeChatInbox;

  void initFakeData(String chatId) {
    final senderData = FakeChatModel(
      id: chatId,
      name: "Alice",
      lastMessage: "Hey, how are you?",
      time: "2h ago",
      imageUrl: Strings.fakeImageUrl,
    );

    fakeChatInbox = FakeChatInboxModel(senderData: senderData, msgList: fakeMsgList);
  }

  final msgInputController = TextEditingController();

  final msgInputFocus = FocusNode();

  @override
  void onInit() {
    print("chatId: $chatId");
    initFakeData(chatId);
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

  void clearAll() {
    msgInputController.clear();
    msgInputFocus.unfocus();
    pickedImageOrFile.value = null;
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> getChatList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
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

  void onTapSendMsg() {
    final msg = msgInputController.text.trim();
    if (msg.isEmpty) return;

    // Add the new message to the list
    final newMsg = FakeMsgItemData(msg: msg, time: "Just now", isSentByMe: true);
    fakeChatInbox?.msgList?.add(newMsg);

    // Clear the input field and unfocus
    clearAll();
  }
}
