import 'package:dio/dio.dart';

import '../../../app/helper_widgets_export.dart' hide Response;
import '../base/api_error_parser.dart';
import '../models/base_response_model.dart';

class ApiServiceHelper {
  /// Generic request handler
  Future<BaseResponse<T>?> request<T>({
    required Future<dynamic> Function() apiCall,
    T Function(dynamic)? parser,
  }) async {
    try {
      final res = await apiCall();

      // log("res:---> $res");

      //
      if (res == null) {
        "Something went wrong. Try again".showToast();
        return null;
      }
      // ✅ extract .data if it's a Dio Response
      final Map<String, dynamic> json;
      if (res is Response) {
        json = res.data as Map<String, dynamic>;
      } else if (res is Map<String, dynamic>) {
        json = res;
      } else {
        json = res;
      }

      //  log("res before calling BaseResponse: $json");

      // final response = BaseResponse<T>.fromJson(res, parser);
      final response = BaseResponse<T>.fromJson(json, parser);

      if (res is Response) {
        log("STATUS: ${res.statusCode}");
        log("DATA: ${res.data}");
      }

      // response.message.capEachWord().showToast();
      return response;
    } catch (e) {
      String errorMsg = "Something went wrong. Please try again.";

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

            final message = ApiErrorParser.extractMessage(data);
            final stack = ApiErrorParser.extractStack(data);

            log("MESSAGE: $message");
            if (stack != null) log("STACK:\n$stack");

            errorMsg = message;
            break;
          case DioExceptionType.unknown:
            errorMsg = "Unable to connect. Check your internet.";
            break;
          default:
            errorMsg = "Something went wrong. Please try again.";
        }
      }

      errorMsg.showToast();
      return null;
    }
  }
}
