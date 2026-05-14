import 'dart:developer';

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponse({required this.success, required this.message, this.data});

  // Generic factory to parse JSON
  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    T? parsedData;

 
     try {
    if (json['data'] != null && fromJsonT != null) {
      final rawData = json['data'];


      log("res before parsing: ${rawData.toString()}");


      // Just pass rawData safely to parser
      parsedData = fromJsonT(rawData);
    }
  } catch (e, st) {
    print("❌ BaseResponse parsing error: $e\n$st");
    parsedData = null;
  }

    return BaseResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}
