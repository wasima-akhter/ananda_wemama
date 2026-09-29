import 'dart:async';

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
        const msg = "Unable to connect to the server. Please try again later.";
        if (showErrorMessage) Snack.showError(msg);
        return Result(type: ApiResultType.failed, message: msg);
      }
      final body = response.data;

      if (body is! Map<String, dynamic>) {
        const msg =
            "We received an unexpected response from the server. Please try again later.";
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
      // } catch (e) {
      //   final msg = e.toString();
      //   print(msg);
      //   return Result(type: ApiResultType.failed, message: msg);
      // }
    } catch (e, stackTrace) {
      print('❌ [EXECUTOR] Exception caught: $e');
      print('❌ [EXECUTOR] Exception type: ${e.runtimeType}');
      print('❌ [EXECUTOR] Exception caught: $e');
      print('❌ [EXECUTOR] Exception type: ${e.runtimeType}');

      print('[EXECUTOR] StackTrace: $stackTrace');

      if (e is TimeoutException) {
        print('❌ [EXECUTOR] TIMEOUT - backend unreachable');
        if (showErrorMessage)
          Snack.showError('Request timed out. Please try again.');
      }

      final msg = e.toString();
      print(msg);
      return Result(type: ApiResultType.failed, message: msg);
    }
  }
}
