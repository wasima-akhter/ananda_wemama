// notification_payload.dart — strongly typed model for the incoming payload

import 'dart:convert';

class NotificationPayload {
  final String? toId;
  final String? toModel;
  final String title;
  final String description;
  final String type;
  final String? referenceId;
  final String? referenceModel;
  final Map<String, dynamic> metadata;

  // ✅ NEW FIELDS
  final int newCount;
  final int unreadCount;

  const NotificationPayload({
    this.toId,
    this.toModel,
    required this.title,
    required this.description,
    required this.type,
    this.referenceId,
    this.referenceModel,
    this.metadata = const {},
    this.newCount = 0,
    this.unreadCount = 0,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    Map<String, dynamic> parsedMetadata = {};

    final rawMeta = data['metadata'] ?? data['metaData'];
    if (rawMeta is String && rawMeta.isNotEmpty) {
      try {
        parsedMetadata = jsonDecode(rawMeta) as Map<String, dynamic>;
      } catch (_) {}
    } else if (rawMeta is Map<String, dynamic>) {
      parsedMetadata = rawMeta;
    }

    return NotificationPayload(
      toId: data['toId']?.toString(),
      toModel: data['toModel']?.toString(),
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      referenceId: data['referenceId']?.toString().replaceAll('"', ''),
      referenceModel: data['referenceModel']?.toString(),
      metadata: parsedMetadata,

      // ✅ parse counts safely
      newCount: _toInt(data['newCount']),
      unreadCount: _toInt(data['unreadCount']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  factory NotificationPayload.fromJsonString(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return NotificationPayload.fromMap(map);
    } catch (e) {
      print('⚠️ [NotificationPayload] failed to parse JSON string: $e');
      return const NotificationPayload(title: '', description: '', type: '');
    }
  }

  Map<String, dynamic> toMap() => {
    'toId': toId,
    'toModel': toModel,
    'title': title,
    'description': description,
    'type': type,
    'referenceId': referenceId,
    'referenceModel': referenceModel,
    'metadata': metadata,

    // ✅ include counts in serialization too (optional but recommended)
    'newCount': newCount,
    'unreadCount': unreadCount,
  };

  String toJsonString() => jsonEncode(toMap());

  @override
  String toString() =>
      '[NotificationPayload] type=$type | title=$title | ref=$referenceId ($referenceModel) | new=$newCount | unread=$unreadCount | metadata=$metadata';
}
