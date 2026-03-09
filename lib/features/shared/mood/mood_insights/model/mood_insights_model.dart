class NotificationsDataModel {
  NotificationsDataModel({
    this.id,
    this.toId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSeen,
  });

  final String? id;
  final String? toId;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isSeen;

  factory NotificationsDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationsDataModel(
      id: json["_id"],
      toId: json["toId"],
      title: json["title"],
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"].toString()) : null,

      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"].toString()) : null,
      v: json["__v"],
      isSeen: json["isSeen"],
    );
  }

  NotificationsDataModel copyWith({bool? isSeen}) {
    return NotificationsDataModel(
      id: id,
      title: title,
      createdAt: createdAt,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}
