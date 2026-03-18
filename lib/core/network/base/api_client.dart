import 'package:dio/dio.dart';
import 'package:mama_app/app/controller_export.dart';

import '../helpers/header_helpers.dart';
import 'api_response_handler.dart';
import 'dio_client.dart';

class ApiClient {
  final Dio _dio = DioClient().dio;

  /// GET request
  Future<dynamic> get(
    String url, {
    String? reqName,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: query,
      options: Options(
        headers: headers ?? HeaderHelpers.jsonHeader(), // default if null
      ),
    );

    return ApiResponseHandler.handle(response, reqName);
  }

  /// POST request
  Future<dynamic> post(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.post(
      url,
      data: data,
      options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
    );

    return ApiResponseHandler.handle(response, reqName);
  }

  Future<dynamic> patch(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    // For FormData, don't set Content-Type - let Dio handle it automatically
    final options = Options(
      method: 'PATCH',
      headers:
          //  {"Authorization": "Bearer ${getToken}"},
          {"Authorization": "Bearer ${getToken}", ...?headers},
      // ❌ Don't set contentType for FormData - Dio handles it
      contentType: 'application/json',
      // contentType: "multipart/form-data; boundary=<calculated when request is sent>",
      // data is dio.FormData ? null : 'application/json',
    );

    try {
      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      print("PATCH request error: $e");
      return null;
    }
  }

  Future<dynamic> patchWithFile(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    // For FormData, don't set Content-Type - let Dio handle it automatically
    final options = Options(method: 'PATCH', headers: {"Authorization": "Bearer $getToken"});

    try {
      print("DATA TYPE: ${data.runtimeType}");

      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      print("PATCH request error: $e");
      return null;
    }
  }

  Future<dynamic> postWithFile(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    // For FormData, don't set Content-Type - let Dio handle it automatically
    final options = Options(method: 'POST', headers: {"Authorization": "Bearer $getToken"});

    try {
      print("DATA TYPE: ${data.runtimeType}");

      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      print("PATCH request error: $e");
      return null;
    }
  }

  /// PUT request
  Future<dynamic> put(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.put(
      url,
      data: data,
      options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
    );

    return ApiResponseHandler.handle(response, reqName);
  }

  /// DELETE request
  Future<dynamic> delete(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.delete(
      url,
      data: data,
      options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
    );

    return ApiResponseHandler.handle(response, reqName);
  }
}
