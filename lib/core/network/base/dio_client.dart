import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_app/core/config/app_info.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120), // ✅ was 30s, now 2 min
        sendTimeout: const Duration(seconds: 60),
        headers: {"Accept": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint("➡️ REQUEST[${options.method}] => ${options.path}");
            debugPrint("Headers: ${options.headers}");
            debugPrint("Data: ${options.data}");

            if (options.data != null && options.data is FormData) {
              final formData = options.data as FormData;

              // 1️⃣ Log fields
              log("Fields:");
              for (final field in formData.fields) {
                log("${field.key}: ${field.value}");
              }

              // 2️⃣ Log files
              if (formData.files.isNotEmpty) {
                log("Files:");
                for (final file in formData.files) {
                  log(
                    "${file.key}: filename=${file.value.filename}, contentType=${file.value.contentType}",
                  );
                }
              }
            } else if (options.data != null) {
              // If it's normal JSON or Map
              log("Data: ${jsonEncode(options.data)}");
            }
          }

          // 🔐 Attach token automatically
          // final token = AuthStorage.getToken();
          // if (token != null) options.headers["Authorization"] = "Bearer $token";

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint("✅ RESPONSE[${response.statusCode}] => ${response.data}");
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint("❌ ERROR[${e.response?.statusCode}] => ${e.message}");
          }
          return handler.next(e);
        },
      ),
    );
  }
}
