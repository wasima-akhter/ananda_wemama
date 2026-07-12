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
    this.isEmailVerified,
    this.isProfileCompleted,
    this.msg,
  });

  factory SigninModelData.fromJson(Map<String, dynamic> json) {
    // json is already the inner data object
    return SigninModelData(
      user: json["user"] != null ? SigninUser.fromJson(json["user"]) : null,
      accessToken: json["accessToken"],
      statusCode: json["statusCode"],
      isEmailVerified: json["isEmailVerified"], // null on success = fine
      isProfileCompleted: json["isProfileCompleted"], // null on success = fine
      msg: json["msg"] ?? json["message"],
    );
  }

  //
}

class SigninUser {
  final String? email;

  SigninUser({this.email});

  factory SigninUser.fromJson(Map<String, dynamic> json) =>
      SigninUser(email: json['email'] ?? '');
}

enum LoginApiResultType { success, emailNotVerified, profileIncomplete, failed }

class LoginResult {
  final LoginApiResultType type;
  final String? message;

  LoginResult({required this.type, this.message});
}
