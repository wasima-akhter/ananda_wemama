import 'package:image_picker/image_picker.dart';

import '../../../../app/service_export.dart';

class ChatInboxService extends GetxService {
  final ApiServiceHelper _apiHelper = ApiServiceHelper();

  Future<dynamic> sendChatFile({
    required List<XFile> chatFiles,
    Map<String, String>? fields,
  }) async {
    final response = await _apiHelper.request<dynamic>(
      apiCall: () => ApiClient().postWithFile(
        Endpoints.sendChatFile.getUrl,
        reqName: Strings.uploadChatFile,
        files: chatFiles.map((f) => MapEntry('chat-files', f)).toList(),
        fields: fields,
      ),
      parser: (data) => data, // 👈 keep RAW
    );

    return (response == null || !response.success) ? null : response.data;
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
