class NotificationItemModel {
  NotificationItemModel({
    this.id,
    this.toId,
    this.toModel,
    this.title,
    this.description,
    this.type,
    this.referenceId,
    this.referenceModel,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  final String? id;
  final String? toId;
  final String? toModel;
  final String? title;
  final String? description;
  final String? type;
  final String? referenceId;
  final String? referenceModel;
  final bool? isSeen;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json["_id"],
      toId: json["toId"],
      toModel: json["toModel"],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      referenceId: json["referenceId"],
      referenceModel: json["referenceModel"],
      isSeen: json["isSeen"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  // ✅ Added copyWith
  NotificationItemModel copyWith({
    String? id,
    String? toId,
    String? toModel,
    String? title,
    String? description,
    String? type,
    String? referenceId,
    String? referenceModel,
    bool? isSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      toId: toId ?? this.toId,
      toModel: toModel ?? this.toModel,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      referenceModel: referenceModel ?? this.referenceModel,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
