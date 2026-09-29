import 'package:dio/dio.dart';

class ApiErrorParser {
  ApiErrorParser._();

  static const String _fallbackMessage = "Something went wrong";

  /// Extracts the best human-readable message out of [data].
  /// [data] can be a raw response body (Map/List/String/null) OR a whole
  /// [Response] object — both are supported for convenience/back-compat.
  static String extractMessage(dynamic data) {
    try {
      data = _unwrapResponse(data);
      if (data == null) {
        return data;
      }

      if (data is String && data.trim().isNotEmpty) {
        return data;
      }

      if (data is Map) {
        // 1) top-level "message"
        final message = data["message"];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }

        // 2) legacy nested "data.msg"
        final nested = data["data"];
        if (nested is Map) {
          final nestedMsg = nested["msg"];
          if (nestedMsg != null && nestedMsg.toString().trim().isNotEmpty) {
            return nestedMsg.toString();
          }
        }

        // 3) zod-style "errorDetails.issues[]" — join ALL issues, not just
        // the first one, so multi-field validation errors are fully shown.
        final errorDetails = data["errorDetails"];
        if (errorDetails is Map && errorDetails["issues"] is List) {
          final issues = errorDetails["issues"] as List;

          final issueMessages = issues
              .map((issue) => issue is Map ? issue["message"] : null)
              .where((m) => m != null && m.toString().trim().isNotEmpty)
              .map((m) => m.toString())
              .toList();

          if (issueMessages.isNotEmpty) {
            return issueMessages.join('\n');
          }
        } else if (errorDetails is String && errorDetails.trim().isNotEmpty) {
          return errorDetails;
        }
      }
    } catch (e, stack) {
      print("❌ ApiErrorParser.extractMessage error: $e");
      print("$stack");
    }

    return _fallbackMessage;
  }

  /// Extracts a backend stack trace, if the backend sent one (debug builds).
  static String? extractStack(dynamic data) {
    try {
      data = _unwrapResponse(data);

      if (data is Map && data["stack"] != null) {
        final stack = data["stack"].toString();
        return stack.trim().isEmpty ? null : stack;
      }
    } catch (e) {
      print("❌ ApiErrorParser.extractStack error: $e");
    }

    return null;
  }

  /// True when [data]/[statusCode] look like the request never actually
  /// reached the backend (DNS failure, connection refused, timeout, etc.)
  /// rather than the backend genuinely responding with an error.
  ///
  /// This is purely informational (for logging) — it never changes which
  /// exception gets thrown.
  static bool looksLikeServerUnreachable(int statusCode, dynamic data) {
    if (statusCode <= 0) return true;

    final raw = _unwrapResponse(data);
    final text = raw is Map
        ? (raw["message"]?.toString() ?? '')
        : (raw?.toString() ?? '');
    final lower = text.toLowerCase();

    const signals = [
      'socketexception',
      'connection refused',
      'connection timed out',
      'connection timeout',
      'failed host lookup',
      'network is unreachable',
      'xmlhttprequest error',
      'software caused connection abort',
      'no address associated with hostname',
      'connection closed before full header',
    ];

    return signals.any(lower.contains);
  }

  static dynamic _unwrapResponse(dynamic data) {
    if (data is Response) return data.data;
    return data;
  }
}
