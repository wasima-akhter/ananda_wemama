class SigninModelData {
  final SigninUser user;
  final String accessToken;

  SigninModelData({required this.user, required this.accessToken});

  factory SigninModelData.fromJson(Map<String, dynamic> json) => SigninModelData(
    user: SigninUser.fromJson(json['user']),
    accessToken: json['accessToken'] ?? '',
  );
}

class SigninUser {
  final String? email;

  SigninUser({this.email});

  factory SigninUser.fromJson(Map<String, dynamic> json) => SigninUser(email: json['email'] ?? '');
}
