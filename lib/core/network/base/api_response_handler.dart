import 'package:dio/dio.dart';
import 'package:mama_app/app/helper_widgets_export.dart' hide Response;

import '../../exceptions/exceptions.dart';
import 'api_error_parser.dart';

// Handles server responses

class ApiResponseHandler {
  static dynamic handle(Response response, String? reqName) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // ✅ SUCCESS
    if (statusCode >= 200 && statusCode < 300) {
      //   log("response : --> $response");
      return data;
    }

    // ❌ ERROR
    _handleError(data, statusCode, reqName);
  }

  static void _handleError(dynamic data, int statusCode, String? reqName) {
    final message = ApiErrorParser.extractMessage(data);
    final stack = ApiErrorParser.extractStack(data);

    // ─── FULL DEBUG LOG ─────────────────────────────
    log("━━━━━━━━ API ERROR ━━━━━━━━");
    log("REQ: $reqName");
    log("STATUS: $statusCode");
    log("MESSAGE: $message");

    if (stack != null) {
      log("🔥 BACKEND STACK:\n$stack");
    }

    log("RAW RESPONSE: $data");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━");

    // toast (clean)
    final toastMsg = reqName != null && reqName.isNotEmpty
        ? "$reqName : $message"
        : message;

    toastMsg.showToast();

    // ─── THROW CLEAN EXCEPTIONS ─────────────────────
    if (statusCode == 401) {
      throw UnauthorisedException(message);
    }

    if (statusCode >= 400 && statusCode < 500) {
      throw BadRequestException(message);
    }

    if (statusCode == 413) {
      throw FetchDataException("File too large");
    }

    throw FetchDataException(message);
  }
}
