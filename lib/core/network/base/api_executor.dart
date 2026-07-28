import 'dart:developer';

import 'package:dio/dio.dart';

import '../../utils/extension/context_extension.dart';
import 'api_error_parser.dart';
import 'dio_client.dart';

class ApiExecutor {
  Future<Result<T>> execute<T>({
    required Future<Response?> Function() apiCall,
    T Function(dynamic)? parser,
    Result<T> Function(dynamic body)? customHandler,
    bool showSuccessMessage = false, // 👈 opt-in per call
    bool showErrorMessage =
        true, // 👈 opt-out per call (errors usually should show)
  }) async {
    try {
      final response = await apiCall();

      if (response == null) {
        const msg = "No server response";
        if (showErrorMessage) Snack.showError(msg);
        return Result(type: ApiResultType.failed, message: msg);
      }

      final body = response.data;

      if (body is! Map<String, dynamic>) {
        const msg = "Invalid server response";
        if (showErrorMessage) Snack.showError(msg);
        return Result(type: ApiResultType.failed, message: msg);
      }

      // login/social login/etc
      if (customHandler != null) {
        return customHandler(body);
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final message = body["message"]?.toString() ?? "";

        if (showSuccessMessage && message.isNotEmpty) {
          Snack.showSuccess(message);
        }

        return Result(
          type: ApiResultType.success,
          statusCode: response.statusCode,
          message: message,
          meta: body["meta"] != null
              ? PaginationMeta.fromJson(body["meta"])
              : null,
          raw: body,
          data: parser == null ? null : parser(body["data"]),
        );
      }

      final errorMessage = ApiErrorParser.extractMessage(body);

      if (showErrorMessage) {
        Snack.showError(errorMessage);
      }

      return Result(
        type: ApiResultType.failed,
        statusCode: response.statusCode,
        message: errorMessage,
      );
    } catch (e) {
      final msg = e.toString();
      log(msg);
      return Result(type: ApiResultType.failed, message: msg);
    }
  }
}
