import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../app/helper_widgets_export.dart' hide Response;

class ApiServiceHelper {
  /// Generic request handler
  ///
  /*
  Future<BaseResponse<T>?> request<T>({
    required Future<dynamic> Function() apiCall,
    T Function(dynamic)? parser,
    String? reqName,
    bool? isLogin_,
    bool? showErrorToast,
    bool? showRawResponse,
  }) async {
    try {
      final res = await apiCall();

      if (showRawResponse == true) {
        _prettyPrintResponse(res, reqName);
      }

      if (res == null) {
        if (showErrorToast == null) {
          Strings.somethingWentWrong.showToast();
        }
        return null;
      }

      final bool isLogin = isLogin_ ?? false;

      // 🔐 LOGIN SPECIAL FLOW
      if (isLogin) {
        log("🔐 LOGIN FLOW → parsing raw response");

        final json = _extractJson(res);

        if (json == null) {
          log("❌ LOGIN RESPONSE INVALID JSON: $res");
          return null;
        }

        return BaseResponse<T>.fromJson(json, parser);
      }

      // ✅ NORMAL FLOW
      final json = _extractJson(res);

      if (json == null) {
        log("❌ INVALID API RESPONSE FORMAT");
        return null;
      }

      final response = BaseResponse<T>.fromJson(json, parser);

      return response;
    } catch (e, st) {
      log("❌ API SERVICE ERROR: $e");
      log(st.toString());

      if (showErrorToast == null) {
        Strings.somethingWentWrong.showToast();
      }

      return null;
    }
  }
*/
  //
  void _prettyPrintResponse(dynamic res, String? reqName) {
    log("""
━━━━━━━━ API RAW RESPONSE ━━━━━━━━
REQ: ${reqName ?? "-"}
TYPE: ${res.runtimeType}
${const JsonEncoder.withIndent('  ').convert(res is Response ? res.data : res)}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
""");
  }

  Map<String, dynamic>? _extractJson(dynamic res) {
    try {
      if (res is Response) {
        final data = res.data;

        if (data is Map<String, dynamic>) {
          return data;
        }

        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }

        return null;
      }

      if (res is Map<String, dynamic>) {
        return res;
      }

      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }

      return null;
    } catch (e) {
      log("❌ JSON extraction failed: $e");
      return null;
    }
  }
}
