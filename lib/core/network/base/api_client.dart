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
    log("response:---> ${response.data}");
    log("response:---> ${ApiResponseHandler.handle(response, reqName)}");

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
    Map<String, dynamic>? headers, // 👇 add this
    bool disableCompression = false,
  }) async {
    final token = getToken;
    if (token == null || token.isEmpty) {
      log("❌ patchWithFile aborted: no token");
      return null;
    }

    final data = dio.FormData();

    // ─── FILES ─────────────────────────────
    if (file != null) {
      dio.MultipartFile multipart;

      if (disableCompression) {
        multipart = dio.MultipartFile.fromFileSync(
          file.value.path,
          filename: file.value.name,
        );
      } else {
        final compressed = await MultipartHelper.compressedImage(
          File(file.value.path),
        );

        multipart =
            compressed ??
            dio.MultipartFile.fromFileSync(
              file.value.path,
              filename: file.value.name,
            );
      }

      data.files.add(MapEntry(file.key, multipart));
    }

    for (final f in files ?? []) {
      dio.MultipartFile multipart;

      if (disableCompression) {
        multipart = dio.MultipartFile.fromFileSync(
          f.value.path,
          filename: f.value.name,
        );
      } else {
        final compressed = await MultipartHelper.compressedImage(
          File(f.value.path),
        );

        multipart =
            compressed ??
            dio.MultipartFile.fromFileSync(
              f.value.path,
              filename: f.value.name,
            );
      }

      data.files.add(MapEntry(f.key, multipart));
    }

    fields?.forEach((k, v) => data.fields.add(MapEntry(k, v)));

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

    // ─── REQUEST DEBUG LOG ─────────────────────────────
    log("━━━━━━━━ PATCH WITH FILE ━━━━━━━━");
    log("URL: $url");
    log("REQ_NAME: $reqName");
    log("TOKEN: ${token.substring(0, token.length > 8 ? 8 : token.length)}...");
    log("FIELDS: ${data.fields}");
    log("FILES: ${data.files.map((e) => e.key).toList()}");
    log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    final options = Options(
      method: 'PATCH',
      headers: {"Authorization": "Bearer $token", ...?headers},
    );

    try {
      final response = await _dio.request(url, data: data, options: options);

      log("✅ RESPONSE STATUS: ${response.statusCode}");
      log("RESPONSE DATA: ${response.data}");

      return ApiResponseHandler.handle(response, reqName);
    } on DioException catch (e, stackTrace) {
      // ─── DIO ERROR DEEP LOG ─────────────────────────────
      log("━━━━━━━━ DIO EXCEPTION ━━━━━━━━");
      log("TYPE: ${e.type}");
      log("MESSAGE: ${e.message}");
      log("ERROR: ${e.error}");
      log("STATUS CODE: ${e.response?.statusCode}");
      log("RESPONSE DATA: ${e.response?.data}");
      log("REQUEST PATH: ${e.requestOptions.path}");
      log("REQUEST METHOD: ${e.requestOptions.method}");
      log("REQUEST HEADERS: ${e.requestOptions.headers}");
      log("STACKTRACE: $stackTrace");
      log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      // 🔥 EXTRA: backend stack (MOST IMPORTANT FOR YOU)
      if (e.response?.data is Map) {
        final data = e.response?.data;
        log("🔥 BACKEND MESSAGE: ${data['message']}");
        log("🔥 BACKEND STACK:\n${data['stack']}");
        log("🔥 ERROR DETAILS: ${data['errorDetails']}");
      }

      return ApiResponseHandler.handle(
        Response(
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode ?? 500,
          data: e.response?.data ?? {"message": e.message},
        ),
        reqName,
      );
    } catch (e, stackTrace) {
      // ─── NON-DIO ERROR ─────────────────────────────
      log("━━━━━━━━ UNKNOWN EXCEPTION ━━━━━━━━");
      log("ERROR: $e");
      log("STACKTRACE: $stackTrace");
      log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      return null;
    }
  }

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
