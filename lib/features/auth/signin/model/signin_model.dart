class SigninModelData {
  final SigninUser? user;
  final String? accessToken;

  final int? statusCode;
  final bool? isEmailVerified;
  final bool? isProfileCompleted;
  final String? msg;

  SigninModelData({
    this.user,
    this.accessToken,
    this.statusCode,
    this.isEmailVerified = false,
    this.isProfileCompleted = false,
    this.msg,
  });

  factory SigninModelData.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return SigninModelData(
      user: data["user"] != null ? SigninUser.fromJson(data["user"]) : null,

      accessToken: data["accessToken"],

      statusCode: data["statusCode"],
      isEmailVerified: data["isEmailVerified"],
      isProfileCompleted: data["isProfileCompleted"],
      msg: data["msg"] ?? json["message"],
    );
  }
}

class SigninUser {
  final String? email;

  SigninUser({this.email});

  factory SigninUser.fromJson(Map<String, dynamic> json) =>
      SigninUser(email: json['email'] ?? '');
}

enum LoginResultType { success, emailNotVerified, profileIncomplete, failed }

class LoginResult {
  final LoginResultType type;
  final String? message;

  LoginResult({required this.type, this.message});
}
