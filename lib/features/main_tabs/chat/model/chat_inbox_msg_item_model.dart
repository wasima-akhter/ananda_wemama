class ChatInboxMessageItemModel {
  ChatInboxMessageItemModel({this.receiver, this.messages});

  final Receiver? receiver;
  final List<Message>? messages;

  factory ChatInboxMessageItemModel.fromJson(Map<String, dynamic> json) {
    return ChatInboxMessageItemModel(
      receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
      messages: json["messages"] == null
          ? []
          : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
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
  });

  final String? id;
  final String? conversationId;
  final String? sender;
  final String? receiver;
  final String? text;
  final bool? seen;
  final DateTime? createdAt;
  final int? v;

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
    );
  }
}

class Receiver {
  Receiver({this.id, this.name, this.profileImage});

  final String? id;
  final String? name;
  final String? profileImage;

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(id: json["_id"], name: json["name"], profileImage: json["profileImage"]);
  }
}
