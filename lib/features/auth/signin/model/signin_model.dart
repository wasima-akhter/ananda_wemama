import '../../../../core/network/models/common_models.dart';

class SigninModelData {
  final User user;
  final String accessToken;

  SigninModelData({required this.user, required this.accessToken});

  factory SigninModelData.fromJson(Map<String, dynamic> json) =>
      SigninModelData(user: User.fromJson(json['user']), accessToken: json['accessToken'] ?? '');
}
