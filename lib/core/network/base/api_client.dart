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
