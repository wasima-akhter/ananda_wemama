class SignUpModelData {
  final String email;
  final String? accessToken;

  SignUpModelData({required this.email, this.accessToken});

  factory SignUpModelData.fromJson(Map<String, dynamic> json) =>
      SignUpModelData(email: json['email'], accessToken: json['accessToken'] ?? '');
}

class SigninUser {
  final String? email;

  SigninUser({this.email});

  factory SigninUser.fromJson(Map<String, dynamic> json) => SigninUser(email: json['email'] ?? '');
}
