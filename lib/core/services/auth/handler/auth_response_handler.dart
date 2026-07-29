import 'package:dio/dio.dart';

import '../../../../features/auth/signin/model/signin_model.dart';
import '../../../network/base/dio_client.dart';
import '../../../utils/extension/context_extension.dart';

class AuthResponseHandler {
  static Result<SigninModelData> parse(
    Map<String, dynamic> body, {
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
  }) {
    if (body["success"] == false) {
      final message = body["message"]?.toString();

      if (showErrorMessage && message != null) {
        Snack.showError(message);
      }

      return Result(type: ApiResultType.failed, message: message);
    }

    final model = SigninModelData.fromJson(body["data"] ?? {});

    if (model.statusCode == 403 || model.isEmailVerified == false) {
      if (showErrorMessage && (model.msg?.isNotEmpty ?? false)) {
        Snack.showError(model.msg!);
      }
      return Result(
        type: ApiResultType.emailNotVerified,
        data: model,
        message: model.msg,
      );
    }

    if (model.statusCode == 302 || model.isProfileCompleted == false) {
      // Not an error, but not a full success either — usually worth
      // surfacing so the user understands why they're being redirected.
      if (showErrorMessage && (model.msg?.isNotEmpty ?? false)) {
        Snack.showError(model.msg!);
      }
      return Result(
        type: ApiResultType.profileIncomplete,
        data: model,
        message: model.msg,
      );
    }

    if (showSuccessMessage && (model.msg?.isNotEmpty ?? false)) {
      Snack.showSuccess(model.msg!);
    }

    return Result(type: ApiResultType.success, data: model, message: model.msg);
  }

  static LoginStatus check(
    Response response, {
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
  }) {
    final statusCode = response.statusCode ?? 0;
    final body = response.data;
    final message = body["message"]?.toString();

    if (statusCode == 403) {
      if (showErrorMessage && (message?.isNotEmpty ?? false)) {
        Snack.showError(message!);
      }
      return LoginStatus.emailNotVerified(message);
    }

    if (statusCode == 404) {
      if (showErrorMessage && (message?.isNotEmpty ?? false)) {
        Snack.showError(message!);
      }
      return LoginStatus.failed(message);
    }

    if (statusCode == 302) {
      if (showErrorMessage && (message?.isNotEmpty ?? false)) {
        Snack.showError(message!);
      }
      return LoginStatus.profileIncomplete(
        accessToken: body["data"]?["accessToken"],
        message: message,
      );
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (showSuccessMessage && (message?.isNotEmpty ?? false)) {
        Snack.showSuccess(message!);
      }
      return LoginStatus.success(body["data"]);
    }

    if (showErrorMessage && (message?.isNotEmpty ?? false)) {
      Snack.showError(message!);
    }
    return LoginStatus.failed(message);
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
