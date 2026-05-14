import '../../../../core/network/models/common_models.dart';

class ThisModelData {
  ThisModelData({required this.newUser});

  final User? newUser;

  factory ThisModelData.fromJson(Map<String, dynamic> json) {
    return ThisModelData(newUser: json["newUser"] == null ? null : User.fromJson(json["newUser"]));
  }
}
