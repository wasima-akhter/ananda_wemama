import 'package:dio/dio.dart';
import 'package:mama_app/app/helper_widgets_export.dart' hide Response;

import '../../exceptions/exceptions.dart';

// Handles server responses

class ApiResponseHandler {
  static dynamic handle(Response response, String? reqName) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // ✅ SUCCESS
    if (statusCode >= 200 && statusCode < 300) {
      return data;
    }

    // ❌ ERROR
    _handleError(data, statusCode, reqName);
  }

  static void _handleError(dynamic data, int statusCode, String? reqName) {
    String message = "Something went wrong";

    if (data is Map) {
      /// 🔴 1️⃣ Main backend message (MOST IMPORTANT)
      if (data["message"] != null && data["message"].toString().isNotEmpty) {
        message = data["message"].toString();
      }

      /// 🟠 2️⃣ ZOD VALIDATION ERRORS (errorDetails.issues)
      final errorDetails = data["errorDetails"];
      if (errorDetails is Map && errorDetails["issues"] is List) {
        final issues = errorDetails["issues"] as List;
        if (issues.isNotEmpty && issues.first["message"] != null) {
          message = issues.first["message"].toString();
        }
      }
    }

    /// 🔔 Show toast with request name (optional)
    ///
    if (reqName != null && reqName.isNotEmpty) {
      "$reqName : $message".showToast();
    } else {
      message.showToast();
    }

    /// 🚨 Throw proper exception for repository layer
    if (statusCode == 401) {
      throw UnauthorisedException(message);
    } else if (statusCode >= 400 && statusCode < 500) {
      throw BadRequestException(message);
    } else if (statusCode >= 500) {
      throw FetchDataException("Server error. Please try again later. ");
    } else if (statusCode == 413) {
      log("❌ 413: File too large — server rejected the upload");
      // Show user-facing error
      Snack.show(
        title: "Upload Failed",
        "Image is too large. Please use a smaller image.",
      );
    } else {
      throw FetchDataException(message);
    }
  }
}
