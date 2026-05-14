class ChatListItemModel {
  ChatListItemModel({this.id, this.otherUser, this.lastMessage, this.time, this.isBlocked});

  final String? id;
  final OtherUser? otherUser;
  final bool? isBlocked;
  final String? lastMessage;
  final DateTime? time;

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      id: json["_id"],
      otherUser: json["otherUser"] == null ? null : OtherUser.fromJson(json["otherUser"]),
      isBlocked: json["isBlocked"],
      lastMessage: json["lastMessage"],
      time: DateTime.tryParse(json["time"] ?? ""),
    );
  }

  ChatListItemModel copyWith({
    String? id,
    OtherUser? otherUser,
    bool? isBlocked,
    String? lastMessage,
    DateTime? time,
  }) {
    return ChatListItemModel(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      isBlocked: isBlocked ?? this.isBlocked,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
    );
  }
}

class OtherUser {
  OtherUser({this.name, this.profileImage, this.id});

  final String? name;
  final String? id;
  final String? profileImage;

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(id: json["_id"], name: json["name"], profileImage: json["profileImage"]);
  }

  OtherUser copyWith({String? name, String? id, String? profileImage}) {
    return OtherUser(
      name: name ?? this.name,
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
