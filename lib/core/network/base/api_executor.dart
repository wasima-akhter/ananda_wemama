import 'package:dio/dio.dart';

import 'api_error_parser.dart';
import 'dio_client.dart';

class ApiExecutor {
  Future<Result<T>> execute<T>({
    required Future<Response?> Function() apiCall,
    T Function(dynamic)? parser,
    Result<T> Function(dynamic body)? customHandler,
  }) async {
    try {
      final response = await apiCall();

      if (response == null) {
        return Result(
          type: ApiResultType.failed,
          message: "No server response",
        );
      }

      final body = response.data;

      if (body is! Map<String, dynamic>) {
        return Result(
          type: ApiResultType.failed,
          message: "Invalid server response",
        );
      }

      // login/social login/etc
      if (customHandler != null) {
        return customHandler(body);
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Result(
          type: ApiResultType.success,
          statusCode: response.statusCode,
          message: body["message"],
          meta: body["meta"] != null
              ? PaginationMeta.fromJson(body["meta"])
              : null,
          raw: body,
          data: parser == null ? null : parser(body["data"]),
        );
      }

      return Result(
        type: ApiResultType.failed,
        statusCode: response.statusCode,
        message: ApiErrorParser.extractMessage(body),
      );
    } catch (e) {
      return Result(type: ApiResultType.failed, message: e.toString());
    }
  }
}
