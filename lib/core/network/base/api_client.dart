import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mama_app/app/controller_export.dart' hide Response;

import '../../helpers/image_helper.dart';
import '../../local/app_storage.dart';
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
          {"Authorization": "Bearer $getToken", ...?headers},
      // ❌ Don't set contentType for FormData - Dio handles it
      contentType: 'application/json',
      // contentType: "multipart/form-data; boundary=<calculated when request is sent>",
      // data is dio.FormData ? null : 'application/json',
    );

    try {
      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      log("PATCH request error: $e");
      return null;
    }
  }
  //old
  // Future<dynamic> patchWithFile(
  //   String url, {
  //   String? reqName,
  //   dynamic data,
  //   Map<String, dynamic>? headers,
  // }) async {
  //   // For FormData, don't set Content-Type - let Dio handle it automatically
  //   final options = Options(method: 'PATCH', headers: {"Authorization": "Bearer $getToken"});

  //   try {
  //     log("DATA TYPE: ${data.runtimeType}");

  //     final response = await _dio.request(url, data: data, options: options);

  //     log('response in patch  : $response ');
  //     return ApiResponseHandler.handle(response, reqName);
  //   } catch (e) {
  //     log("PATCH request error: $e");
  //     return null;
  //   }
  // }

  //final
  /*
  Future<dynamic> patchWithFile(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    /// ✅ FILE SIZE VALIDATION
    final isValid = await validateFileSize(data);

    if (!isValid) {
      return ApiResponseHandler.handle(
        Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 400,
          data: {"message": "File size must be less than 3 MB"},
        ),
        reqName,
      );
    }

    final options = Options(
      method: 'PATCH',
      headers: {"Authorization": "Bearer $getToken"},
    );

    try {
      log("DATA TYPE: ${data.runtimeType}");

      final response = await _dio.request(url, data: data, options: options);

      log('response in patch  : $response ');

      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      log("PATCH request error: $e");
      return null;
    }
  }
*/

  // generic

  Future<dynamic> patchWithFile2(
    String url, {
    String? reqName,
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, String>? fields,
  }) async {
    final token = AppStorage.to.getToken;
    if (token.isEmpty) {
      log("❌ patchWithFile aborted: no token");
      return null;
    }

    try {
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('PATCH', uri);

      // ✅ Auth header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // ✅ Fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // ✅ Single file (profile-image)
      if (file != null) {
        final bytes = await File(file.value.path).readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            file.key,
            bytes,
            filename: file.value.name,
            contentType: imageMediaType(file.value.path), // 👈 add this
          ),
        );
      }

      // ✅ Multiple files (description-image)
      for (final f in files ?? []) {
        final bytes = await File(f.value.path).readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            f.key,
            bytes,
            filename: f.value.name,
            contentType: imageMediaType(f.value.path), // 👈 add this
          ),
        );
      }
      // ✅ Log request
      log("➡️ REQUEST[PATCH] => $url");
      log("Headers: ${request.headers}");
      log("Fields: ${request.fields}");
      log(
        "Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}",
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("✅ RESPONSE[${response.statusCode}] => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return ApiResponseHandler.handle(
          Response(
            requestOptions: RequestOptions(path: url),
            statusCode: response.statusCode,
            data: decoded,
          ),
          reqName,
        );
      } else {
        log("❌ ERROR[${response.statusCode}] => ${response.body}");
        return null;
      }
    } catch (e) {
      log("PATCH request error: $e");
      return null;
    }
  }

  Future<dynamic> patchWithFile(
    String url, {
    String? reqName,
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, String>? fields,
    Map<String, dynamic>? headers,
  }) async {
    // ✅ Guard: don't proceed if no token
    final token = getToken;
    if (token == null || token.isEmpty) {
      log("❌ patchWithFile aborted: no token");
      return null;
    }
    final data = dio.FormData();

    if (file != null) {
      final compressed = await MultipartHelper.compressedImage(
        File(file.value.path),
      );
      // ← fallback to original if compression fails
      final multipart =
          compressed ??
          dio.MultipartFile.fromFileSync(
            file.value.path,
            filename: file.value.name,
          );
      data.files.add(MapEntry(file.key, multipart));
    }

    for (final f in files ?? []) {
      final compressed = await MultipartHelper.compressedImage(
        File(f.value.path),
      );
      // ← fallback to original if compression fails
      final multipart =
          compressed ??
          dio.MultipartFile.fromFileSync(f.value.path, filename: f.value.name);
      data.files.add(MapEntry(f.key, multipart));
    }
    fields?.forEach((key, value) => data.fields.add(MapEntry(key, value)));

    final isValid = await validateFileSize(data);
    if (!isValid) {
      return ApiResponseHandler.handle(
        Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 400,
          data: {"message": "File size must be less than 3 MB"},
        ),
        reqName,
      );
    }

    log("── patchWithFile token: '$token'"); // ← add this

    final options = Options(
      method: 'PATCH',
      headers: {"Authorization": "Bearer $getToken"},
    );

    try {
      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      log("PATCH request error: $e");
      return null;
    }
  }

  // Future<dynamic> postWithFile(
  //   String url, {
  //   String? reqName,
  //   dynamic data,
  //   Map<String, dynamic>? headers,
  // }) async {
  //   // For FormData, don't set Content-Type - let Dio handle it automatically
  //   final options = Options(
  //     method: 'POST',
  //     headers: {"Authorization": "Bearer $getToken"},
  //   );

  //   try {
  //     log("DATA TYPE: ${data.runtimeType}");

  //     final response = await _dio.request(url, data: data, options: options);
  //     log('response in post  : $response ');
  //     return ApiResponseHandler.handle(response, reqName);
  //   } catch (e) {
  //     log("POST request error: $e");
  //     return null;
  //   }
  // }

  /* old
  Future<dynamic> postWithFile(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    /// ✅ FILE SIZE VALIDATION
    final isValid = await validateFileSize(data);

    if (!isValid) {
      return ApiResponseHandler.handle(
        Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 400,
          data: {"message": "File size must be less than 3 MB"},
        ),
        reqName,
      );
    }

    final options = Options(
      method: 'POST',
      headers: {"Authorization": "Bearer $getToken"},
    );

    try {
      log("DATA TYPE: ${data.runtimeType}");

      final response = await _dio.request(url, data: data, options: options);

      log('response in post  : $response ');

      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      log("POST request error: $e");
      return null;
    }
  }
*/

  // with any file comppression:
  Future<dynamic> postWithFile(
    String url, {
    String? reqName,
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, String>? fields,
    List<MapEntry<String, String>>? extraFields,
    Map<String, dynamic>? headers,
  }) async {
    final data = dio.FormData();

    if (file != null) {
      final multipart = await MultipartHelper.anyFile(file.value);
      data.files.add(MapEntry(file.key, multipart));
    }

    for (final f in files ?? []) {
      final multipart = await MultipartHelper.anyFile(f.value);
      data.files.add(MapEntry(f.key, multipart));
    }

    fields?.forEach((key, value) => data.fields.add(MapEntry(key, value)));
    extraFields?.forEach((entry) => data.fields.add(entry));

    final isValid = await validateFileSize(data);
    if (!isValid) {
      return ApiResponseHandler.handle(
        Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 400,
          data: {"message": "File size must be less than 3 MB"},
        ),
        reqName,
      );
    }

    final options = Options(
      method: 'POST',
      headers: {"Authorization": "Bearer $getToken"},
    );

    try {
      final response = await _dio.request(url, data: data, options: options);
      return ApiResponseHandler.handle(response, reqName);
    } catch (e) {
      log("POST request error: $e");
      return null;
    }
  }
  // Future<dynamic> postWithFile(
  //   String url, {
  //   String? reqName,
  //   MapEntry<String, XFile>? file,
  //   List<MapEntry<String, XFile>>? files,
  //   Map<String, String>? fields,
  //   List<MapEntry<String, String>>? extraFields,
  //   Map<String, dynamic>? headers,
  // }) async {
  //   final data = dio.FormData();

  //   if (file != null) {
  //     final compressed = await MultipartHelper.compressedImage(
  //       File(file.value.path),
  //     );
  //     if (compressed != null) data.files.add(MapEntry(file.key, compressed));
  //   }

  //   for (final f in files ?? []) {
  //     final compressed = await MultipartHelper.compressedImage(
  //       File(f.value.path),
  //     );
  //     if (compressed != null) data.files.add(MapEntry(f.key, compressed));
  //   }

  //   fields?.forEach((key, value) => data.fields.add(MapEntry(key, value)));
  //   extraFields?.forEach((entry) => data.fields.add(entry));

  //   final isValid = await validateFileSize(data);
  //   if (!isValid) {
  //     return ApiResponseHandler.handle(
  //       Response(
  //         requestOptions: RequestOptions(path: url),
  //         statusCode: 400,
  //         data: {"message": "File size must be less than 3 MB"},
  //       ),
  //       reqName,
  //     );
  //   }

  //   final options = Options(
  //     method: 'POST',
  //     headers: {"Authorization": "Bearer $getToken"},
  //   );

  //   try {
  //     final response = await _dio.request(url, data: data, options: options);
  //     return ApiResponseHandler.handle(response, reqName);
  //   } catch (e) {
  //     log("POST request error: $e");
  //     return null;
  //   }
  // }

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
