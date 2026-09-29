import 'package:image_picker/image_picker.dart';

import '../../../../app/service_export.dart';
import '../model/chat_inbox_msg_item_model.dart';

class ChatInboxService extends GetxService {
  Future<ChatMessagesPage> fetchMessagesPaged({
    required String conversationId,
    required int page,
    required int limit,
  }) async {
    apiCall() {
      return ApiClient().get(
        Endpoints.getAllMessages(
          conversationId: conversationId,
          page: page,
          limit: limit,
        ).getUrl,
        headers: HeaderHelpers.getAuthHeader(),
      );
    }

    final response = await ApiExecutor().execute<ChatInboxMessageItemModel>(
      apiCall: apiCall,

      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ChatInboxMessageItemModel.fromJson(data);
        }
        return ChatInboxMessageItemModel();
      },
    );

    final item = response.data ?? ChatInboxMessageItemModel();

    return ChatMessagesPage(
      messages: item.messages,
      meta: response.meta,
      item: item,
    );
  }

  //

  Future<dynamic> sendChatFile({
    required List<XFile> chatFiles,
    Map<String, String>? fields,
  }) async {
    /// LOG FILES
    print("📤 [CHAT FILE UPLOAD] Total Files: ${chatFiles.length}");

    for (int i = 0; i < chatFiles.length; i++) {
      final file = chatFiles[i];

      print("""
📎 FILE ${i + 1}
Name: ${file.name}
Path: ${file.path}
MimeType: ${file.mimeType}
Length(bytes): ${await file.length()}
-----------------------------------
""");
    }

    /// LOG FIELDS
    print("📝 Fields: $fields");

    final response = await ApiExecutor().execute<dynamic>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.sendChatFile.getUrl,
        // reqName: Strings.uploadChatFile,
        files: chatFiles.map((f) {
          print("✅ Sending File => field: chat-files | file: ${f.name}");

          return MapEntry('chat-files', f);
        }).toList(),
        fields: fields,
      ),

      parser: (data) => data,
    );

    print("📥 Upload Response: ${response.data}");
    print("📥 Upload Success: ${response.isSuccess}");

    return (!response.isSuccess) ? null : response.data;
  }
}

class UploadedFile {
  final String? url;
  final String? key;
  final String? type;
  final int? size;
  final String? originalName;

  UploadedFile({this.url, this.key, this.type, this.size, this.originalName});

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      url: json["url"],
      key: json["key"],
      type: json["type"],
      size: json["size"],
      originalName: json["originalName"],
    );
  }
}

class ChatFilesResponse {
  ChatFilesResponse({required this.files});

  final List<UploadedFile> files;

  factory ChatFilesResponse.fromJson(dynamic json) {
    // CASE 1: List response
    if (json is List) {
      return ChatFilesResponse(
        files: json
            .cast<Map<String, dynamic>>()
            .map((e) => UploadedFile.fromJson(e))
            .toList(),
      );
    }

    // CASE 2: Map response (single file OR wrapped response)
    if (json is Map<String, dynamic>) {
      // if backend wraps in "data"
      final data = json['data'];

      if (data is List) {
        return ChatFilesResponse(
          files: data
              .cast<Map<String, dynamic>>()
              .map((e) => UploadedFile.fromJson(e))
              .toList(),
        );
      }

      // single file object
      return ChatFilesResponse(files: [UploadedFile.fromJson(json)]);
    }

    throw Exception("Unsupported response format: ${json.runtimeType}");
  }
}
