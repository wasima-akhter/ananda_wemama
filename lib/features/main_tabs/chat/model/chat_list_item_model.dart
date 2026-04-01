class ChatListItemModel {
  ChatListItemModel({this.id, this.otherUser, this.lastMessage, this.time});

  final String? id;
  final OtherUser? otherUser;
  final String? lastMessage;
  final DateTime? time;

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      id: json["_id"],
      otherUser: json["otherUser"] == null ? null : OtherUser.fromJson(json["otherUser"]),
      lastMessage: json["lastMessage"],
      time: DateTime.tryParse(json["time"] ?? ""),
    );
  }
}

class OtherUser {
  OtherUser({this.name, this.profileImage});

  final String? name;
  final String? profileImage;

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(name: json["name"], profileImage: json["profileImage"]);
  }
}
