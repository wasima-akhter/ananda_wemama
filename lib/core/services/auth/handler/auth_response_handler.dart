import 'package:dio/dio.dart';

import '../../../../features/auth/signin/model/signin_model.dart';
import '../../../network/base/dio_client.dart';

class AuthResponseHandler {
  static Result<SigninModelData> parse(Map<String, dynamic> body) {
    final model = SigninModelData.fromJson(body["data"] ?? {});

    if (model.statusCode == 403 || model.isEmailVerified == false) {
      return Result(
        type: ApiResultType.emailNotVerified,
        data: model,
        message: model.msg,
      );
    }

    if (model.statusCode == 302 || model.isProfileCompleted == false) {
      return Result(
        type: ApiResultType.profileIncomplete,
        data: model,
        message: model.msg,
      );
    }

    if ((model.accessToken ?? "").isEmpty) {
      return Result(
        type: ApiResultType.failed,
        message: "Access token missing",
      );
    }

    return Result(type: ApiResultType.success, data: model, message: model.msg);
  }

  static LoginStatus check(Response response) {
    final statusCode = response.statusCode ?? 0;

    final body = response.data;

    if (statusCode == 403) {
      return LoginStatus.emailNotVerified(body["message"]);
    }

    if (statusCode == 302) {
      return LoginStatus.profileIncomplete(
        accessToken: body["data"]?["accessToken"],
        message: body["message"],
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      return LoginStatus.success(body["data"]);
    }

    return LoginStatus.failed(body["message"]);
  }
}

enum AuthStatusType { success, emailNotVerified, profileIncomplete, failed }

class LoginStatus {
  final AuthStatusType type;

  final dynamic data;

  final String? message;

  final String? token;

  LoginStatus({required this.type, this.data, this.message, this.token});

  factory LoginStatus.success(dynamic data) {
    return LoginStatus(type: AuthStatusType.success, data: data);
  }

  factory LoginStatus.emailNotVerified(String? msg) {
    return LoginStatus(type: AuthStatusType.emailNotVerified, message: msg);
  }

  factory LoginStatus.profileIncomplete({
    String? accessToken,
    String? message,
  }) {
    return LoginStatus(
      type: AuthStatusType.profileIncomplete,
      token: accessToken,
      message: message,
    );
  }

  factory LoginStatus.failed(String? msg) {
    return LoginStatus(type: AuthStatusType.failed, message: msg);
  }
}
