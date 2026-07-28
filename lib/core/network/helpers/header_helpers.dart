import 'package:dio/dio.dart';
import 'package:we_mama/core/network/helpers/network_helpers.dart';

class HeaderHelpers {
  /// Returns normal JSON headers
  /// If [token] is provided, adds Authorization Bearer
  static Map<String, String> jsonHeader() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return headers;
  }

  static Map<String, String> getAuthHeader() {
    final token = getToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Returns headers for sending files only (multipart)
  /// [token] optional
  static dynamic fileHeader() {
    var headers;

    final token = getToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Convert Map<String, String> to Dio Headers
  static Options dioOptions({Map<String, String>? headers}) {
    return Options(headers: headers ?? {});
  }
}
