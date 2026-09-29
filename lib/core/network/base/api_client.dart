import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_mama/core/network/helpers/header_helpers.dart';

import '../../helpers/image_helper.dart';
import 'dio_client.dart';

class ApiClient {
  final Dio _dio = DioClient().dio;

  Future<Response?> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: query,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post(
        url,
        data: data,
        options: Options(headers: headers ?? HeaderHelpers.getAuthHeader()),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.patch(
        url,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> patchWithFile(
    String url, {
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, String>? fields,
    Map<String, dynamic>? headers,
    List<MapEntry<String, String>>? extraFields,
  }) async {
    try {
      final form = FormData();

      if (file != null) {
        form.files.add(
          MapEntry(file.key, await MultipartHelper.anyFile(file.value)),
        );
      }

      for (final f in files ?? []) {
        form.files.add(MapEntry(f.key, await MultipartHelper.anyFile(f.value)));
      }

      fields?.forEach((k, v) {
        form.fields.add(MapEntry(k, v));
      }); // Duplicate fields
      if (extraFields != null) {
        form.fields.addAll(extraFields);
      }

      return await _dio.patch(
        url,
        data: form,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<Response?> postWithFile(
    String url, {
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, dynamic>? fields,
    List<MapEntry<String, String>>? extraFields,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final form = FormData();

      // Single file
      if (file != null) {
        form.files.add(
          MapEntry(file.key, await MultipartHelper.anyFile(file.value)),
        );
      }

      // Multiple files
      for (final f in files ?? []) {
        form.files.add(MapEntry(f.key, await MultipartHelper.anyFile(f.value)));
      }

      // Normal fields
      fields?.forEach((key, value) {
        if (value == null) return;
        form.fields.add(MapEntry(key, value.toString()));
      });

      // Duplicate fields
      if (extraFields != null) {
        form.fields.addAll(extraFields);
      }

      return await _dio.post(
        url,
        data: form,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      return e.response;
    }
  }
}
/*
class ApiClient {
  final Dio _dio = DioClient().dio;

  /// GET request
  Future<dynamic> get(
    String url, {
    String? reqName,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool showResponse = false,
  }) {
    return _safeRequest(() async {
      print("🌐 GET URL: $url");

      final response = await _dio.get(
        url,
        queryParameters: query,
        options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
      );
      if (showResponse) {
        ApiLogger.response(
          url: url,
          method: "GET",
          statusCode: response.statusCode ?? 0,
          body: response.data,
        );
      }

      // 🔥 Final parsed response returned by ApiResponseHandler
      return ApiResponseHandler.handle(response, reqName);
    });
  }

  /// POST request
  Future<dynamic> post(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
    bool? isLogin_,
    bool showResponse = false,
  }) {
    return _safeRequest(() async {
      print("🌐 POST URL: $url");

      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
      );

      if (showResponse) {
        ApiLogger.response(
          url: url,
          method: "POST",
          statusCode: response.statusCode ?? 0,
          body: response.data,
        );
      }

      // 🔥 Final parsed response returned by ApiResponseHandler
      return ApiResponseHandler.handle(response, reqName, isLogin_: isLogin_);
    });
  }

  Future<dynamic> patch(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    return _safeRequest(() async {
      print("🌐 PATCH URL: $url");
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
        print("PATCH request error: $e");
        return null;
      }
    });
  }

  Future<dynamic> patchWithFile(
    String url, {
    String? reqName,
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, String>? fields,
    Map<String, dynamic>? headers, // 👇 add this
    bool disableCompression = false,
    bool showResponse = false,
  }) {
    return _safeRequest(() async {
      print("🌐 PATCHWith file URL: $url");
      final token = getToken;
      if (token == null || token.isEmpty) {
        print("❌ patchWithFile aborted: no token");
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
      print("━━━━━━━━ PATCH WITH FILE ━━━━━━━━");
      print("URL: $url");
      print("REQ_NAME: $reqName");
      print(
        "TOKEN: ${token.substring(0, token.length > 8 ? 8 : token.length)}...",
      );
      print("FIELDS: ${data.fields}");
      print("FILES: ${data.files.map((e) => e.key).toList()}");
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      final options = Options(
        method: 'PATCH',
        headers: {"Authorization": "Bearer $token", ...?headers},
      );

      try {
        final response = await _dio.request(url, data: data, options: options);

        if (showResponse) {
          ApiLogger.response(
            url: url,
            method: "PATCH",
            statusCode: response.statusCode ?? 0,
            body: response.data,
          );
        }

        return ApiResponseHandler.handle(response, reqName);
      } on DioException catch (e, stackTrace) {
        // ─── DIO ERROR DEEP LOG ─────────────────────────────
        print("━━━━━━━━ DIO EXCEPTION ━━━━━━━━");
        print("TYPE: ${e.type}");
        print("MESSAGE: ${e.message}");
        print("ERROR: ${e.error}");
        print("STATUS CODE: ${e.response?.statusCode}");
        print("RESPONSE DATA: ${e.response?.data}");
        print("REQUEST PATH: ${e.requestOptions.path}");
        print("REQUEST METHOD: ${e.requestOptions.method}");
        print("REQUEST HEADERS: ${e.requestOptions.headers}");
        print("STACKTRACE: $stackTrace");
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // 🔥 EXTRA: backend stack (MOST IMPORTANT FOR YOU)
        if (e.response?.data is Map) {
          final data = e.response?.data;
          print("🔥 BACKEND MESSAGE: ${data['message']}");
          print("🔥 BACKEND STACK:\n${data['stack']}");
          print("🔥 ERROR DETAILS: ${data['errorDetails']}");
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
        print("━━━━━━━━ UNKNOWN EXCEPTION ━━━━━━━━");
        print("ERROR: $e");
        print("STACKTRACE: $stackTrace");
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        return null;
      }
    });
  }

  Future<dynamic> postWithFile(
    String url, {
    String? reqName,
    MapEntry<String, XFile>? file,
    List<MapEntry<String, XFile>>? files,
    Map<String, dynamic>? fields,
    List<MapEntry<String, String>>? extraFields,
    Map<String, dynamic>? headers,
  }) {
    return _safeRequest(() async {
      print("🌐 POST with file URL: $url");

      final data = dio.FormData();

      // single file
      if (file != null) {
        final multipart = await MultipartHelper.anyFile(file.value);
        data.files.add(MapEntry(file.key, multipart));
      }

      // multiple files
      for (final f in files ?? []) {
        final multipart = await MultipartHelper.anyFile(f.value);
        data.files.add(MapEntry(f.key, multipart));
      }

      // ✅ dynamic fields support
      // fields?.forEach((key, value) {
      //   if (value == null) return;
      //   data.fields.add(MapEntry(key, value));
      // });
      fields?.forEach((key, value) {
        if (value == null) return;
        data.fields.add(MapEntry(key, value.toString()));
      });

      // extra fields (still string-based)
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
        print("POST request error: $e");
        return null;
      }
    });
  }

  /// PUT request
  Future<dynamic> put(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
  }) {
    return _safeRequest(() async {
      print("🌐 PUT file URL: $url");
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
      );

      return ApiResponseHandler.handle(response, reqName);
    });
  }

  /// DELETE request
  Future<dynamic> delete(
    String url, {
    String? reqName,
    dynamic data,
    Map<String, String>? headers,
  }) {
    return _safeRequest(() async {
      print("🌐 DELETE file URL: $url");
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers ?? HeaderHelpers.jsonHeader()),
      );

      return ApiResponseHandler.handle(response, reqName);
    });
  }

  Future<T?> _safeRequest<T>(Future<T> Function() request) async {
    final canProceed = await NetworkGuard.canProceed();

    if (!canProceed) return null;

    return await request();
  }
}
*/

/* Curr:
Service
  ↓
ApiServiceHelper
  ↓
ApiClient
  ↓
ApiResponseHandler
  ↓
ApiErrorParser
  ↓
Dio interceptor
  ↓
Toast / Logout / Exception

*/

// recommended:
/*
Service
   |
   | returns Result<T>
   |
ApiRepository
   |
   | parses model
   |
ApiClient
   |
   | only Dio calls
   |
DioClient
   |
   | only networking/auth interceptor
   */
