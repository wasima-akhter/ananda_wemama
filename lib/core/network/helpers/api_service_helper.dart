import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../app/helper_widgets_export.dart' hide Response;
import '../base/api_client.dart';
import '../models/base_response_model.dart';

class ApiServiceHelper {
  final ApiClient _apiClient = ApiClient();

  /// Generic request handler
  Future<BaseResponse<T>?> request<T>({
    required Future<dynamic> Function() apiCall,
    T Function(dynamic)? parser,
  }) async {
    try {
      final res = await apiCall();

      //
      if (res == null) {
        "No response from server".showToast();
        return null;
      }
      // ✅ extract .data if it's a Dio Response
      final Map<String, dynamic> json;
      if (res is Response) {
        json = res.data as Map<String, dynamic>;
      } else if (res is Map<String, dynamic>) {
        json = res;
      } else {
        json = res;
      }

      log("res before calling BaseResponse: $json");

      final response = BaseResponse<T>.fromJson(res, parser);

      response.message.capEachWord().showToast();
      return response;
    } catch (e) {
      String errorMsg = "Something went wrong. Please try again.";

      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            errorMsg = "Connection timed out. Check your internet.";
            break;
          case DioExceptionType.cancel:
            errorMsg = "Request was canceled.";
            break;
          case DioExceptionType.badResponse:
            if (e.response?.data is Map && e.response!.data["message"] != null) {
              errorMsg = e.response!.data["message"].toString();
            } else {
              errorMsg = "Server error. Please try again later.";
            }
            break;
          case DioExceptionType.unknown:
            errorMsg = "Unable to connect. Check your internet.";
            break;
          default:
            errorMsg = "Something went wrong. Please try again.";
        }
      }

      errorMsg.showToast();
      return null;
    }
  }
}
