import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mama_app/app/helper_widgets_export.dart' hide FormData;
import 'package:mama_app/core/config/app_info.dart';
import 'package:mama_app/core/network/helpers/network_helpers.dart';

import '../../services/auth/signout_service.dart';
import 'api_error_parser.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 60),
        headers: {"Accept": "application/json"},

        // IMPORTANT
        validateStatus: (_) => true,
      ),
    );

    dio.interceptors.add(
      ///////////////--------------->>>>>>>>>
      InterceptorsWrapper(
        // onRequest: (options, handler) {
        //   final token = storage.getToken;
        //   if (token.isNotEmpty) {
        //     options.headers["Authorization"] = "Bearer $token";
        //   }
        //   return handler.next(options);
        // },
        onRequest: (options, handler) {
          if (kDebugMode) {
            log("➡️ REQUEST[${options.method}] => ${options.path}");
            log("Headers: ${options.headers}");
            log("Data: ${options.data}");

            if (options.data != null && options.data is FormData) {
              final formData = options.data as FormData;

              log("Fields:");
              for (final field in formData.fields) {
                log("${field.key}: ${field.value}");
              }

              if (formData.files.isNotEmpty) {
                log("Files:");
                for (final file in formData.files) {
                  log(
                    "${file.key}: filename=${file.value.filename}, contentType=${file.value.contentType}",
                  );
                }
              }
            } else if (options.data != null) {
              log("Data: ${jsonEncode(options.data)}");
            }
          }

          final token = storage.getToken;
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          final data = e.response?.data;

          if (statusCode == 401) {
            final message = ApiErrorParser.extractMessage(data).toLowerCase();

            if (message.contains("access token expired") ||
                message.contains("token expired")) {
              await SignoutService().signOut();
              Get.offAllNamed(RoutePaths.signin);
            }
          }

          handler.next(e);
        },
      ),
    );
  }
}

enum ResultType { success, emailNotVerified, profileIncomplete, failed }

class Result<T> {
  final ResultType type;
  final T? data;
  final String? message;

  Result({required this.type, this.data, this.message});
}

// class DioClient {
//   static final DioClient _instance = DioClient._internal();
//   factory DioClient() => _instance;

//   late Dio dio;
//   DioClient._internal() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 120),
//         sendTimeout: const Duration(seconds: 60),
//         headers: {"Accept": "application/json"},

//         // ✅ CRITICAL FIX: never throw on 4xx
//         // validateStatus: (status) {
//         //   return status != null && status < 500;
//         // },

//         // ✅ IMPORTANT FIX
//         validateStatus: (status) => true,
//       ),
//     );

//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           if (kDebugMode) {
//             log("➡️ REQUEST[${options.method}] => ${options.path}");
//             log("Headers: ${options.headers}");
//             log("Data: ${options.data}");

//             if (options.data != null && options.data is FormData) {
//               final formData = options.data as FormData;

//               log("Fields:");
//               for (final field in formData.fields) {
//                 log("${field.key}: ${field.value}");
//               }

//               if (formData.files.isNotEmpty) {
//                 log("Files:");
//                 for (final file in formData.files) {
//                   log(
//                     "${file.key}: filename=${file.value.filename}, contentType=${file.value.contentType}",
//                   );
//                 }
//               }
//             } else if (options.data != null) {
//               log("Data: ${jsonEncode(options.data)}");
//             }
//           }

//           final token = storage.getToken;
//           if (token.isNotEmpty) {
//             options.headers["Authorization"] = "Bearer $token";
//           }

//           return handler.next(options);
//         },

//         onResponse: (response, handler) {
//           if (kDebugMode) {
//             log("✅ RESPONSE[${response.statusCode}] => ${response.data}");
//           }
//           return handler.next(response);
//         },

//         onError: (DioException e, handler) {
//           if (kDebugMode) {
//             log("❌ ERROR[${e.response?.statusCode}] => ${e.message}");

//             // 🔥 IMPORTANT: log full backend payload
//             if (e.response?.data != null) {
//               log("🔥 ERROR BODY => ${e.response?.data}");
//             }
//           }

//           return handler.next(e);
//         },
//       ),
//     );
//   }
// }
