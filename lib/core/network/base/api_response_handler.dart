import 'package:dio/dio.dart';
import 'package:mama_app/app/helper_widgets_export.dart' hide Response;

import '../../exceptions/exceptions.dart';
import '../../services/auth/signout_service.dart';
import 'api_error_parser.dart';

// Handles server responses

/* old one
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
*/

/// Turns a raw [Response] into either:
///  - the parsed backend payload (on success, or for `isLogin_: true` flows,
///    which always return instead of throwing), or
///  - a thrown, typed exception:
///      401           -> UnauthorisedException
///      413           -> FetchDataException("File too large")
///      other 4xx     -> BadRequestException
///      5xx / no resp -> FetchDataException (friendly generic message)
///
/// Every call is logged (status code + full response body) regardless of
/// outcome, and every failure additionally logs whether the backend
/// actually responded or the request looks like it never reached the
/// server at all.
class ApiResponseHandler {
  ApiResponseHandler._();

  static dynamic handle(Response response, String? reqName, {bool? isLogin_}) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final isLogin = isLogin_ ?? false;

    _logResponse(
      response: response,
      statusCode: statusCode,
      data: data,
      reqName: reqName,
    );

    final success = _isSuccess(statusCode, data);

    // ✅ SUCCESS
    if (success) return data;

    // 🔐 LOGIN FLOW → NEVER THROW, ALWAYS RETURN (success or error payload)
    // so the caller can inspect `data` itself (e.g. emailNotVerified /
    // profileIncomplete flags) and decide where to navigate.
    //
    // NOTE: previously this branch called `_handleError`, which *throws* -
    // directly contradicting the "no throw" intent below. That's fixed:
    // it now only logs + toasts (same status codes as before) and returns.
    if (isLogin) {
      log(
        "🔐 LOGIN FLOW → returning response without throwing (status: $statusCode)",
      );

      if (statusCode == 404 || statusCode == 400 || statusCode == 500) {
        _logAndToastError(data: data, statusCode: statusCode, reqName: reqName);
      }

      return data;
    }

    // ❌ THROW
    _handleError(data: data, statusCode: statusCode, reqName: reqName);
  }

  // ────────────────────────────────────────────────────────────────
  // success check
  // ────────────────────────────────────────────────────────────────

  /// 2xx AND (no `success` field OR `success != false`).
  /// Guarded against non-Map bodies (String/List/null), which previously
  /// crashed with a NoSuchMethodError when indexed as `data["success"]`.
  static bool _isSuccess(int statusCode, dynamic data) {
    if (statusCode < 200 || statusCode >= 300) return false;
    if (data is Map) return data["success"] != false;
    return true;
  }

  // ────────────────────────────────────────────────────────────────
  // logging — fires on EVERY call, success or failure
  // ────────────────────────────────────────────────────────────────

  static void _logResponse({
    required Response response,
    required int statusCode,
    required dynamic data,
    required String? reqName,
  }) {
    log("━━━━━━━━ API RESPONSE ━━━━━━━━");
    log("REQ: ${reqName ?? '-'}");
    log("METHOD: ${response.requestOptions.method}");
    log("URL: ${response.requestOptions.path}");
    log("STATUS: $statusCode");
    log("RESPONSE: $data");

    if (ApiErrorParser.looksLikeServerUnreachable(statusCode, data)) {
      log(
        "🚨 SERVER: request does not look like it reached the backend "
        "(no internet / server down / timeout)",
      );
    } else {
      log("✅ SERVER: reachable, responded with status $statusCode");
    }

    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  }

  // ────────────────────────────────────────────────────────────────
  // error logging + toast (shared by the login flow and the throwing flow)
  // ────────────────────────────────────────────────────────────────

  static void _logAndToastError({
    required dynamic data,
    required int statusCode,
    required String? reqName,
  }) {
    final rawMessage = ApiErrorParser.extractMessage(data);
    final stack = ApiErrorParser.extractStack(data);

    log("━━━━━━━━ API ERROR ━━━━━━━━");
    log("REQ: ${reqName ?? '-'}");
    log("STATUS: $statusCode");
    log("MESSAGE: $rawMessage");
    if (stack != null) log("🔥 BACKEND STACK:\n$stack");
    log("RAW RESPONSE --> : $data");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━");

    final friendly = _friendlyMessage(statusCode, rawMessage);
    final toastMsg = (reqName != null && reqName.isNotEmpty)
        ? "$reqName : $friendly"
        : friendly;

    // Single toast only (previously 500 could fire two toasts back to back:
    // the raw-message one below, then a second generic one).
    toastMsg.showToast();
  }

  /// Backend detail messages are fine for 4xx (bad input, validation, etc.)
  /// but for 5xx / "never reached the server" we show something the user
  /// can actually act on instead of a raw Dio/backend string.
  static String _friendlyMessage(int statusCode, String rawMessage) {
    if (statusCode <= 0) {
      return "Unable to reach the server. Please check your internet connection and try again.";
    }
    if (statusCode >= 500) {
      return "Something went wrong. Please try again in a moment.";
    }
    return rawMessage;
  }

  // ────────────────────────────────────────────────────────────────
  // throwing flow (non-login)
  // ────────────────────────────────────────────────────────────────
  static bool _isTokenExpired(int statusCode, dynamic data) {
    if (statusCode != 401) return false;

    final message = ApiErrorParser.extractMessage(data).toLowerCase();

    return message.contains("access token expired") ||
        message.contains("token expired") ||
        message.contains("jwt expired") ||
        message.contains("expired");
  }

  static bool _loggingOut = false;

  static Future<void> _logoutUser() async {
    if (_loggingOut) return;

    _loggingOut = true;

    try {
      // Clear local data
      await SignoutService().signOut();

      // Navigate to login
      Get.offAllNamed(RoutePaths.signin);
    } finally {
      _loggingOut = false;
    }
  }

  static Never _handleError({
    required dynamic data,
    required int statusCode,
    required String? reqName,
  }) {
    _logAndToastError(data: data, statusCode: statusCode, reqName: reqName);

    final rawMessage = ApiErrorParser.extractMessage(data);
    final friendly = _friendlyMessage(statusCode, rawMessage);

    if (_isTokenExpired(statusCode, data)) {
      _logoutUser();
      throw UnauthorisedException("Session expired. Please login again.");
    }
    if (statusCode == 401) {
      throw UnauthorisedException(friendly);
    }

    // NOTE: this must be checked BEFORE the generic 4xx range below.
    // Previously 413 sat *after* the `>= 400 && < 500` check, so it was
    // unreachable dead code — every 413 was silently thrown as a
    // BadRequestException instead of the intended "File too large".
    if (statusCode == 413) {
      throw FetchDataException("File too large");
    }

    if (statusCode >= 400 && statusCode < 500) {
      throw BadRequestException(friendly);
    }

    // 500, other 5xx, and "no response at all" (statusCode <= 0) all land
    // here with the same exception type as before (FetchDataException),
    // just with a clearer message.
    throw FetchDataException(friendly);
  }
}
