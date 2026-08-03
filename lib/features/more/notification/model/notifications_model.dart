import 'dart:convert';

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
    this.metadata, // ✅ added
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
  final NotificationMetadata? metadata; // ✅ added

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
      metadata:
          json["metadata"] !=
              null // ✅ added
          ? NotificationMetadata.fromJson(json["metadata"])
          : null,
    );
  }

  /// ✅ Parse from FCM push notification data map (all values are strings)
  factory NotificationItemModel.fromPushData(Map<String, dynamic> data) {
    return NotificationItemModel(
      id: data["_id"] ?? data["id"],
      toId: data["toId"],
      toModel: data["toModel"],
      title: data["title"],
      description: data["description"],
      type: data["type"],
      referenceId: data["referenceId"],
      referenceModel: data["referenceModel"],
      isSeen: data["isSeen"] == "true",
      metadata: data["metadata"] != null
          ? NotificationMetadata.fromJson(
              data["metadata"] is String
                  ? jsonDecode(
                      data["metadata"],
                    ) // FCM sends nested as JSON string
                  : data["metadata"],
            )
          : null,
    );
  }

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
    NotificationMetadata? metadata,
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
      metadata: metadata ?? this.metadata,
    );
  }
}

/// ✅ Covers all metadata shapes across notification types
class NotificationMetadata {
  final String? postId; // likePost, commentPost
  final bool? isBlocked; // sentMessage

  NotificationMetadata({this.postId, this.isBlocked});

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) {
    return NotificationMetadata(
      postId: json["postId"],
      isBlocked: json["isBlocked"] is bool
          ? json["isBlocked"]
          : json["isBlocked"] == "true", // FCM sends strings
    );
  }
}
// export const ENUM_NOTIFICATION_TYPE = {
//     LIKE_POST : "LIKE_POST",
//     COMMENT_POST : "COMMENT_POST",
//     APPROVE_COMMUNITY : "APPROVE_COMMUNITY",
//     SENT_MESSAGE : "SENT_MESSAGE",
//     SENT_WAVE : "SENT_WAVE",
//     ACCEPT_WAVE : "ACCEPT_WAVE",
//     REJECT_WAVE : "REJECT_WAVE",
//     OTHER : "OTHER"
// }

class NotificationTypes {
  static const likePost = "LIKE_POST";
  static const commentPost = "COMMENT_POST";
  static const approveCommunity = "APPROVE_COMMUNITY";
  static const sentMessage = "SENT_MESSAGE";
  static const sentWave = "SENT_WAVE";
  static const acceptWave = "ACCEPT_WAVE";
  static const rejectWave = "REJECT_WAVE";
  static const other = "OTHER";
  static const sessionReminder = "SESSION_REMINDER";
}
