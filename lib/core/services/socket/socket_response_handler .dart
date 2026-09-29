import 'package:get/get.dart';

/// Normalized result from any socket event payload.
class SocketResponse {
  final int statusCode;
  final bool success;
  final String message;
  final dynamic data; // Map or List — caller casts

  const SocketResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;

  /// Convenience: data as a single object map (most events)
  Map<String, dynamic>? get dataAsMap =>
      data is Map ? Map<String, dynamic>.from(data as Map) : null;

  /// Convenience: data as a list (e.g. conversation_requests)
  List<dynamic>? get dataAsList => data is List ? data as List<dynamic> : null;

  @override
  String toString() =>
      'SocketResponse(status: $statusCode, success: $success, message: $message)';
}

/// Mirrors ApiResponseHandler — but for socket event payloads.
class SocketResponseHandler {
  SocketResponseHandler._(); // static-only class

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════

  /// Parse raw socket [data] and return a [SocketResponse].
  ///
  /// • On success  → returns the response (caller decides what to do)
  /// • On failure  → shows a snackbar AND returns the response
  ///                 (caller may still inspect it if needed)
  ///
  /// [eventName] is used only for logging / snackbar labelling.
  static SocketResponse handle(Map<String, dynamic> data, {String? eventName}) {
    final response = _parse(data);

    if (response.isSuccess) {
      _print(eventName, '✅ success → ${response.message}');

      print('📥 Socket Response: $response');

      return response;
    }

    // ── failure path ──────────────────────────────────────────────────────────
    _print(eventName, '❌ failure → ${response.message}');
    _showErrorSnackbar(response.message, eventName: eventName);

    return response;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE — parse
  // ═══════════════════════════════════════════════════════════════════════════

  static SocketResponse _parse(Map<String, dynamic> raw) {
    final statusCode = _parseInt(raw['statusCode']) ?? 0;
    final success = raw['success'] == true;
    final message = _extractMessage(raw);
    final data = raw['data'];

    return SocketResponse(
      statusCode: statusCode,
      success: success,
      message: message,
      data: data,
    );
  }

  /// Message extraction — mirrors ApiResponseHandler priority order.
  ///
  /// Priority:
  ///   1️⃣  root `message` field  (most backend events)
  ///   2️⃣  `errorDetails.issues[0].message`  (Zod validation, if ever on socket)
  ///   3️⃣  fallback
  static String _extractMessage(Map<String, dynamic> raw) {
    // 1️⃣ root message
    final rootMsg = raw['message'];
    if (rootMsg != null && rootMsg.toString().isNotEmpty) {
      return rootMsg.toString();
    }

    // 2️⃣ Zod-style error details
    final errorDetails = raw['errorDetails'];
    if (errorDetails is Map) {
      final issues = errorDetails['issues'];
      if (issues is List && issues.isNotEmpty) {
        final firstIssueMsg = issues.first['message'];
        if (firstIssueMsg != null && firstIssueMsg.toString().isNotEmpty) {
          return firstIssueMsg.toString();
        }
      }
    }

    // 3️⃣ fallback
    return 'Something went wrong';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE — UI + logging
  // ═══════════════════════════════════════════════════════════════════════════

  static void _showErrorSnackbar(String message, {String? eventName}) {
    final title = eventName != null && eventName.isNotEmpty
        ? '[$eventName] Error ❌'
        : 'Error ❌';

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  static void _print(String? eventName, String msg) {
    final tag = eventName != null ? '[$eventName]' : '[Socket]';
    print('🔌 $tag $msg');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE — helpers
  // ═══════════════════════════════════════════════════════════════════════════

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
