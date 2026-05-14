class BlockedUserDataModel {
  BlockedUserDataModel({this.id, this.blocker, this.blocked, this.createdAt, this.v});

  final String? id;
  final String? blocker;
  final Blocked? blocked;
  final DateTime? createdAt;
  final int? v;

  factory BlockedUserDataModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserDataModel(
      id: json["_id"],
      blocker: json["blocker"],
      blocked: json["blocked"] == null ? null : Blocked.fromJson(json["blocked"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"],
    );
  }
}

class Blocked {
  Blocked({this.id, this.name, this.profileImage});

  final String? id;
  final String? name;
  final String? profileImage;

  factory Blocked.fromJson(Map<String, dynamic> json) {
    return Blocked(id: json["_id"], name: json["name"], profileImage: json["profileImage"]);
  }
}
