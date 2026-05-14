class ForgotPassDataModel {
  ForgotPassDataModel({this.user, this.accessToken});

  final User? user;
  final String? accessToken;

  factory ForgotPassDataModel.fromJson(Map<String, dynamic> json) {
    return ForgotPassDataModel(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      accessToken: json["accessToken"],
    );
  }
}

class User {
  User({this.name, this.email, this.role});

  final String? name;
  final String? email;
  final String? role;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json["name"], email: json["email"], role: json["role"]);
  }
}
