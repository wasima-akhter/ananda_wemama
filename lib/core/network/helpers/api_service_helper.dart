import 'package:dio/dio.dart';

import '../../../app/helper_widgets_export.dart' hide Response;
import '../base/api_error_parser.dart';
import '../models/base_response_model.dart';

class ApiServiceHelper {
  /// Generic request handler
  Future<BaseResponse<T>?> request<T>({
    required Future<dynamic> Function() apiCall,
    T Function(dynamic)? parser,
    String? reqName,
    bool? isLogin_,
  }) async {
    // try {
    //   final res = await apiCall();

    //   log("res:---> $res");

    //   //
    //   if (res == null) {
    //     "Something went wrong. Try again".showToast();
    //     return null;
    //   }
    //   // ✅ extract .data if it's a Dio Response
    //   final Map<String, dynamic> json;
    //   if (res is Response) {
    //     json = res.data as Map<String, dynamic>;
    //   } else if (res is Map<String, dynamic>) {
    //     json = res;
    //   } else {
    //     json = res;
    //   }

    //   //  log("res before calling BaseResponse: $json");

    //   // final response = BaseResponse<T>.fromJson(res, parser);
    //   final response = BaseResponse<T>.fromJson(json, parser);

    //   if (res is Response) {
    //     log("STATUS: ${res.statusCode}");
    //     log("DATA: ${res.data}");
    //   }

    //   // response.message.capEachWord().showToast();
    //   return response;
    // }
    try {
      final res = await apiCall();

      log("res:---> $res");

      if (res == null) {
        "Something went wrong. Try again".showToast();
        return null;
      }

      final bool isLogin = isLogin_ ?? false;

      // 🔥 LOGIN SPECIAL FLOW
      if (isLogin) {
        log("🔐 LOGIN FLOW → skipping BaseResponse parsing");

        final json = res is Response ? res.data : res;

        log("🔐 LOGIN RAW JSON: $json");

        return BaseResponse<T>.fromJson(json as Map<String, dynamic>, parser);
      }

      // ✅ NORMAL FLOW (ALL OTHER APIs)
      final Map<String, dynamic> json;

      if (res is Response) {
        json = res.data as Map<String, dynamic>;
      } else if (res is Map<String, dynamic>) {
        json = res;
      } else {
        json = res as Map<String, dynamic>;
      }

      final response = BaseResponse<T>.fromJson(json, parser);

      if (res is Response) {
        log("STATUS: ${res.statusCode}");
        log("DATA: ${res.data}");
      }

      return response;
    } catch (e) {
      log("e in dio client: $e");
      // String errorMsg = (e.toString().isNotEmpty && e.toString() != "null")
      //     ? e.toString()
      //     : "Something went wrong. Please try again.";
      String errorMsg = "";

      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            errorMsg = "Connection timed out. Check your internet.";
            break;
          case DioExceptionType.cancel:
            errorMsg = "Request was canceled.";
            break;
          case DioExceptionType.badResponse:
            final data = e.response?.data;
            log("━━━━━━━━ DIO BAD RESPONSE ━━━━━━━━");
            log("STATUS: ${e.response?.statusCode}");
            log("DATA: $data");
            String message =
                data?["message"] ??
                data?["data"]?["msg"] ??
                ApiErrorParser.extractMessage(data) ??
                "Something went wrong. Please try again.";
            final stack = ApiErrorParser.extractStack(data);
            log("MESSAGE--->: $message");
            if (stack != null) log("STACK:\n$stack");
            errorMsg = message;

            log("errorMsg after errorMsg = message;: $errorMsg");
            break;
          case DioExceptionType.unknown:
            errorMsg = "Unable to connect. Check your internet.";
            break;
          default:
            errorMsg = "Something went wrong. Please try again.";
        }
      }
      errorMsg.isNotEmpty ? errorMsg.showToast() : null;
      return null;
    }
  }
}
