import 'dart:developer';

import 'package:dio/dio.dart';

class ApiErrorParser {
  static String extractMessage(dynamic data) {
    log("━━━━━━━━ API PARSER START ━━━━━━━━");
    log("data runtimeType: ${data.runtimeType}");

    try {
      // ✅ If whole Dio Response is passed
      if (data is Response) {
        log("✅ data is Dio Response");
        data = data.data;
        log("✅ extracted response.data: $data");
      }

      // ✅ String response
      if (data is String) {
        log("✅ data is String");

        if (data.isNotEmpty) {
          return data;
        }
      }

      // ✅ Map response
      if (data is Map) {
        log("✅ data is Map");

        final message = data["message"];

        if (message != null && message.toString().trim().isNotEmpty) {
          log("✅ returning direct message : $message");
          return message.toString();
        }

        final nestedMsg = data["data"]?["msg"];

        if (nestedMsg != null && nestedMsg.toString().trim().isNotEmpty) {
          log("✅ returning nested msg");
          return nestedMsg.toString();
        }

        final errorDetails = data["errorDetails"];

        if (errorDetails is Map && errorDetails["issues"] is List) {
          final issues = errorDetails["issues"];

          if (issues.isNotEmpty && issues.first["message"] != null) {
            log("✅ returning issue message");
            return issues.first["message"].toString();
          }
        }
      }
    } catch (e, stack) {
      log("❌ parser error: $e");
      log("$stack");
    }

    log("⚠️ fallback message");
    return "Something went wrong";
  }

  static String? extractStack(dynamic data) {
    try {
      // ✅ If whole Dio Response is passed
      if (data is Response) {
        data = data.data;
      }

      if (data is Map && data["stack"] != null) {
        return data["stack"].toString();
      }
    } catch (e) {
      log("❌ stack parser error: $e");
    }

    return null;
  }
}
