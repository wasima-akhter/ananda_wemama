import 'package:dio/dio.dart';
import 'package:mama_app/app/helper_widgets_export.dart' hide Response;

import '../../exceptions/exceptions.dart';
import 'api_error_parser.dart';

// Handles server responses

class ApiResponseHandler {
  // static dynamic handle(
  //   Response response,
  //   String? reqName, {
  //   bool returnErrorResponse = false,
  // }) {
  //   final statusCode = response.statusCode ?? 0;
  //   final data = response.data;

  //   // ✅ SUCCESS
  //   if (statusCode >= 200 && statusCode < 300) {
  //     return data;
  //   }

  //   // ✅ RETURN ERROR RESPONSE INSTEAD OF THROWING
  //   if (returnErrorResponse) {
  //     _handleError(response, statusCode, reqName);
  //     return data;
  //   }

  //   // ❌ THROW ERROR
  //   _handleError(data, statusCode, reqName);
  // }
  static dynamic handle(Response response, String? reqName, {bool? isLogin_}) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    final isLogin = isLogin_ ?? false;

    final isSuccess =
        statusCode >= 200 && statusCode < 300 && data?["success"] != false;

    // ✅ SUCCESS
    if (isSuccess) return data;

    // 🔥 LOGIN → ALWAYS RETURN (NO THROW)
    if (isLogin) {
      log("🔐 LOGIN FLOW → returning response (success or error)--> $response");
      if (statusCode == 404) _handleError(response, statusCode, reqName);
      if (statusCode == 400) _handleError(response, statusCode, reqName);
      if (statusCode == 500) _handleError(response, statusCode, reqName);

      return data;
    }

    _handleError(data, statusCode, reqName);
  }

  static void _handleError(dynamic data, int statusCode, String? reqName) {
    final message = ApiErrorParser.extractMessage(data);
    final stack = ApiErrorParser.extractStack(data);

    log("━━━━━━━━ API ERROR ━━━━━━━━");
    log("REQ: $reqName");
    log("STATUS: $statusCode");
    log("MESSAGE: $message");

    if (stack != null) {
      log("🔥 BACKEND STACK:\n$stack");
    }

    log("RAW RESPONSE --> : $data");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━");

    final toastMsg = reqName != null && reqName.isNotEmpty
        ? "$reqName : $message"
        : message;

    toastMsg.showToast();

    if (statusCode == 401) {
      throw UnauthorisedException(message);
    }

    if (statusCode >= 400 && statusCode < 500) {
      throw BadRequestException(message);
    }

    if (statusCode == 413) {
      throw FetchDataException("File too large");
    }
    if (statusCode == 500) {
      "Something went wrong. Please try again in a moment.".showToast();
      throw FetchDataException(
        "Something went wrong. Please try again in a moment.",
      );
    }

    throw FetchDataException(message);
  }
}
