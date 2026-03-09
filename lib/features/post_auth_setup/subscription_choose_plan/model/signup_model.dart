import '../../../../core/network/models/common_models.dart';

class SignupModelData {
  SignupModelData({required this.newUser});

  final User? newUser;

  factory SignupModelData.fromJson(Map<String, dynamic> json) {
    return SignupModelData(
      newUser: json["newUser"] == null ? null : User.fromJson(json["newUser"]),
    );
  }
}
