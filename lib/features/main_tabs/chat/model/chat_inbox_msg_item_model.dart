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
