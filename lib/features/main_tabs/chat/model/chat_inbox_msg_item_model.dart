/*
class ChatInboxMessageItemModel {
  ChatInboxMessageItemModel({this.receiver, this.messages});

  final Receiver? receiver;
  final List<Message>? messages;

  factory ChatInboxMessageItemModel.fromJson(Map<String, dynamic> json) {
    return ChatInboxMessageItemModel(
      receiver: json["receiver"] == null
          ? null
          : Receiver.fromJson(json["receiver"]),
      messages: json["messages"] == null
          ? []
          : List<Message>.from(
              json["messages"]!.map((x) => Message.fromJson(x)),
            ),
    );
  }
}

class Message {
  Message({
    this.id,
    this.conversationId,
    this.sender,
    this.receiver,
    this.text,
    this.seen,
    this.createdAt,
    this.v,
    this.attachments,
  });

  final String? id;
  final String? conversationId;
  final String? sender;
  final String? receiver;
  final String? text;
  final bool? seen;
  final DateTime? createdAt;
  final int? v;

  /// ✅ NEW FIELD
  final List<Attachment>? attachments;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["_id"],
      conversationId: json["conversationId"],
      sender: json["sender"],
      receiver: json["receiver"],
      text: json["text"],
      seen: json["seen"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"],

      /// ✅ SAFE PARSING WITH FALLBACK
      attachments: (json["attachments"] is List)
          ? (json["attachments"] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => Attachment.fromJson(e))
                .toList()
          : null,
    );
  }
}

class Attachment {
  Attachment({
    this.url,
    this.key,
    this.type,
    this.size,
    this.originalName,
    this.id,
  });

  final String? url;
  final String? key;
  final String? type;
  final int? size;
  final String? originalName;
  final String? id;

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      url: json["url"],
      key: json["key"],
      type: json["type"],
      size: json["size"],
      originalName: json["originalName"],
      id: json["_id"],
    );
  }
}

class Receiver {
  Receiver({this.id, this.name, this.profileImage});

  final String? id;
  final String? name;
  final String? profileImage;

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json["_id"],
      name: json["name"],
      profileImage: json["profileImage"],
    );
  }
}
*/

import '../../../../core/helpers/parser_helper.dart';
import '../../../../core/network/base/dio_client.dart';

class ChatMessagesPage {
  final List<Message> messages;
  final PaginationMeta? meta;
  final ChatInboxMessageItemModel
  item; // full parsed payload (receiver, conversation, etc.)

  ChatMessagesPage({
    required this.messages,
    required this.meta,
    required this.item,
  });
}

class ChatConversationModel {
  final bool? isBlocked;
  ChatConversationModel({this.isBlocked});
  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      ChatConversationModel(isBlocked: json['isBlocked']);
}

class ChatInboxMessageItemModel {
  const ChatInboxMessageItemModel({
    this.receiver,
    this.messages = const [],
    this.conversation,
  });

  final Receiver? receiver;
  final List<Message> messages;
  // inside ChatInboxMessageItemModel:
  final ChatConversationModel? conversation;

  factory ChatInboxMessageItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChatInboxMessageItemModel();

    return ChatInboxMessageItemModel(
      receiver: SafeParser.object(json['receiver'], Receiver.fromJson),
      messages: SafeParser.list<Message>(json['messages'], Message.fromJson),

      // fromJson:
      conversation: json['conversation'] != null
          ? ChatConversationModel.fromJson(json['conversation'])
          : null,
    );
  }
}

class Message {
  const Message({
    this.id = '',
    this.conversationId = '',
    this.sender = '',
    this.receiver = '',
    this.text = '',
    this.seen = false,
    this.createdAt,
    this.v = 0,
    this.attachments = const [],
  });

  final String id;
  final String conversationId;
  final String sender;
  final String receiver;
  final String text;
  final bool seen;
  final DateTime? createdAt;
  final int v;

  final List<Attachment> attachments;

  factory Message.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Message();

    return Message(
      id: SafeParser.id(json['_id']),
      conversationId: SafeParser.str(json['conversationId']),
      sender: SafeParser.str(json['sender']),
      receiver: SafeParser.str(json['receiver']),
      text: SafeParser.str(json['text']),
      seen: SafeParser.boolVal(json['seen']),
      v: SafeParser.intVal(json['__v']),
      createdAt: SafeParser.date(json['createdAt']),

      attachments: SafeParser.list<Attachment>(
        json['attachments'],
        Attachment.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversationId': conversationId,
    'sender': sender,
    'receiver': receiver,
    'text': text,
    'seen': seen,
    'createdAt': createdAt?.toIso8601String(),
    '__v': v,
    'attachments': attachments.map((e) => e.toJson()).toList(),
  };
}

class Attachment {
  const Attachment({
    this.url = '',
    this.key = '',
    this.type = '',
    this.size = 0,
    this.originalName = '',
    this.id = '',
  });

  final String url;
  final String key;
  final String type;
  final int size;
  final String originalName;
  final String id;

  factory Attachment.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Attachment();

    return Attachment(
      url: SafeParser.str(json['url']),
      key: SafeParser.str(json['key']),
      type: SafeParser.str(json['type']),
      size: SafeParser.intVal(json['size']),
      originalName: SafeParser.str(json['originalName']),
      id: SafeParser.id(json['_id']),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'key': key,
    'type': type,
    'size': size,
    'originalName': originalName,
    '_id': id,
  };
}

class Receiver {
  const Receiver({this.id = '', this.name = '', this.profileImage = ''});

  final String id;
  final String name;
  final String profileImage;

  factory Receiver.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Receiver();

    return Receiver(
      id: SafeParser.id(json['_id']),
      name: SafeParser.str(json['name']),
      profileImage: SafeParser.str(json['profileImage']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'profileImage': profileImage,
  };
}
