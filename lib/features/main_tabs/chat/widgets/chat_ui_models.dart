import '../model/chat_inbox_msg_item_model.dart';

class FakeChatModel {
  final String id;
  final String name;
  final bool isblocked;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final bool isNewMatch;

  FakeChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    required this.id,
    required this.isblocked,
    this.isNewMatch = false,
  });
}

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

enum MessageStatus { sending, sent, failed }

class UiMessage {
  final Message message;

  MessageStatus status;

  UiMessage({required this.message, this.status = MessageStatus.sent});
}
