// notification_payload.dart — strongly typed model for the incoming payload

import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationPayload {
  final String? toId;
  final String? toModel;
  final String title;
  final String description;
  final String type;
  final String? referenceId;
  final String? referenceModel;
  final Map<String, dynamic> metadata;

  const NotificationPayload({
    this.toId,
    this.toModel,
    required this.title,
    required this.description,
    required this.type,
    this.referenceId,
    this.referenceModel,
    this.metadata = const {},
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    // metadata arrives as a JSON string from FCM data payload
    Map<String, dynamic> parsedMetadata = {};
    final rawMeta = data['metadata'];
    if (rawMeta != null && rawMeta is String && rawMeta.isNotEmpty) {
      try {
        parsedMetadata = jsonDecode(rawMeta) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('⚠️ [NotificationPayload] failed to parse metadata: $e');
      }
    } else if (rawMeta is Map<String, dynamic>) {
      parsedMetadata = rawMeta;
    }

    return NotificationPayload(
      toId: data['toId']?.toString(),
      toModel: data['toModel']?.toString(),
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      type: data['type']?.toString() ?? '',
      referenceId: data['referenceId']?.toString(),
      referenceModel: data['referenceModel']?.toString(),
      metadata: parsedMetadata,
    );
  }

  factory NotificationPayload.fromJsonString(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return NotificationPayload.fromMap(map);
    } catch (e) {
      debugPrint('⚠️ [NotificationPayload] failed to parse JSON string: $e');
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
  };

  String toJsonString() => jsonEncode(toMap());

  @override
  String toString() =>
      '[NotificationPayload] type=$type | title=$title | ref=$referenceId ($referenceModel) | metadata=$metadata';
}
