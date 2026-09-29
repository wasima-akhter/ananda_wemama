import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:we_mama/app/helper_widgets_export.dart' hide FormData;
import 'package:we_mama/core/config/app_info.dart';
import 'package:we_mama/core/network/helpers/network_helpers.dart';

import '../../services/auth/signout_service.dart';
import 'api_error_parser.dart';
import 'api_logger.dart';

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

        // keep old behavior
        validateStatus: (_) => true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print("➡️ ${options.method} ${options.path}");

            print("Headers: ${options.headers}");

            print("Data: ${options.data}");

            if (options.data is FormData) {
              final form = options.data as FormData;

              for (final field in form.fields) {
                print("FIELD ${field.key}: ${field.value}");
              }

              for (final file in form.files) {
                print("FILE ${file.key}: ${file.value.filename}");
              }
            }
          }

          final token = storage.getToken;

          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },

        onError: (DioException e, handler) async {
          final status = e.response?.statusCode;

          final data = e.response?.data;

          if (status == 401) {
            final message = ApiErrorParser.extractMessage(data).toLowerCase();

            if (message.contains("token expired") ||
                message.contains("access token expired") ||
                message.contains("jwt expired")) {
              await SignoutService().signOut();

              Get.offAllNamed(RoutePaths.signin);
            }
          }

          handler.next(e);
        },

        onResponse: (response, handler) {
          if (kDebugMode) {
            ApiLogger.response(
              url: response.requestOptions.uri.toString(),
              method: response.requestOptions.method,
              statusCode: response.statusCode ?? 0,
              body: response.data,
            );
          }

          handler.next(response);
        },
      ),
    );
  }
}

enum ApiResultType { success, emailNotVerified, profileIncomplete, failed }

class Result<T> {
  final ApiResultType type;

  final T? data;

  final String? message;

  final int? statusCode;

  final PaginationMeta? meta;

  final dynamic raw;

  bool get isSuccess => type == ApiResultType.success;

  bool get isFailure => !isSuccess;

  Result({
    required this.type,
    this.data,
    this.message,
    this.statusCode,
    this.meta,
    this.raw,
  });
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;
  final bool hasNextPage;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
    required this.hasNextPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: int.tryParse(json['page'].toString()) ?? 1,
      limit: int.tryParse(json['limit'].toString()) ?? 10,
      total: int.tryParse(json['total'].toString()) ?? 0,
      totalPage: int.tryParse(json['totalPage'].toString()) ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
